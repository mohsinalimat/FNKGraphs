//
//  FNKGraphsLineGraphViewController.m
//  Pods
//
//  Created by Phillip Connaughton on 1/11/15.
//
//

#import "FNKGraphsLineGraphViewController.h"

@interface FNKGraphsLineGraphViewController ()

/* xAxis - The X axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,strong) FNKXAxis* xAxis;

/* yAxis - The Y axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,strong) FNKYAxis* yAxis;

@property (nonatomic, weak) CAShapeLayer* lineLayer;
@property (nonatomic, weak) CAShapeLayer* comparisonLine;
@property (nonatomic) BOOL fillGraph;
@property (nonatomic) CGFloat yAxisNum;
@property (nonatomic) CGFloat xAxisNum;

//Graph variables
@property (nonatomic) CGFloat xScaleFactor;
@property (nonatomic) CGFloat yScaleFactor;
@property (nonatomic) CGFloat xRange;
@property (nonatomic) CGFloat yRange;

@end

@implementation FNKGraphsLineGraphViewController

#pragma mark view lifecycle

-(void)initializers
{
    self.xAxis = [[FNKXAxis alloc] initWithMarginLeft:self.marginLeft marginRight:self.marginRight marginTop:self.marginTop marginBottom:self.marginBottom];
    self.yAxis = [[FNKYAxis alloc] initWithMarginLeft:self.marginLeft marginRight:self.marginRight marginTop:self.marginTop marginBottom:self.marginBottom];
    self.yAxis.ticks = 5;
    self.xAxis.ticks = 5;
    self.yPadding = 0;
    self.selectedLineLayer  = [CAShapeLayer layer];
    self.selectedLineCircleLayer = [CAShapeLayer layer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.hasDrawn)
    {
        self.xAxis.graphHeight = self.graphHeight;
        self.yAxis.graphHeight = self.graphHeight;
        
        self.xAxis.graphWidth = self.graphWidth;
        self.yAxis.graphWidth = self.graphWidth;
        
        self.selectedLineLayer.strokeColor = [UIColor clearColor].CGColor;
        [self.view.layer addSublayer:self.selectedLineLayer];
        
        self.selectedLineCircleLayer.strokeColor = [UIColor clearColor].CGColor;
        self.selectedLineCircleLayer.fillColor = [UIColor clearColor].CGColor;
        [self.view.layer addSublayer:self.selectedLineCircleLayer];
        
        if(self.chartOverlay)
        {
            self.chartOverlay.marginBottom = self.marginBottom;
            self.chartOverlay.marginTop = self.marginTop;
            self.chartOverlay.marginRight = self.marginRight;
            self.chartOverlay.marginLeft = self.marginLeft;
            self.chartOverlay.graphWidth = self.graphWidth;
            self.chartOverlay.graphHeight = self.graphHeight;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.hasDrawn)
    {
        __weak __typeof(self) safeSelf = self;
        
        [self drawAxii:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [safeSelf loadData:self.dataArray];
            [safeSelf drawData];
            
            if (safeSelf.chartOverlay != nil)
            {
                [safeSelf.chartOverlay drawInView:safeSelf.view];
                safeSelf.yLabelView.userInteractionEnabled = false;
            }
            
        });
        self.hasDrawn = YES;
    }
}

-(void)loadData:(NSMutableArray*)data
{
    self.graphData = [NSMutableArray array];
    for(id obj in data)
    {
        [self.graphData addObject:[NSValue valueWithCGPoint:self.pointForObject(obj)]];
    }
    
    [self calcMaxMin:self.graphData];
    self.graphData = [self normalizePoints:self.graphData];
}

-(double)scaleYValue:(double)value
{
    //yVal needs to be the inverse bc of iOS coordinates
    return self.graphHeight + self.yAxis.marginTop - ((value - self.yAxisNum) * self.yScaleFactor);
}

-(void)willAppear
{
    self.selectedLineLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:self.selectedLineLayer];
    
    self.selectedLineCircleLayer.strokeColor = [UIColor clearColor].CGColor;
    self.selectedLineCircleLayer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:self.selectedLineCircleLayer];
}

-(void)drawData
{
    [self addTicks];
    
    __weak __typeof(self) safeSelf = self;
    self.lineLayer = [self drawLine:self.graphData
                              color:self.lineStrokeColor
                         completion:^{
                             double yValue = [safeSelf scaleYValue:safeSelf.averageLine];
                             [safeSelf drawAverageLine:yValue];
                         }];
}

-(void)drawAxii:(UIView*)view
{
    [self.yAxis drawAxis:view];
    
    //    [self.xAxis drawAxis:view];
}

-(void)addTicks
{
    self.yLabelView = [self.yAxis addTicksToView:self.view];
    self.xLabelView = [self.xAxis addTicksToView:self.view];
}

-(void)removeTicks
{
    [self.yLabelView removeFromSuperview];
    [self.xLabelView removeFromSuperview];
}

-(CAShapeLayer*)drawLine:(NSMutableArray*)data color:(UIColor*)color completion:(void (^)())completion
{
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.path = [self pathFromPoints:data].CGPath;
    layer.fillColor = nil;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = 2;
    layer.lineCap = @"round";
    layer.lineJoin = @"round";
    
    [self.view.layer insertSublayer:layer below:self.yLabelView.layer];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        completion();
    }];
    
    CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1;
    pathAnimation.fromValue = @(0);
    pathAnimation.toValue = @(1);
    
    [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    [CATransaction commit];
    
    return layer;
}

-(UIBezierPath*)pathFromPoints:(NSMutableArray*)data
{
    BOOL firstPoint = YES;
    
    UIBezierPath* bezPath = [[UIBezierPath alloc] init];
    
    if(self.fillGraph)
    {
        [bezPath moveToPoint:CGPointMake(0, self.graphHeight)];
        
        CGPoint lastPoint;
        
        for (NSValue* val in data)
        {
            CGPoint point = [val CGPointValue];
            [bezPath addLineToPoint:point];
            
            lastPoint = point;
        }
        
        [bezPath addLineToPoint:CGPointMake(lastPoint.x, self.graphHeight)];
        [bezPath closePath];
    }
    else
    {
        for (NSValue* val in data)
        {
            CGPoint point = [val CGPointValue];
            if (firstPoint)
            {
                [bezPath moveToPoint:point];
                firstPoint = false;
            }
            else
            {
                [bezPath addLineToPoint:point];
            }
        }
    }
    
    return bezPath;
}

-(CGFloat)valueAtPoint:(CGPoint)point
{
    CGFloat xValue = point.x;
    CGFloat yVal = 0;
    for (NSValue* val in self.graphData)
    {
        CGPoint point = [val CGPointValue];
        if(point.x >= xValue)
        {
            yVal = point.y;
            break;
        }
    }
    
    UIBezierPath* bezPath = [[UIBezierPath alloc] init];
    
    [bezPath moveToPoint:CGPointMake(point.x, self.yAxis.marginTop)];
    [bezPath addLineToPoint:CGPointMake(point.x, self.graphHeight + self.yAxis.marginTop)];
    
    self.selectedLineLayer.strokeColor = self.lineStrokeColor.CGColor;
    self.selectedLineLayer.path = bezPath.CGPath;
    
    CGFloat radius = 5;
    
    self.selectedLineCircleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - radius/2, yVal-radius/2, radius, radius)].CGPath;
    self.selectedLineCircleLayer.fillColor = self.lineStrokeColor.CGColor;
    self.selectedLineCircleLayer.strokeColor = self.lineStrokeColor.CGColor;
    
    return ((self.yAxis.marginTop + self.graphHeight - yVal) / self.yScaleFactor) + self.yAxisNum;
}

-(void)removeSelection
{
    self.selectedLineLayer.strokeColor = [UIColor clearColor].CGColor;
    self.selectedLineCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.selectedLineCircleLayer.strokeColor = [UIColor clearColor].CGColor;
}

-(void)showLineComparison:(NSMutableArray*)comparisonData color:(UIColor*)lineColor duration:(CGFloat)duration
{
    //Okay so now we need to run all of the data thru the normalizer again and get a new max and min for the graph
    NSMutableArray* allData = [NSMutableArray arrayWithArray:self.graphData];
    [allData addObjectsFromArray:comparisonData];
    [self calcMaxMin:allData];
    
    [self removeTicks];
    [self addTicks];
    
    //Draw the new line
    if(self.comparisonLine == nil)
    {
        NSMutableArray* data = [self normalizePoints:comparisonData];
        self.comparisonLine = [self drawLine:data
                                       color:lineColor
                                  completion:^{}];
    }
    else //Animate the line transition
    {
        [self transitionLine:self.comparisonLine
                        data:comparisonData
                    duration:duration];
    }
    
    [self transitionLine:self.lineLayer
                    data:self.graphData
                duration:duration];
}

-(void)filterLine:(NSMutableArray*)filteredData duration:(CGFloat)duration
{
    if(filteredData)
    {
        NSMutableArray* filteredGraphData = [NSMutableArray array];
        
        for(id obj in filteredData)
        {
            [filteredGraphData addObject:[NSValue valueWithCGPoint:self.pointForObject(obj)]];
        }
        
        [self calcMaxMin:filteredGraphData];
        
        [self removeTicks];
        [self addTicks];
        
        [self transitionLine:self.lineLayer
                        data:filteredGraphData
                    duration:duration];
    }
    else
    {
        [self.graphData removeAllObjects];
        
        for(id obj in self.dataArray)
        {
            [self.graphData addObject:[NSValue valueWithCGPoint:self.pointForObject(obj)]];
        }
        
        [self calcMaxMin:self.graphData];
        
        [self removeTicks];
        [self addTicks];
        
        [self transitionLine:self.lineLayer
                        data:self.graphData
                    duration:duration];
        
    }
}

-(void)transitionLine:(CAShapeLayer*)line data:(NSMutableArray*)data duration:(CGFloat)duration
{
    CGPathRef newPath = [self pathFromPoints:[self normalizePoints:data]].CGPath;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        //Need to do this, otherwise the next animation will start at the original value.
        [line setPath:newPath];
    }];
    
    CABasicAnimation *morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration  = duration; // Step 1
    //    morph.fromValue = (__bridge id) line.path;
    morph.toValue = (__bridge id) newPath;
    morph.autoreverses = NO;
    morph.fillMode = kCAFillModeForwards;
    morph.removedOnCompletion = NO;
    [line addAnimation:morph forKey:@"path"];
    
    [CATransaction commit];
}

-(void)calcMaxMin:(NSArray*)points
{
    CGFloat maxX= DBL_MIN;
    CGFloat minX = DBL_MAX;
    CGFloat maxY = DBL_MIN;
    CGFloat minY = DBL_MAX;
    
    for (NSValue* val in points)
    {
        CGPoint point = [val CGPointValue];
        if(point.x > maxX)
        {
            maxX = point.x;
        }
        
        if(point.x < minX)
        {
            minX = point.x;
        }
        
        if(point.y > maxY)
        {
            maxY = point.y;
        }
        
        if(point.y < minY)
        {
            minY = point.y;
        }
    }
    
    minY = minY - self.yPadding;
    
    self.yAxisNum = minY;
    self.xAxisNum = minX;
    
    maxY = maxY + self.yPadding;
    
    //Okay so now we have the min's and max's
    self.xRange = maxX - minX;
    self.yRange = maxY - minY;
    
    self.xScaleFactor = self.graphWidth / self.xRange;
    self.yScaleFactor = self.graphHeight / self.yRange;
    
    self.xAxis.scaleFactor = self.xScaleFactor;
    self.yAxis.scaleFactor = self.yScaleFactor;
    self.yAxis.axisMin = self.yAxisNum;
    self.xAxis.axisMin = self.xAxisNum;
}

-(NSMutableArray*)normalizePoints:(NSArray*)points
{
    NSMutableArray* scaledPoints = [NSMutableArray array];
    
    for (NSValue* val in points)
    {
        CGPoint point = [val CGPointValue];
        CGFloat xVal = ((point.x- self.xAxisNum) * self.xScaleFactor ) + self.yAxis.marginLeft;
        CGFloat yVal = [self scaleYValue:point.y];
        [scaledPoints addObject:[NSValue valueWithCGPoint:CGPointMake(xVal,yVal)]];
    }
    
    return scaledPoints;
}

-(void)drawAverageLine:(CGFloat)yVal
{
    if(self.averageLineColor)
    {
        UIBezierPath* bezPath = [[UIBezierPath alloc] init];
        [bezPath moveToPoint:CGPointMake(self.yAxis.marginLeft, yVal)];
        [bezPath addLineToPoint:CGPointMake(self.xAxis.graphWidth + self.yAxis.marginLeft, yVal)];
        
        CAShapeLayer* layer = [[CAShapeLayer alloc] init];
        layer.path = bezPath.CGPath;
        layer.fillColor = self.averageLineColor.CGColor;
        layer.strokeColor = self.averageLineColor.CGColor;
        layer.lineWidth = 1;
        [layer setLineDashPattern:@[@(3),@(5)]];
        layer.lineCap = @"round";
        layer.lineJoin = @"round";
        
        [self.view.layer addSublayer:layer];
        
        CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1;
        pathAnimation.fromValue = @(0);
        pathAnimation.toValue = @(1);
        
        [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
}

#pragma mark gestures

// we capture the touch move events by overriding touchesMoved method

-(void)touchedGraphAtPoint:(CGPoint)point userGenerated:(BOOL)userGenerated
{
    //Take the x value and get the corresponding y value;
    
    CGFloat value = [self valueAtPoint:point];
    
    [self.delegate touchedGraph:self val:value point:point userGenerated:userGenerated];
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self removeSelection];
        [self.delegate graphTouchesEnded:self];
    }
    else
    {
        [self handleGesture:point];
    }
}

-(void)handleTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    
    [self handleGesture:point];
}

-(void) handleGesture:(CGPoint)point
{
    if(point.x > self.graphWidth + self.marginLeft || point.x < self.marginLeft)
    {
        [self removeSelection];
        [self.delegate graphTouchesEnded:self];
    }
    else
    {
        [self touchedGraphAtPoint:point userGenerated:YES];
        
        FNKChartOverlayData* data = [self.chartOverlay touchAtPoint:point view:self.view];
        
        if (data != nil)
        {
            [self.delegate touchedBar:self data: data];
        }
    }
}

-(void) focusAtPoint:(CGPoint)point show:(BOOL)show
{
    if(show)
    {
        [self touchedGraphAtPoint:point userGenerated:NO];
    }
    else
    {
        [self removeSelection];
    }
}

@end

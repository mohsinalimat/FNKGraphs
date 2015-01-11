//
//  FNKLineGraph.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKLineGraph.h"
#import "FNKLineGraph+AverageLine.h"

@interface FNKLineGraph()

@property (nonatomic) CGFloat yAxisNum;

//Graph variables
@property (nonatomic) CGFloat xScaleFactor;
@property (nonatomic) CGFloat yScaleFactor;
@property (nonatomic) CGFloat xRange;
@property (nonatomic) CGFloat yRange;

@property (nonatomic, strong) CAShapeLayer* selectedLineLayer;
@property (nonatomic, strong) CAShapeLayer* selectedLineCircleLayer;
@property (nonatomic, strong) NSMutableArray* originalData;

@end

@implementation FNKLineGraph

-(FNKLineGraph*)initWithMarginLeft:(CGFloat)marginLeft marginRight:(CGFloat)marginRight marginTop:(CGFloat)marginTop marginBottom:(CGFloat)marginBottom
{
    if(self = [super initWithMarginLeft:marginLeft marginRight:marginRight marginTop:marginTop marginBottom:marginBottom])
    {
        self.selectedLineLayer  = [CAShapeLayer layer];
        self.selectedLineCircleLayer = [CAShapeLayer layer];
    }
    
    return self;
}

-(void)loadData:(NSMutableArray*)data
{
    self.originalData = [data copy];
    [self calcMaxMin:data];
    self.dataPointArray = [self normalizePoints:data];
}

-(double)scaleYValue:(double)value
{
    //yVal needs to be the inverse bc of iOS coordinates
    return self.graphHeight + self.yAxis.marginTop - ((value - self.yAxisNum) * self.yScaleFactor);
}

-(void)willAppear
{
    self.selectedLineLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.parentView.layer addSublayer:self.selectedLineLayer];
    
    self.selectedLineCircleLayer.strokeColor = [UIColor clearColor].CGColor;
    self.selectedLineCircleLayer.fillColor = [UIColor clearColor].CGColor;
    [self.parentView.layer addSublayer:self.selectedLineCircleLayer];
}

-(void)drawData
{
    [self addTicks];
    
    __weak __typeof(self) safeSelf = self;
    self.lineLayer = [self drawLine:self.dataPointArray
                              color:self.lineStrokeColor
                         completion:^{
                             double yValue = [safeSelf scaleYValue:safeSelf.averageLine];
                             [safeSelf drawAverageLine:yValue];
                         }];
}

-(void)addTicks
{
    self.yLabelView = [self.yAxis addTicksToView:self.parentView];
    self.xLabelView = [self.xAxis addTicksToView:self.parentView];
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
    
    [self.parentView.layer insertSublayer:layer below:self.yLabelView.layer];
    
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
    for (NSValue* val in self.dataPointArray)
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

-(void)showLineComparison:(NSMutableArray*)comparisonData color:(UIColor*)lineColor
{
    //Okay so now we need to run all of the data thru the normalizer again and get a new max and min for the graph
    NSMutableArray* allData = [NSMutableArray arrayWithArray:self.originalData];
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
                        data:comparisonData];
    }
    
    [self transitionLine:self.lineLayer
                    data:self.originalData];
}

-(void)transitionLine:(CAShapeLayer*)line data:(NSMutableArray*)data
{
    CGPathRef newPath = [self pathFromPoints:[self normalizePoints:data]].CGPath;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        //Need to do this, otherwise the next animation will start at the original value.
        [line setPath:newPath];
    }];
    
    CABasicAnimation *morph = [CABasicAnimation animationWithKeyPath:@"path"];
    morph.duration  = 2; // Step 1
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
    
    maxY = maxY + self.yPadding;
    
    //Okay so now we have the min's and max's
    self.xRange = maxX - minX;
    self.yRange = maxY - minY;
    
    self.xScaleFactor = self.graphWidth / self.xRange;
    self.yScaleFactor = self.graphHeight / self.yRange;
    
    self.xAxis.scaleFactor = self.xScaleFactor;
    self.yAxis.scaleFactor = self.yScaleFactor;
    self.yAxis.yAxisNum = self.yAxisNum;
}

-(NSMutableArray*)normalizePoints:(NSArray*)points
{
    NSMutableArray* scaledPoints = [NSMutableArray array];
    
    for (NSValue* val in points)
    {
        CGPoint point = [val CGPointValue];
        CGFloat xVal = (point.x * self.xScaleFactor) + self.yAxis.marginLeft;
        CGFloat yVal = [self scaleYValue:point.y];
        [scaledPoints addObject:[NSValue valueWithCGPoint:CGPointMake(xVal,yVal)]];
    }
    
    return scaledPoints;
}


@end

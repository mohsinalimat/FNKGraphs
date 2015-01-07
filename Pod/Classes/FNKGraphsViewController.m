//
//  FNKGraphsViewController.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKGraphsViewController.h"
#import "FNKLineGraph.h"
#import "FNKChartOverlayBars.h"
#import "FNKChartOverlayData.h"
#import "FNKLineGraph+AverageLine.h"

@interface FNKGraphsViewController ()

    @property (nonatomic) CGFloat marginLeft;
@property (nonatomic) CGFloat marginRight;
@property (nonatomic) CGFloat marginTop;
@property (nonatomic) CGFloat marginBottom;
@property (nonatomic) CGFloat graphWidth;
@property (nonatomic) CGFloat graphHeight;

//Graph variables
@property (nonatomic) CGFloat xScaleFactor;
@property (nonatomic) CGFloat yScaleFactor;
@property (nonatomic) CGFloat xRange;
@property (nonatomic) CGFloat yRange;

@property (nonatomic) CGFloat yAxisNum;

@property (nonatomic) BOOL drawBars;
@property (nonatomic, strong) CAShapeLayer* selectedLineLayer;
@property (nonatomic, strong) CAShapeLayer* selectedLineCircleLayer;

@property (nonatomic) BOOL hasDrawn;

@end

@implementation FNKGraphsViewController

-(FNKGraphsViewController*)initWithFrame:(CGRect)frame
{
    return [self initWithRect:frame
                   marginLeft:10
                  marginRight:10
                    marginTop:5
                 marginBottom:5
                   graphWidth:frame.size.width - 10 - 10
                  graphHeight:frame.size.height - 5 - 5
                     yPadding:0];
}

-(FNKGraphsViewController*)initWithRect:(CGRect)rect marginLeft:(CGFloat)marginLeft marginRight:(CGFloat)marginRight marginTop:(CGFloat) marginTop marginBottom:(CGFloat)marginBottom graphWidth:(CGFloat)graphWidth graphHeight:(CGFloat)graphHeight yPadding:(CGFloat)yPadding
{
    if( self = [super init])
    {
        self.yPadding = yPadding;
        self.marginLeft = marginLeft;
        self.marginRight = marginRight;
        self.marginTop = marginTop;
        self.marginBottom = marginBottom;
        self.graphWidth = graphWidth;
        self.graphHeight = graphHeight;
        
        self.yPadding = yPadding;
        self.drawBars = false;
        
        self.chart = [[FNKLineGraph alloc] initWithMarginLeft:marginLeft marginRight:marginRight marginTop:marginTop marginBottom:marginBottom];
        
        self.selectedLineLayer  = [CAShapeLayer layer];
        self.selectedLineCircleLayer = [CAShapeLayer layer];
        
        self.chart.xAxis.ticks = 5;
        self.chart.yAxis.ticks = 5;
        
    }
    return self;
}

-(void)viewDidLoad
{    
    [super viewDidLoad];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.hasDrawn)
    {
        CGFloat height = self.view.frame.size.height - self.marginTop - self.marginBottom;
        CGFloat width = self.view.frame.size.width - self.marginLeft - self.marginRight;
        
        self.graphHeight = height;
        self.graphWidth = width;
        
        [self.chart.xAxis setGraphHeight:height];
        [self.chart.yAxis setGraphHeight:height];
        
        [self.chart.xAxis setGraphWidth:width];
        [self.chart.yAxis setGraphWidth:width];
        
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

-(void) addChartOverlay:(FNKChartOverlayBars*)chartOverlay
{
    self.chartOverlay = chartOverlay;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.hasDrawn)
    {
        [self.chart drawAxii:self.view];
        
        __weak __typeof(self) safeSelf = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [safeSelf loadData];
        });
        self.hasDrawn = YES;
    }
}

-(void)loadData
{
    self.dataPointArray = [self normalizePoints:self.dataPointArray];
    self.chart.xAxis.scaleFactor = self.xScaleFactor;
    self.chart.yAxis.scaleFactor = self.yScaleFactor;
    self.chart.yAxis.yAxisNum = self.yAxisNum;
    self.chartOverlay.scale = self.xScaleFactor;
    [self.chart draw:self.view];
    [self drawPoints];
    
    if (self.chartOverlay != nil)
    {
        [self.chartOverlay drawInView:self.view];
        self.chart.yLabelView.userInteractionEnabled = false;
    }
}

-(CALayer*)drawPoints
{
    BOOL firstPoint = YES;
    
    UIBezierPath* bezPath = [[UIBezierPath alloc] init];
    
    if(self.fillGraph)
    {
        [bezPath moveToPoint:CGPointMake(0, self.graphHeight)];
        
        CGPoint lastPoint;
        
        for (NSValue* val in self.dataPointArray)
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
        for (NSValue* val in self.dataPointArray)
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
    
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.path = bezPath.CGPath;
    layer.fillColor = nil;
    layer.strokeColor = self.chart.lineStrokeColor.CGColor;
    layer.lineWidth = 2;
    layer.lineCap = @"round";
    layer.lineJoin = @"round";
    
    [self.view.layer insertSublayer:layer below:self.chart.yLabelView.layer];
    
    [CATransaction begin];
    __weak __typeof(self) safeSelf = self;
    [CATransaction setCompletionBlock:^{
        double yValue = [safeSelf scaleYValue:safeSelf.chart.averageLine];
        [safeSelf.chart drawAverageLine:yValue parentView:safeSelf.view];
    }];
    
    CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1;
    pathAnimation.fromValue = @(0);
    pathAnimation.toValue = @(1);
    
    [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    [CATransaction commit];
    return layer;
}

-(NSMutableArray*)normalizePoints:(NSArray*)points
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
    
    NSMutableArray* scaledPoints = [NSMutableArray array];
    
    for (NSValue* val in points)
    {
        CGPoint point = [val CGPointValue];
        CGFloat xVal = (point.x * self.xScaleFactor) + self.marginLeft;
        CGFloat yVal = [self scaleYValue:point.y];
        [scaledPoints addObject:[NSValue valueWithCGPoint:CGPointMake(xVal,yVal)]];
    }
    
    return scaledPoints;
}

-(double)scaleYValue:(double)value
{
    //yVal needs to be the inverse bc of iOS coordinates
    return self.graphHeight + self.marginTop - ((value - self.yAxisNum) * self.yScaleFactor);
}

// we capture the touch move events by overriding touchesMoved method

-(void)touchedGraphAtPoint:(CGPoint)point userGenerated:(BOOL)userGenerated
{
    //Take the x value and get the corresponding y value;
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
    
    [bezPath moveToPoint:CGPointMake(point.x, self.marginTop)];
    [bezPath addLineToPoint:CGPointMake(point.x, self.graphHeight + self.marginTop)];
    
    self.selectedLineLayer.strokeColor = self.chart.lineStrokeColor.CGColor;
    self.selectedLineLayer.path = bezPath.CGPath;
    
    CGFloat radius = 5;
    
    self.selectedLineCircleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - radius/2, yVal-radius/2, radius, radius)].CGPath;
    self.selectedLineCircleLayer.fillColor = self.chart.lineStrokeColor.CGColor;
    self.selectedLineCircleLayer.strokeColor = self.chart.lineStrokeColor.CGColor;
    
    CGFloat originalVal = ((self.marginTop + self.graphHeight - yVal) / self.yScaleFactor) + self.yAxisNum;
    
    [self.delegate touchedGraph:self val:originalVal point:point userGenerated:userGenerated];
}

-(void)removeSelectedLine
{
    self.selectedLineLayer.strokeColor = [UIColor clearColor].CGColor;
    self.selectedLineCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.selectedLineCircleLayer.strokeColor = [UIColor clearColor].CGColor;
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self removeSelectedLine];
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
        [self removeSelectedLine];
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
        [self removeSelectedLine];
    }
}

@end

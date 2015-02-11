//
//  FNKGraphsBarGraphViewController.m
//  Pods
//
//  Created by Phillip Connaughton on 2/10/15.
//
//

#import "FNKGraphsBarGraphViewController.h"
#import "FNKBarSectionData.h"
#import "FNKBar.h"

@interface FNKGraphsBarGraphViewController ()

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGPoint center;

/* xAxis - The X axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,strong) FNKXAxis* xAxis;

/* yAxis - The Y axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,strong) FNKYAxis* yAxis;

//Graph variables
@property (nonatomic) CGFloat yScaleFactor;
@property (nonatomic) CGFloat yRange;

@property (nonatomic) CGFloat barWidth;

@property (nonatomic, strong) NSMutableArray* barsArray;

@end

@implementation FNKGraphsBarGraphViewController

#pragma mark life cycles

-(void)initializers
{
    self.xAxis = [[FNKXAxis alloc] initWithMarginLeft:self.marginLeft marginRight:self.marginRight marginTop:self.marginTop marginBottom:self.marginBottom];
    self.yAxis = [[FNKYAxis alloc] initWithMarginLeft:self.marginLeft marginRight:self.marginRight marginTop:self.marginTop marginBottom:self.marginBottom];
    self.yAxis.ticks = 5;
    self.xAxis.ticks = 5;
    
    self.barPadding = 5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupLocalVars
{
}

-(void)removeSelection
{
}

#pragma mark Drawing

-(void)drawGraph
{
    [self drawGraph:nil];
}

-(void)drawGraph:(void (^) (void))completion
{
    [super drawGraph];
    
    self.xAxis.graphHeight = self.graphHeight;
    self.yAxis.graphHeight = self.graphHeight;
    
    self.xAxis.graphWidth = self.graphWidth;
    self.yAxis.graphWidth = self.graphWidth;
    
    self.graphData = [NSMutableArray array];
    
    //Convert all of the data to be sectionData
    for(id data in self.dataArray)
    {
        [self.graphData addObject:@(self.valueForObject(data))];
    }
    
    [self drawAxii:self.view];
    [self calcMaxMin:self.graphData];
    
    //There are a couple of steps here
    //First we need to figure out the width of the bars
    self.barWidth = (self.graphWidth / self.graphData.count) - self.barPadding;
    
    [self addTicks];
    
    self.barsArray = [NSMutableArray array];
    
    int index = 0;
    
    dispatch_group_t animationGroup = dispatch_group_create();
    
    for(NSNumber* barData in self.graphData)
    {
        CGFloat x = index * (self.barWidth + self.barPadding);
        
        FNKBar* barView = [[FNKBar alloc] initWithFrame:CGRectMake(x + self.marginLeft, self.marginTop + self.graphHeight, self.barWidth, 0)];
        barView.backgroundColor = self.barColor;
        barView.alpha = 1.0;
        [self.view addSubview:barView];
        
        [self.barsArray addObject:barView];
        
        double delay = 0.05*index;
        
        dispatch_group_enter(animationGroup);
        [UIView animateWithDuration:1
                              delay:delay
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             barView.originalFrame = CGRectMake(x + self.marginLeft, self.marginTop + self.graphHeight, self.barWidth, -[self scaleYValue:barData.floatValue]);
                             barView.frame = barView.originalFrame;
                         }
                         completion:^(BOOL finished) {
                             dispatch_group_leave(animationGroup);
                         }];
        index++;
    }
    
    __weak __typeof(self) safeSelf = self;
    self.xLabelView = [self.xAxis addTicksToView:self.view
                                          atBars:self.barsArray
                                      tickFormat:^NSString *(int index) {
                                          id objc = [safeSelf.dataArray objectAtIndex:index];
                                          CGFloat labelValue = safeSelf.labelValueForObject(objc);
                                          return safeSelf.xAxis.tickFormat(labelValue);
                                      }];
    
    dispatch_group_notify(animationGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if(completion)
        {
            completion();
        }
    });
}

-(void)drawAxii:(UIView*)view
{
    [self.yAxis drawAxis:view];
    
    [self.xAxis drawAxis:view];
}

-(void)addTicks
{
    self.yLabelView = [self.yAxis addTicksToView:self.view];
}

-(void)removeTicks
{
    [self.yLabelView removeFromSuperview];
    [self.xLabelView removeFromSuperview];
}

-(void)transitionBar:(NSMutableArray*)data duration:(CGFloat)duration
{
    int i = 0;
    for(FNKBar* bar in self.barsArray)
    {
        NSNumber* barData = [data objectAtIndex:i];
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             bar.frame = CGRectMake(bar.originalFrame.origin.x, bar.originalFrame.origin.y, bar.originalFrame.size.width, -[self scaleYValue:barData.floatValue]);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        i++;
    }
}

#pragma mark max min calculations

-(void)calcMaxMin:(NSArray*)buckets
{
    CGFloat maxY = DBL_MIN;
    CGFloat minY = DBL_MAX;
    
    for (NSNumber* data in buckets)
    {
        if(data.floatValue > maxY)
        {
            maxY = data.floatValue;
        }
        
        if(data.floatValue < minY)
        {
            minY = data.floatValue;
        }
    }
    
    //If the user has defined a yMin then we shoudl use that.
    //This allows us to have the value start at 0.
    if(self.yAxis.overridingMin.floatValue < minY)
    {
        minY = self.yAxis.overridingMin.floatValue;
    }
    
    if(self.yAxis.overridingMax.floatValue > maxY)
    {
        maxY = self.yAxis.overridingMax.floatValue;
    }
    
    //Okay so now we have the min's and max's
    self.yRange = maxY - minY;
    
    self.yScaleFactor = self.graphHeight / self.yRange;
    
    self.yAxis.scaleFactor = self.yScaleFactor;
    self.yAxis.axisMin = minY;
}

-(double)scaleYValue:(double)value
{
    return value * self.yScaleFactor;
}

-(void)resetBarColors
{
    for(FNKBar* bar in self.barsArray)
    {
        [bar setBackgroundColor:[UIColor colorWithRed:0.239 green:0.71 blue:0.996 alpha:1.0]];
    }
}

#pragma mark Handle touches

// we capture the touch move events by overriding touchesMoved method

-(void)touchedGraphAtPoint:(CGPoint)point userGenerated:(BOOL)userGenerated
{
    CGFloat value = [self valueAtPoint:point];
    
    [self.delegate touchedGraph:self val:value point:point userGenerated:userGenerated];
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    //ViewController should override
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
    }
}

-(void) focusAtPoint:(CGPoint)point show:(BOOL)show
{
    //ViewController should override
}

-(CGFloat)valueAtPoint:(CGPoint)point
{
    //This function handles selecting a piece of the pie
    //    CGFloat xValue = point.x - self.center.x;
    CGFloat yValue = point.y - self.center.y;
    
    return yValue;
}

@end

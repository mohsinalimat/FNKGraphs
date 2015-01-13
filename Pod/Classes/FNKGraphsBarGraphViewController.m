//
//  FNKGraphsBarGraphViewController.m
//  Pods
//
//  Created by Phillip Connaughton on 1/12/15.
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

@property (nonatomic, strong) NSMutableArray* buckets;

//Graph variables
@property (nonatomic) CGFloat yScaleFactor;
@property (nonatomic) CGFloat yRange;
@property (nonatomic) CGFloat yAxisNum;

@property (nonatomic) CGFloat barPadding;

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
    self.yMin = @(0);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupLocalVars
{
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
        
        self.originalData = [NSMutableArray array];
        self.buckets = [NSMutableArray array];
        
        //Convert all of the data to be sectionData
        for(id data in self.dataArray)
        {
            int bucket = self.bucketForObject(data);
            [self.originalData addObject:[FNKBarSectionData barSectionData:data bucket:bucket]];
        }
        
        //Initialize all the values to 0
        for(int i = 0; i < self.numberOfBuckets() ; i++)
        {
            [self.buckets addObject:@(0)];
        }
        
        //Increment the info
        for(FNKBarSectionData* data in self.originalData)
        {
            CGFloat val = self.valueForObject(data.data);
            NSNumber* num = (NSNumber*)[self.buckets objectAtIndex:data.bucket];
            [self.buckets replaceObjectAtIndex:data.bucket withObject:@(val + num.floatValue)];
        }
        
        [self drawAxii:self.view];
        [self calcMaxMin:self.buckets];
        [self drawGraph];
    }
}

-(void)removeSelection
{
}

#pragma mark Drawing

-(void)drawGraph
{
    //There are a couple of steps here
    //First we need to figure out the width of the bars
    CGFloat barWidth = ((self.graphWidth - self.marginLeft - self.marginRight) / self.buckets.count) - self.barPadding/2;
    
    self.barsArray = [NSMutableArray array];
    
    int index = 0;
    
    for(NSNumber* barData in self.buckets)
    {
        CGFloat x = index*barWidth + index*self.barPadding;
        FNKBar* barView = [[FNKBar alloc] initWithFrame:CGRectMake(x + self.marginLeft, self.marginTop + self.graphHeight, barWidth, 0)];
        barView.backgroundColor = self.barColor;
        barView.alpha = 0.1;
        [self.view addSubview:barView];
        
        [self.barsArray addObject:barView];
        
        double delay = 0.1*index;
        
        [UIView animateWithDuration:2
                              delay:delay
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             barView.originalFrame = CGRectMake(x + self.marginLeft, self.marginTop + self.graphHeight, barWidth, -barData.floatValue * self.yScaleFactor);
                             barView.frame = barView.originalFrame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        index++;
    }
}

-(void)drawAxii:(UIView*)view
{
    [self.yAxis drawAxis:view];
    
    [self.xAxis drawAxis:view];
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
    if(self.yMin)
    {
        self.yAxisNum = self.yMin.floatValue;
        minY = self.yAxisNum;
    }
    else
    {
        self.yAxisNum = minY;
    }
    
    //Okay so now we have the min's and max's
    self.yRange = maxY - minY;
    
    self.yScaleFactor = self.graphHeight / self.yRange;
    
    self.yAxis.scaleFactor = self.yScaleFactor;
    self.yAxis.yAxisNum = self.yAxisNum;
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
    CGFloat xValue = point.x - self.center.x;
    CGFloat yValue = point.y - self.center.y;
    
    return yValue;
}


@end

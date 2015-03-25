//
//  FNKGraphsBarGraphViewController.m
//  Pods
//
//  Created by Phillip Connaughton on 1/12/15.
//
//

#import "FNKGraphsHistogramGraphViewController.h"
#import "FNKBarSectionData.h"
#import "FNKBar.h"

@interface FNKGraphsHistogramGraphViewController ()

/* xAxis - The X axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,strong) FNKXAxis* xAxis;

/* yAxis - The Y axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,strong) FNKYAxis* yAxis;

@property (nonatomic, strong) NSMutableArray* buckets;

//Graph variables
@property (nonatomic) CGFloat yScaleFactor;
@property (nonatomic) CGFloat yRange;
@property (nonatomic) CGFloat yAxisNum;

@property (nonatomic) CGFloat barWidth;

@property (nonatomic, strong) NSMutableArray* barsArray;

@end

@implementation FNKGraphsHistogramGraphViewController

#pragma mark life cycles

-(void)initializers
{
    self.xAxis = [[FNKXAxis alloc] initWithMarginLeft:self.marginLeft marginBottom:self.marginBottom];
    self.yAxis = [[FNKYAxis alloc] initWithMarginLeft:self.marginLeft marginBottom:self.marginBottom];
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

-(void)removeSelection
{
}

#pragma mark Drawing

-(void)drawGraph:(void (^) (void))completion
{
    [super drawGraph:completion];
    
    self.xAxis.graphHeight = self.graphHeight;
    self.yAxis.graphHeight = self.graphHeight;
    
    self.xAxis.graphWidth = self.graphWidth;
    self.yAxis.graphWidth = self.graphWidth;
    
    self.graphData = [NSMutableArray array];
    self.buckets = [NSMutableArray array];
    
    //Convert all of the data to be sectionData
    for(id data in self.dataArray)
    {
        int bucket = self.bucketForObject(data);
        [self.graphData addObject:[FNKBarSectionData barSectionData:data bucket:bucket]];
    }
    
    //Initialize all the values to 0
    for(int i = 0; i < self.numberOfBuckets() ; i++)
    {
        [self.buckets addObject:@(0)];
    }
    
    //Increment the info
    for(FNKBarSectionData* data in self.graphData)
    {
        CGFloat val = self.valueForObject(data.data);
        NSNumber* num = (NSNumber*)[self.buckets objectAtIndex:data.bucket];
        [self.buckets replaceObjectAtIndex:data.bucket withObject:@(val + num.floatValue)];
    }
    
    [self drawAxii:self.view];
    
    //If we fail to calculate teh max and min, just bail out
    if([self calcMaxMin:self.buckets])
    {
        //There are a couple of steps here
        //First we need to figure out the width of the bars
        self.barWidth = (self.graphWidth / self.buckets.count) - self.barPadding;
        
        [self addTicks];
        
        self.barsArray = [NSMutableArray array];
        
        int index = 0;
        
        dispatch_group_t animationGroup = dispatch_group_create();
        
        for(NSNumber* barData in self.buckets)
        {
            CGFloat x = index * (self.barWidth + self.barPadding);
            
            FNKBar* barView = [[FNKBar alloc] initWithFrame:CGRectMake(x + self.marginLeft, self.graphHeight, self.barWidth, 0)];
            barView.backgroundColor = self.barColor;
            barView.alpha = 1.0;
            [barView setHeightConstraint:[NSLayoutConstraint constraintWithItem:barView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:0.0
                                                                       constant:0.0]];
            
            [barView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.view addSubview:barView];
            [self.view addConstraint:barView.heightConstraint];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:barView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                   constant:x + self.marginLeft]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:barView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:barView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:self.barWidth]];
            
            [self.barsArray addObject:barView];
            
            if(self.barAdded != NULL)
            {
                self.barAdded(barView);
            }
            
            double delay = 0.05*index;
            
            dispatch_group_enter(animationGroup);
            __weak __typeof(self) safeSelf = self;
            [UIView animateWithDuration:1
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 barView.heightConstraint.constant = barData.floatValue * safeSelf.yScaleFactor;
                                 [self.view layoutSubviews];
                             }
                             completion:^(BOOL finished) {
                                 dispatch_group_leave(animationGroup);
                             }];
            index++;
        }
        
        dispatch_group_notify(animationGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            if(completion)
            {
                completion();
            }
        });
    }
}

-(void)drawAxii:(UIView*)view
{
    [self.yAxis drawAxis:view];
    
    [self.xAxis drawAxis:view];
}

-(void)addTicks
{
    self.yLabelView = [self.yAxis addTicksToView:self.view];
    
    __weak __typeof(self) safeSelf = self;
    self.xLabelView = [self.xAxis addTicksToView:self.view tickFormat:^NSString *(CGFloat value) {
        //Need to figure out which bar we are closest to.
        int bar = (int)(value/(safeSelf.barPadding + safeSelf.barWidth));
        
        //maxDate - minDate = days between
        NSInteger daysBetween = [safeSelf daysBetweenMinDate:safeSelf.minDate maxDate:safeSelf.maxDate calendar:[NSCalendar currentCalendar]];
        
        //daysBetween/barNumbers = days per bar
        CGFloat daysPerBar = daysBetween / safeSelf.numberOfBuckets();
        
        //date = minDate + daysPerBar*Bar;
        NSDate* date = [safeSelf dateByAddingDays:safeSelf.minDate numDays:(daysPerBar*bar)];
        return safeSelf.xAxis.tickFormat([date timeIntervalSince1970]);
    }];
}

-(void)removeTicks
{
    [self.yLabelView removeFromSuperview];
    [self.xLabelView removeFromSuperview];
}

-(void)transitionBar:(NSMutableArray*)data duration:(CGFloat)duration completion:(void (^) (void))completion
{
    int i = 0;
    
    dispatch_group_t animationGroup = dispatch_group_create();
    for(FNKBar* bar in self.barsArray)
    {
        NSNumber* barData = [data objectAtIndex:i];
        
        __weak __typeof(self) safeSelf = self;
        dispatch_group_enter(animationGroup);
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             bar.frame = CGRectMake(bar.originalFrame.origin.x, bar.originalFrame.origin.y, bar.originalFrame.size.width, -barData.floatValue * safeSelf.yScaleFactor);
                         }
                         completion:^(BOOL finished) {
                             dispatch_group_leave(animationGroup);
                         }];
        i++;
    }
    
    dispatch_group_notify(animationGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if(completion)
        {
            completion();
        }
    });
}

#pragma mark max min calculations

-(BOOL)calcMaxMin:(NSArray*)buckets
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
    
    if(maxY == DBL_MIN || minY == DBL_MAX)
    {
        NSLog(@"FNKGraphsHistogramGraphViewController: The max or min on one of your axii is infinite!");
        return NO;
    }
    
    //Okay so now we have the min's and max's
    self.yRange = maxY - minY;
    
    self.yScaleFactor = self.graphHeight / self.yRange;
    
    self.yAxis.scaleFactor = self.yScaleFactor;
    self.yAxis.axisMin = self.yAxisNum;
    
    return YES;
}

-(void)filterBars:(NSMutableArray*)filteredData duration:(CGFloat)duration completion:(void (^)(void))completion
{
    if(filteredData)
    {
        NSMutableArray* filteredBuckets = [NSMutableArray array];
        NSMutableArray* filteredGraphData = [NSMutableArray array];
        
        //Convert all of the data to be sectionData
        for(id data in filteredData)
        {
            int bucket = self.bucketForObject(data);
            [filteredGraphData addObject:[FNKBarSectionData barSectionData:data bucket:bucket]];
        }
        
        //Initialize all the values to 0
        for(int i = 0; i < self.numberOfBuckets() ; i++)
        {
            [filteredBuckets addObject:@(0)];
        }
        
        //Increment the info
        for(FNKBarSectionData* data in filteredGraphData)
        {
            CGFloat val = self.valueForObject(data.data);
            NSNumber* num = (NSNumber*)[filteredBuckets objectAtIndex:data.bucket];
            [filteredBuckets replaceObjectAtIndex:data.bucket withObject:@(val + num.floatValue)];
        }
        
        [self calcMaxMin:filteredBuckets];
        [self transitionBar:filteredBuckets
                   duration:duration
                 completion:^{
                     if(completion)
                     {
                         completion();
                     }
                 }];
        
        [self removeTicks];
        [self addTicks];
    }
    else
    {
        [self calcMaxMin:self.buckets];
        [self transitionBar:self.buckets
                   duration:duration
                 completion:^{
                     if(completion)
                     {
                         completion();
                     }
                 }];
        
        [self removeTicks];
        [self addTicks];
    }
}

-(void)resetBarColors
{
    for(FNKBar* bar in self.barsArray)
    {
        [bar setBackgroundColor:[UIColor colorWithRed:0.239 green:0.71 blue:0.996 alpha:1.0]];
    }
}

#pragma mark Handle touches

- (NSInteger) daysBetweenMinDate:(NSDate*)minDate maxDate:(NSDate*)maxDate calendar:(NSCalendar*)calendar
{
    /*
     * NOTE: Compliments of one of the solutions in this SO post:
     *  http://stackoverflow.com/questions/4739483/number-of-days-between-two-nsdates
     *
     * It wasn't the accepted solution because the accepted solution sucked. :-P This one was
     * upvoted a lot (including by me. :)).
     */
    NSDate *fromDate;
    NSDate *toDate;
    
    [calendar rangeOfUnit: NSCalendarUnitDay startDate: &fromDate interval: NULL forDate: minDate];
    [calendar rangeOfUnit: NSCalendarUnitDay startDate: &toDate interval: NULL forDate: maxDate];
    NSDateComponents *difference = [calendar components: NSCalendarUnitDay fromDate: fromDate toDate: toDate options: 0];
    
    return [difference day];
}

- (NSDate*) dateByAddingDays:(NSDate*)startDate numDays:(NSInteger) numDays
{
    NSDateComponents* dateComp = [[NSDateComponents alloc] init];
    [dateComp setDay: numDays];
    return [[NSCalendar currentCalendar] dateByAddingComponents: dateComp toDate:startDate options: 0];
}

@end

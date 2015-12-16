//
//  FNKGraphsHistogramGraphViewController.swift
//  Pods
//
//  Created by Phillip Connaughton on 11/21/15.
//
//

import Foundation

class FNKGraphsHistogramGraphViewController
{
    /*
    @property (nonatomic, strong) UIView* yLabelView;
    @property (nonatomic, strong) UIView* xLabelView;
    
    /* xAxis - The X axis of the graph. This cannot be assigned but it's properties can be*/
    @property (nonatomic,readonly) FNKXAxis* xAxis;
    
    /* yAxis - The Y axis of the graph. This cannot be assigned but it's properties can be*/
    @property (nonatomic,readonly) FNKYAxis* yAxis;
    
    /* The number of buckets your graph contains*/
    @property (nonatomic, copy) int (^numberOfBuckets)();
    
    /* The time bucket that this object will fit into*/
    @property (nonatomic, copy) int (^bucketForObject)(id object);
    
    /* The value for the specific object in the graph data (the length of the bar)*/
    @property (nonatomic, copy) CGFloat (^valueForObject)(id object);
    
    /* The color for the specfic bar given the object */
    @property (nonatomic, copy) UIColor* (^colorForBar)(int index);
    
    /* The value for the specific object in the graph data (the length of the bar)*/
    @property (nonatomic, copy) NSDate* (^dateForObject)(id object);
    
    /* Specify a ymin to make your graph more readable*/
    @property (nonatomic) NSNumber* yMin;
    
    /* Specify a min date to add padding to the left side of the graph */
    @property (nonatomic) NSDate* minDate;
    
    /* Specify a min date to add padding to the right side of the graph */
    @property (nonatomic) NSDate* maxDate;
    
    /* The corner radius for each bars (defaults 0)*/
    @property (nonatomic) CGFloat barCornerRadius;
    
    /* The padding between each of the bars (defaults 5)*/
    @property (nonatomic) CGFloat barPadding;
    
    /* The time bucket that this object will fit into*/
    @property (nonatomic, copy) void (^barAdded)(FNKBar* bar, int barNum);
    
    /* Pass in new data and the bars will animate to their new positins */
    -(void)filterBars:(NSMutableArray*)filteredData duration:(CGFloat)duration completion:(void (^)(void))completion;
    
    /* When using the bar graph in a UITableViewCell you might have to reset the bar colors when the cell is clicked*/
    -(void)resetBarColors;
    */
    
    /*
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
    [self.buckets addObject:[[FNKHistogramBucketData alloc] init]];
    
    }
    
    //Increment the info
    for(FNKBarSectionData* data in self.graphData)
    {
    CGFloat val = self.valueForObject(data.data);
    FNKHistogramBucketData* bucketData = (FNKHistogramBucketData*)[self.buckets objectAtIndex:data.bucket];
    bucketData.data = @(val + bucketData.data.floatValue);
    [bucketData addDate:self.dateForObject(data.data)];
    
    }
    
    [self drawAxii:self.view];
    
    //If we fail to calculate teh max and min, just bail out
    if([self calcMaxMin:self.buckets])
    {
    //There are a couple of steps here
    //First we need to figure out the width of the bars
    self.barWidth = (self.graphWidth / self.buckets.count) - self.barPadding;
    
    self.barsArray = [NSMutableArray array];
    
    //First create the bars
    for(int index = 0 ; index < (int)self.buckets.count ; index++)
    {
    CGFloat x = index * (self.barWidth + self.barPadding);
    
    FNKBar* barView = [[FNKBar alloc] initWithFrame:CGRectMake(x + self.marginLeft, self.graphHeight, self.barWidth, 0)];
    [barView.layer setCornerRadius:self.barCornerRadius];
    barView.backgroundColor = self.colorForBar(index);
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
    constant:-self.marginBottom]];
    
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
    self.barAdded(barView, index);
    }
    }
    
    [self addTicks];
    
    int index = 0;
    
    dispatch_group_t animationGroup = dispatch_group_create();
    
    for(FNKBar* barView in self.barsArray)
    {
    FNKHistogramBucketData* bucketData = [self.buckets objectAtIndex:index];
    double delay = 0.05*index;
    
    dispatch_group_enter(animationGroup);
    __weak __typeof(self) safeSelf = self;
    [UIView animateWithDuration:1
    delay:delay
    options:UIViewAnimationOptionCurveEaseIn
    animations:^{
    barView.heightConstraint.constant = bucketData.data.floatValue * safeSelf.yScaleFactor;
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
    if(self.xAxis.ticks > self.buckets.count)
    {
    self.xLabelView = [self.xAxis addTicksToView:self.view
    atBars:self.barsArray
    tickFormat:^NSString *(int index) {
    FNKHistogramBucketData* bucketData = [safeSelf.buckets objectAtIndex:index];
    return safeSelf.xAxis.tickFormat([bucketData.minDate timeIntervalSince1970]);
    }];
    }
    else
    {
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
    FNKHistogramBucketData* bucketData = [data objectAtIndex:i];
    
    __weak __typeof(self) safeSelf = self;
    dispatch_group_enter(animationGroup);
    [UIView animateWithDuration:duration
    delay:0
    options:UIViewAnimationOptionCurveEaseIn
    animations:^{
    bar.heightConstraint.constant = bucketData.data.floatValue * safeSelf.yScaleFactor;
    [self.view layoutSubviews];
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
    
    for (FNKHistogramBucketData* bucketData in buckets)
    {
    if(bucketData.data.floatValue > maxY)
    {
    maxY = bucketData.data.floatValue;
    }
    
    if(bucketData.data.floatValue < minY)
    {
    minY = bucketData.data.floatValue;
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
    [filteredBuckets addObject:[[FNKHistogramBucketData alloc] init]];
    }
    
    //Increment the info
    for(FNKBarSectionData* data in filteredGraphData)
    {
    CGFloat val = self.valueForObject(data.data);
    FNKHistogramBucketData* bucketData = (FNKHistogramBucketData*)[filteredBuckets objectAtIndex:data.bucket];
    bucketData.data = @(val + bucketData.data.floatValue);
    [bucketData addDate:self.dateForObject(data.data)];
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
    for (int index = 0; index < self.barsArray.count; index++)
    {
    FNKBar* bar = [self.barsArray objectAtIndex:index];
    [bar setBackgroundColor:self.colorForBar(index)];
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
    */
}
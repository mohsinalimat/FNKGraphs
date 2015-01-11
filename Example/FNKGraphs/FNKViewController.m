//
//  FNKViewController.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 01/07/2015.
//  Copyright (c) 2014 Phillip Connaughton. All rights reserved.
//

#import "FNKViewController.h"
#import <FNKGraphs/FNKGraphsViewController.h>
#import <FNKGraphs/FNKChartOverlayBars.h>
#import "FNKPointValues.h"

@interface FNKViewController ()

@end

@implementation FNKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addPaceChart];
    
//    [self addElevationChart];
    
    [self.view layoutIfNeeded];
}

-(void)addPaceChart
{
    self.paceChartsVC = [[FNKGraphsViewController alloc] initWithFrame:CGRectMake(0, 70, 320, 160)];
    [self.paceChartsVC setDataArray:[FNKPointValues addPointsPaceByDistanceTwo]];
    self.paceChartsVC.yPadding = 50;
    
    //    [self.paceChartsVC addChartOverlay:[[FNKChartOverlayBars alloc] init]];
    
    //Set custom colors for chart -- Not necessary as all charts will have defaults
    self.paceChartsVC.chart.yAxis.strokeColor = [UIColor clearColor];
    self.paceChartsVC.chart.yAxis.fillColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.paceChartsVC.chart.yAxis.tickFillColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.paceChartsVC.chart.yAxis.tickStrokeColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.paceChartsVC.chart.yAxis.tickType = FNKTickTypeBehind;
    
    self.paceChartsVC.chart.xAxis.strokeColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.paceChartsVC.chart.xAxis.fillColor =[UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.paceChartsVC.chart.xAxis.tickFillColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.paceChartsVC.chart.xAxis.tickStrokeColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    
    UIColor* avColor = [UIColor blackColor];
    [self.paceChartsVC.chart setAverageLineColor:[avColor colorWithAlphaComponent:0.2]];
    [self.paceChartsVC.chart setAverageLineColor:[UIColor blackColor]];
    
    
    self.paceChartsVC.chart.lineStrokeColor = [UIColor colorWithRed:0.48828125 green:0.83203125 blue:0.98828125 alpha:1.0];
    
    __weak __typeof(self) safeSelf = self;
    
    [self.paceChartsVC.chart.yAxis setTickFormat:^NSString *(CGFloat value) {
        return [safeSelf durationFormat:value];
    }];
    [self.paceChartsVC.chart.xAxis setTickFormat:^NSString *(CGFloat value) {
        return [safeSelf milesFromMeters:value];
    }];
    
    self.paceChartsVC.delegate = self;
    
    self.paceChartsVC.chartOverlay.dataSet = [self createMusicDataSet];
    
    [self addChildViewController:self.paceChartsVC];
    
    [self.view addSubview:self.paceChartsVC.view];
    
    UIView* paceView = self.paceChartsVC.view;
    
    paceView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(paceView);
    NSString *constraintString = [NSString stringWithFormat:@"|[paceView]|"];
    NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewDictionary];
    [self.view addConstraints:widthConstraints];
    
    constraintString = [NSString stringWithFormat:@"V:|-100-[paceView(160)]"];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewDictionary];
    [self.view addConstraints:heightConstraints];
}

-(void) addElevationChart
{
    self.elevationChartsVC = [[FNKGraphsViewController alloc] initWithFrame:CGRectMake(0, 320, 320, 160)];
//    self.elevationChartsVC.dataPointArray = [FNKPointValues addPointsElevationByDistanceOne];
    self.elevationChartsVC.yPadding = 0;
    
    self.elevationChartsVC.chart.yAxis.strokeColor = [UIColor clearColor];
    self.elevationChartsVC.chart.yAxis.fillColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.elevationChartsVC.chart.yAxis.tickFillColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.elevationChartsVC.chart.yAxis.tickStrokeColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.elevationChartsVC.chart.yAxis.tickType = FNKTickTypeBehind;
    
    self.elevationChartsVC.chart.xAxis.strokeColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.elevationChartsVC.chart.xAxis.fillColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.elevationChartsVC.chart.xAxis.tickFillColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    self.elevationChartsVC.chart.xAxis.tickStrokeColor = [UIColor colorWithRed:0.91015625 green:0.91015625 blue:0.91015625 alpha:0.7];
    
    self.elevationChartsVC.chart.lineStrokeColor = [UIColor colorWithRed:0.6640625 green:0.875 blue:0.39453125 alpha:1];
    
    __weak __typeof(self) safeSelf = self;
    
    [self.elevationChartsVC.chart.yAxis setTickFormat:^NSString *(CGFloat val) {
        return [safeSelf elevationFormat:val];
    }];
    
    [self.elevationChartsVC.chart.xAxis setTickFormat:^NSString *(CGFloat val) {
        return [safeSelf milesFromMeters:val];
    }];
    
    self.elevationChartsVC.delegate = self;
    
    [self addChildViewController:self.elevationChartsVC];
    
    [self.view addSubview:self.elevationChartsVC.view];
    
    UIView* paceView = self.paceChartsVC.view;
    UIView* elevationView = self.elevationChartsVC.view;
    
    elevationView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(paceView,elevationView);
    NSString *constraintString = [NSString stringWithFormat:@"|[elevationView]|"];
    NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewDictionary];
    [self.view addConstraints:widthConstraints];
    
    constraintString = [NSString stringWithFormat:@"V:[paceView]-60-[elevationView(160)]"];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewDictionary];
    [self.view addConstraints:heightConstraints];
}


-(NSString*) milesFromMeters:(CGFloat)meters
{
    return [NSString stringWithFormat:@"%.1f", meters / 1609.0 ];
}

-(NSString*) durationFormat:(double)secs
{
    CGFloat hours = roundf( (secs / (60.0 * 60.0)) );
    int divisor_for_minutes = fmod(secs,(60.0 * 60.0));
    CGFloat minutes = roundf(divisor_for_minutes / 60);
    
    CGFloat divisor_for_seconds = divisor_for_minutes % 60;
    CGFloat seconds = round(divisor_for_seconds);
    
    if (hours == 0) {
        return [NSString stringWithFormat:@"%0.f:%@", minutes, [self padTime:seconds]];
    }
    
    return [NSString stringWithFormat:@"%@:%@:%@", [self padTime:hours], [self padTime:minutes], [self padTime:seconds]];
}

-(NSString*) elevationFormat:(CGFloat)meters
{
    return [NSString stringWithFormat:@"%.f", (meters / 0.3048)];
}

-(NSString*) padTime:(CGFloat)time
{
    if(time < 10)
    {
        return [NSString stringWithFormat:@"0%0.f",time];
    }
    else
    {
        return [NSString stringWithFormat:@"%0.f",time];
    }
}

-(void)touchedGraph:(FNKGraphsViewController*)chart val:(CGFloat)val point:(CGPoint)point userGenerated:(BOOL)userGenerated
{
    if([chart isEqual:self.paceChartsVC])
    {
        self.paceLabel.text = [self durationFormat:val];
        
        if(userGenerated)
        {
            [self.elevationChartsVC focusAtPoint:point show:YES];
        }
    }
    else if([chart isEqual:self.elevationChartsVC])
    {
        self.elevationLabel.text = [self durationFormat:val];
        
        if(userGenerated)
        {
            [self.paceChartsVC focusAtPoint:point show:YES];
        }
    }
    //    else if(chart.isEqual(elevationChartsVC))
    //    {
    ////        elevationLabel.text = self.elevationFormat(Float(val)]];
    //    }
}
-(void)touchedBar:(FNKGraphsViewController*)chart data:(FNKChartOverlayData*)data
{
    self.songLabel.text = [NSString stringWithFormat:@"%@ - %@", data.data[@"title"], data.data[@"artist"]];
    //    [self showSong:true];
}

-(void)graphTouchesEnded:(FNKGraphsViewController*)chart
{
    if([chart isEqual:self.paceChartsVC])
    {
        [self.elevationChartsVC focusAtPoint:CGPointMake(0, 0) show:NO];
    }
    if([chart isEqual:self.elevationChartsVC])
    {
        [self.paceChartsVC focusAtPoint:CGPointMake(0, 0) show:NO];
    }
}

-(NSMutableArray*)createMusicDataSet
{
    NSMutableArray* points = [NSMutableArray array];
    
    [points addObject:[[FNKChartOverlayData alloc] initWithX:0 data: @{@"title":@"Wicked Twisted Road",
                                                                       @"artist" : @"Reckless Kelly"}]];
    [points addObject:[[FNKChartOverlayData alloc] initWithX:800 data: @{@"title" : @"Texas and Tennese", @"artist" : @"Lucero"}]];
    [points addObject:[[FNKChartOverlayData alloc] initWithX:2000 data: @{@"title" : @"7 & 7", @"artist" : @"Turnpike Troubadors"}]];
    [points addObject:[[FNKChartOverlayData alloc] initWithX:3000 data: @{@"title" : @"Down on Washington", @"artist" : @"Turnpike Troubadors"}]];
    [points addObject:[[FNKChartOverlayData alloc] initWithX:3400 data: @{@"title" : @"1968", @"artist" : @"Turnpike Troubadors"}]];
    [points addObject:[[FNKChartOverlayData alloc] initWithX:4000 data: @{@"title" : @"Pompeii", @"artist" : @"Bastille"}]];
    [points addObject:[[FNKChartOverlayData alloc] initWithX:5000 data: @{@"title" : @"Happy", @"artist" : @"Pharrell Williams"}]];
    [points addObject:[[FNKChartOverlayData alloc] initWithX:5300 data: @{@"title" : @"Shreveport", @"artist" : @"Turnpike Troubadors"}]];
    [points addObject:[[FNKChartOverlayData alloc] initWithX:6200 data: @{@"title" : @"Billy Jean", @"artist" : @"Michael Jackson"}]];
    [points addObject:[[FNKChartOverlayData alloc] initWithX:7700 data: @{@"title" : @"Diamonds & Gasoline", @"artist" : @"Turnpike Troubadors"}]];
    
    return points;
}

- (IBAction)loadGraphComparison:(id)sender
{
    [self.paceChartsVC.chart showLineComparison:[FNKPointValues addPointsPaceByDistanceOne] color:[UIColor redColor]];
}

@end
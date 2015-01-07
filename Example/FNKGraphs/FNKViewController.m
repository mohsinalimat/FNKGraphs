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

@interface FNKViewController ()

@end

@implementation FNKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addPaceChart];
    
    [self addElevationChart];
    
    [self.view layoutIfNeeded];
}

-(void)addPaceChart
{
    self.paceChartsVC = [[FNKGraphsViewController alloc] initWithFrame:CGRectMake(0, 70, 320, 160)];
    [self.paceChartsVC setDataPointArray:[self addPointsPaceByDistance]];
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
    
    constraintString = [NSString stringWithFormat:@"V:|-70-[paceView(160)]"];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewDictionary];
    [self.view addConstraints:heightConstraints];
}

-(void) addElevationChart
{
    self.elevationChartsVC = [[FNKGraphsViewController alloc] initWithFrame:CGRectMake(0, 320, 320, 160)];
    self.elevationChartsVC.dataPointArray = [self addPointsElevationByDistance];
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

-(NSMutableArray*) addPointsPaceByDistance
{
    NSMutableArray* points = [NSMutableArray array];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.328132,649.092604)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.439374,620.929929)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.482162,597.366982)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.932410,570.612544)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(142.647764,528.623336)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(178.420817,425.682068)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(205.253506,415.130391)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(231.332928,408.683997)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(269.416931,413.613021)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(292.264987,421.073416)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(317.020807,420.133158)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(352.254452,443.147187)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(372.945204,511.656461)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(395.850211,548.700056)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(428.927901,550.948349)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(451.667712,554.080446)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(472.246238,552.730628)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(506.920782,541.232301)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(529.823227,518.453394)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(552.028509,514.923722)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(583.733093,456.869326)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(607.776146,500.654375)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(632.820329,520.636958)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(664.778325,509.400148)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(687.912988,505.258940)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(720.731647,522.326913)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(745.550943,522.926506)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(772.070089,551.447257)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(805.986570,546.574494)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(828.663178,489.214273)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(851.284809,471.058173)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(885.219121,493.174104)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(909.721876,498.639444)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(935.627585,495.979339)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(970.941543,479.728574)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(997.351379,468.310495)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1018.866069,469.496698)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1049.680148,459.548928)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1071.965904,467.768119)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1094.689012,475.300433)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1131.069385,486.618733)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1153.881151,488.167009)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1175.585998,488.951570)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1200.088723,437.529361)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1223.341469,437.323349)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1249.977279,437.542922)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1285.687119,439.271717)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1311.577597,438.829393)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1340.556708,443.626129)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1376.362103,448.949952)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1399.031833,445.067076)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1432.326082,442.207975)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1454.103017,442.247876)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1477.440642,443.537591)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1513.552065,443.664664)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1537.207915,442.822090)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1560.178856,442.428932)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1595.032430,441.718569)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1618.993214,440.846185)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1642.931749,440.867370)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1676.263796,440.802753)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1700.553484,441.495761)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1723.603478,441.646294)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1762.736343,441.957340)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1787.881577,441.632419)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1808.804446,441.142541)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1843.539172,441.456465)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1866.150591,440.144130)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1887.440673,438.070586)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1920.250001,437.454509)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1944.099400,442.304220)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1965.165899,442.105524)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2005.760685,450.010699)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2029.188189,453.776748)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2065.711184,451.586561)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2088.106909,447.148821)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2110.310791,447.994645)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2144.558278,448.770624)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2167.558600,449.878325)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2191.089352,449.250652)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2224.179941,444.715276)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2246.959249,443.448391)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2267.943068,441.381526)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2299.016788,439.542290)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2323.170156,439.102192)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2346.015290,439.802607)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2380.242174,441.707271)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2404.497734,441.396969)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2427.451209,443.122503)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2460.172826,443.535575)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2485.851233,443.001112)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2511.158199,441.441255)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2549.441503,435.725062)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2571.235275,438.023392)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2594.799133,439.634246)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2628.909271,440.387171)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2652.268250,437.552555)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2677.293197,437.953304)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2710.282021,439.229090)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2732.310253,439.588623)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2773.271786,439.413164)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2797.179204,440.128926)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2822.391146,439.971723)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2858.054428,440.129949)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2882.412998,439.406116)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2903.617628,439.752008)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2938.175051,438.935070)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2962.831681,439.900512)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2985.821346,441.028205)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3021.936469,439.784090)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3045.804364,442.021769)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3067.790537,442.706662)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3102.212054,439.365546)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3127.349435,435.358406)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3153.212166,435.765715)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3187.764020,430.242613)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3211.852064,430.914875)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3236.367116,432.058974)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3272.031707,431.620098)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3295.854648,430.333719)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3318.736155,430.624517)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3355.031685,435.145019)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3379.596841,438.777669)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3402.759590,441.089706)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3437.344729,442.073322)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3464.807558,439.224184)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3496.851520,438.403678)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3518.816805,440.175687)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3541.138174,440.784050)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3575.235156,441.694039)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3597.308243,441.754694)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3620.531004,439.403960)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3656.342846,438.500811)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3678.817346,439.030002)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3704.641892,437.362330)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3737.532127,437.076590)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3760.513575,436.395782)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3784.233918,435.917873)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3818.182158,436.331754)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3845.519020,437.259619)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3870.284617,437.046465)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3905.259471,434.892500)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3930.181533,433.718846)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3951.534164,434.019848)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3986.331199,434.468074)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4009.389244,434.266788)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4033.336718,433.913455)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4070.565060,432.448130)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4093.005287,431.572520)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4116.477958,429.990523)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4149.055073,428.772374)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4173.128941,428.626916)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4206.653228,428.496813)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4230.165030,426.032659)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4254.272226,424.857915)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4290.089215,427.012022)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4314.891010,426.570071)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4339.024218,426.785380)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4374.495170,426.960310)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4396.162153,425.638520)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4420.960966,425.922504)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4456.490689,426.152734)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4478.561319,429.388082)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4504.003877,425.882843)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4540.792942,420.945458)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4563.127655,416.455671)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4588.336840,416.568971)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4622.006573,416.093387)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4646.526777,418.756911)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4670.611910,420.767149)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4708.166459,417.944252)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4730.508466,417.501896)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4753.169545,417.166157)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4787.386187,414.884817)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4811.221824,414.278832)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4844.001553,413.878917)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4867.301507,412.335152)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4890.601431,411.759931)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4926.234690,411.885740)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4949.383689,412.691849)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4970.065991,412.415488)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5005.603809,409.598464)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5028.756520,409.782675)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5051.433143,409.501453)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5086.244257,408.159589)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5107.521351,408.622941)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5130.916376,408.908986)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5165.172465,406.484844)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5187.644717,406.726596)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5211.243261,405.677381)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5243.374359,405.268574)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5267.027470,402.832820)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5291.305005,400.714906)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5327.682569,398.915804)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5352.355079,399.062614)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5376.384903,399.354744)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5412.215042,398.374908)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5435.484862,395.661522)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5460.858314,395.637312)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5498.970605,394.662206)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5524.179423,395.139245)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5560.720722,394.541799)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5587.367226,393.384688)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5611.225095,392.684307)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5647.801552,391.899353)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5673.332933,392.242138)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5697.147738,393.147582)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5732.567406,391.687003)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5757.524897,391.195724)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5783.107062,390.565373)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5820.539417,389.515620)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5846.836179,389.598010)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5871.765078,388.511719)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5916.054663,388.030332)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5940.497693,388.272405)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5963.987452,387.875205)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5996.843478,388.950957)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6022.995358,388.160695)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6050.073993,389.370121)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6084.709066,389.548833)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6109.493818,391.088150)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6133.457981,392.256460)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6167.709209,388.981416)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6191.654976,387.536220)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6219.033644,386.061872)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6256.872549,385.289968)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6278.714570,384.865298)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6310.998326,384.700632)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6335.141092,385.039967)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6361.920248,385.028386)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6399.503571,383.543751)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6424.312735,383.754219)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6448.425153,383.667659)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6486.541771,383.966565)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6511.761537,382.940977)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6535.755330,386.771971)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6571.959567,388.115205)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6596.349344,390.732762)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6621.507716,389.406993)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6653.366501,389.900124)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6680.647138,397.962203)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6701.945476,404.681519)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6734.842506,404.745961)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6758.779916,404.832252)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6782.709946,404.370723)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6820.600434,402.697987)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6845.087414,403.703023)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6867.316896,404.592526)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6903.770976,403.964304)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6926.032462,403.218041)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6962.668828,402.515324)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6989.857186,403.525885)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7014.690468,403.470660)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7053.541438,404.563746)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7079.921826,405.057063)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7105.932120,403.076142)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7145.689551,405.040868)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7170.349024,404.604188)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7191.879583,405.582267)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7229.471082,403.469149)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7253.216088,406.626316)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7275.855838,404.642294)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7330.393203,359.891919)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7353.530680,347.034555)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7395.387132,337.392785)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7421.459854,338.639281)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7443.470421,314.755885)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7476.249515,324.057774)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7498.739040,301.235820)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7524.507905,292.638775)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7561.278892,310.522189)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7587.839009,324.551577)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7619.312545,319.277960)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7661.522146,316.890940)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7684.900410,344.374803)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7725.143229,438.705046)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7758.573658,368.431545)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7785.266992,368.802985)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7825.930608,348.451390)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7895.310450,373.827987)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7924.273355,381.699838)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7963.904465,281.534624)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7988.133746,260.864250)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8011.443576,326.366205)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8080.622759,312.469985)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8102.968193,309.354133)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8126.988265,300.156521)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8168.134679,433.849210)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8192.783575,462.880365)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8218.568141,481.063257)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8249.879053,521.594813)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8271.641812,535.833009)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8293.923030,540.046100)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8329.755630,438.060678)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8354.062829,393.129118)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8377.109253,350.610571)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8415.966958,289.484548)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8441.897111,268.725668)]];
    
    return points;
}

-(NSMutableArray*) addPointsElevationByDistance
{
    NSMutableArray* points = [NSMutableArray array];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(32.328132,5.191463)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(55.439374,5.096822)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(94.482162,4.666783)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(117.932410,4.422490)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(142.647764,4.184259)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(178.420817,3.944357)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(205.253506,3.849256)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(231.332928,3.812946)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(269.416931,3.382082)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(292.264987,3.115525)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(317.020807,2.979430)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(352.254452,2.819335)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(372.945204,2.956084)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(395.850211,3.447964)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(428.927901,3.821796)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(451.667712,3.847947)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(472.246238,3.797812)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(506.920782,3.467428)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(529.823227,3.279213)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(552.028509,2.922146)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(583.733093,2.427320)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(607.776146,1.527787)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(632.820329,0.334638)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(664.778325,-0.244283)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(687.912988,-0.255894)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(720.731647,-0.568765)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(745.550943,-0.895401)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(772.070089,-1.879468)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(805.986570,-3.854260)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(828.663178,-5.034638)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(851.284809,-5.997782)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(885.219121,-6.722005)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(909.721876,-7.161200)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(935.627585,-6.985322)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(970.941543,-5.475962)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(997.351379,-3.996580)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1018.866069,-2.166902)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1049.680148,0.513493)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1071.965904,1.185427)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1094.689012,1.252019)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1131.069385,1.346690)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1153.881151,1.304718)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1175.585998,1.096026)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1200.088723,2.441433)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1223.341469,2.414601)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1249.977279,2.200938)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1285.687119,2.108372)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1311.577597,1.782273)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1340.556708,1.416775)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1376.362103,1.356086)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1399.031833,1.665818)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1432.326082,2.392153)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1454.103017,3.082335)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1477.440642,3.787350)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1513.552065,4.591751)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1537.207915,4.901993)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1560.178856,5.119728)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1595.032430,5.200028)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1618.993214,5.071152)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1642.931749,4.892508)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1676.263796,4.536520)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1700.553484,4.226520)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1723.603478,3.925467)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1762.736343,3.184858)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1787.881577,2.660555)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1808.804446,2.181096)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1843.539172,1.707641)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1866.150591,1.373534)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1887.440673,1.766121)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1920.250001,2.153081)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1944.099400,2.341557)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(1965.165899,2.428976)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2005.760685,2.313822)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2029.188189,2.102569)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2065.711184,1.839044)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2088.106909,1.518340)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2110.310791,1.496545)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2144.558278,0.927489)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2167.558600,0.395504)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2191.089352,-0.014916)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2224.179941,-0.502209)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2246.959249,-0.638346)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2267.943068,-0.503197)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2299.016788,-0.026582)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2323.170156,0.075228)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2346.015290,-0.109057)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2380.242174,-0.494033)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2404.497734,-0.945042)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2427.451209,-1.576414)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2460.172826,-2.397160)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2485.851233,-2.510738)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2511.158199,-2.511637)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2549.441503,-2.233985)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2571.235275,-1.823981)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2594.799133,-1.597655)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2628.909271,-2.004207)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2652.268250,-2.048116)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2677.293197,-2.110819)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2710.282021,-1.984798)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2732.310253,-1.501580)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2773.271786,-1.205182)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2797.179204,-1.868742)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2822.391146,-2.374776)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2858.054428,-3.645745)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2882.412998,-4.540126)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2903.617628,-5.004981)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2938.175051,-5.376846)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2962.831681,-5.445180)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(2985.821346,-4.811042)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3021.936469,-3.439579)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3045.804364,-2.038437)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3067.790537,-0.533343)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3102.212054,1.072295)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3127.349435,1.429198)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3153.212166,1.299265)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3187.764020,0.255489)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3211.852064,-0.465214)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3236.367116,-1.014067)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3272.031707,-1.158795)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3295.854648,-0.902051)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3318.736155,-0.558495)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3355.031685,-0.394227)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3379.596841,-0.320269)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3402.759590,-0.169293)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3437.344729,-0.257694)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3464.807558,-0.288528)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3496.851520,0.269658)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3518.816805,0.351736)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3541.138174,0.508724)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3575.235156,1.178591)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3597.308243,1.302539)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3620.531004,1.222378)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3656.342846,0.694468)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3678.817346,0.210143)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3704.641892,-0.397071)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3737.532127,-0.563747)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3760.513575,-0.207202)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3784.233918,0.190925)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3818.182158,0.920556)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3845.519020,1.303491)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3870.284617,1.142885)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3905.259471,0.843352)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3930.181533,0.564646)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3951.534164,0.263058)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(3986.331199,0.111044)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4009.389244,0.429331)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4033.336718,0.496595)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4070.565060,0.744952)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4093.005287,1.049124)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4116.477958,1.579089)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4149.055073,2.016764)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4173.128941,2.426293)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4206.653228,3.205937)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4230.165030,3.342426)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4254.272226,3.408480)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4290.089215,3.661823)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4314.891010,3.522654)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4339.024218,3.440026)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4374.495170,3.373132)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4396.162153,3.194496)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4420.960966,2.893931)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4456.490689,2.489939)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4478.561319,1.944573)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4504.003877,1.440587)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4540.792942,0.904143)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4563.127655,0.589260)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4588.336840,0.355543)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4622.006573,0.134970)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4646.526777,0.124275)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4670.611910,0.116743)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4708.166459,-0.091093)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4730.508466,0.074295)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4753.169545,0.165424)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4787.386187,-0.319082)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4811.221824,-0.363643)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4844.001553,-1.141034)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4867.301507,-2.355475)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4890.601431,-3.064898)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4926.234690,-2.488293)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4949.383689,-2.926296)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(4970.065991,-2.536159)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5005.603809,-1.290001)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5028.756520,-1.485508)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5051.433143,-2.308825)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5086.244257,-3.004676)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5107.521351,-3.158129)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5130.916376,-2.776951)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5165.172465,-1.979846)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5187.644717,-1.005791)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5211.243261,0.058859)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5243.374359,0.911193)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5267.027470,1.067964)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5291.305005,1.256485)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5327.682569,1.153769)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5352.355079,0.666065)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5376.384903,0.210151)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5412.215042,-0.517435)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5435.484862,-0.633993)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5460.858314,-0.485022)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5498.970605,-0.158457)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5524.179423,0.020945)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5560.720722,0.016315)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5587.367226,-0.286883)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5611.225095,-0.544992)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5647.801552,-1.325507)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5673.332933,-2.089304)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5697.147738,-2.476217)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5732.567406,-2.929092)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5757.524897,-3.036772)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5783.107062,-2.527422)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5820.539417,-1.316097)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5846.836179,-0.568480)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5871.765078,0.085357)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5916.054663,0.785105)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5940.497693,0.869095)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5963.987452,0.680141)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(5996.843478,0.600160)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6022.995358,0.631080)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6050.073993,0.530084)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6084.709066,0.747838)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6109.493818,0.809447)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6133.457981,0.883205)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6167.709209,0.579139)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6191.654976,0.528272)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6219.033644,0.451445)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6256.872549,0.492106)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6278.714570,0.842132)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6310.998326,1.497430)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6335.141092,1.907256)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6361.920248,2.217439)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6399.503571,2.240616)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6424.312735,2.137972)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6448.425153,1.877058)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6486.541771,1.516900)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6511.761537,1.144955)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6535.755330,0.997347)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6571.959567,1.151477)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6596.349344,1.663332)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6621.507716,2.105357)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6653.366501,2.569388)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6680.647138,2.781171)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6701.945476,2.767852)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6734.842506,2.487773)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6758.779916,2.537469)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6782.709946,3.043448)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6820.600434,3.531918)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6845.087414,3.427362)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6867.316896,3.189804)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6903.770976,2.545445)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6926.032462,2.444271)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6962.668828,2.772959)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(6989.857186,3.144278)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7014.690468,3.225002)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7053.541438,4.064341)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7079.921826,4.130581)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7105.932120,4.185346)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7145.689551,4.030325)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7170.349024,3.508239)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7191.879583,2.902412)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7229.471082,2.569773)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7253.216088,2.378686)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7275.855838,2.495949)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7330.393203,5.022320)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7353.530680,4.967141)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7395.387132,4.893828)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7421.459854,4.794502)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7443.470421,4.731572)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7476.249515,5.022038)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7498.739040,5.400784)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7524.507905,5.822564)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7561.278892,6.320153)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7587.839009,6.550619)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7619.312545,6.435854)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7661.522146,5.872552)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7684.900410,5.517408)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7725.143229,5.109083)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7758.573658,4.856181)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7785.266992,4.760847)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7825.930608,4.755484)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7895.310450,4.715761)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7924.273355,4.791581)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7963.904465,4.852471)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(7988.133746,4.847622)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8011.443576,4.826659)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8080.622759,4.636806)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8102.968193,4.426593)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8126.988265,4.510713)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8168.134679,4.669951)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8192.783575,4.877546)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8218.568141,5.131971)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8249.879053,5.334954)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8271.641812,5.341621)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8293.923030,5.303213)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8329.755630,5.110955)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8354.062829,5.089682)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8377.109253,5.121334)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8415.966958,5.214669)]];
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(8441.897111,5.287441)]];
    
    
    return points;
}


@end
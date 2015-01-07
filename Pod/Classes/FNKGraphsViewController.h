//
//  FNKGraphsViewController.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNKChartOverlayData.h"
#import "FNKChartOverlayBars.h"
#import "FNKLineGraph.h"

@protocol FNKChartsViewDelegate;

@interface FNKGraphsViewController : UIViewController

@property (nonatomic, weak) id<FNKChartsViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* dataPointArray;
@property (nonatomic) CGFloat yPadding;
@property (nonatomic,strong) FNKLineGraph* chart;
@property (nonatomic, strong) FNKChartOverlayBars* chartOverlay;
@property (nonatomic) BOOL fillGraph;

-(FNKGraphsViewController*)initWithFrame:(CGRect)frame;

-(void) addChartOverlay:(FNKChartOverlayBars*)chartOverlay;

-(void) focusAtPoint:(CGPoint)point show:(BOOL)show;

@end

@protocol FNKChartsViewDelegate
-(void)touchedGraph:(FNKGraphsViewController*)chart val:(CGFloat)val point:(CGPoint)point userGenerated:(BOOL)userGenerated;
-(void)graphTouchesEnded:(FNKGraphsViewController*)chart;
-(void)touchedBar:(FNKGraphsViewController*)chart data:(FNKChartOverlayData*)data;
@end
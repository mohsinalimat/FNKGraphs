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


@protocol FNKChartsViewDelegate;

@interface FNKGraphsViewController : UIViewController

/*Margin left determines the width of the the y-axis label*/
@property (readonly, nonatomic) CGFloat marginLeft;
@property (readonly, nonatomic) CGFloat marginBottom;
@property (readonly, nonatomic) CGFloat graphWidth;
@property (readonly, nonatomic) CGFloat graphHeight;
@property (nonatomic) BOOL hasDrawn;

@property (nonatomic, strong) NSMutableArray* graphData;
@property (nonatomic, strong) NSMutableArray* dataArray;

@property (nonatomic, weak) id<FNKChartsViewDelegate> delegate;
@property (nonatomic, strong) FNKChartOverlayBars* chartOverlay;

-(FNKGraphsViewController*)initWithFrame:(CGRect)frame;

-(FNKGraphsViewController*)initWithRect:(CGRect)rect marginLeft:(CGFloat)marginLeft marginBottom:(CGFloat)marginBottom graphWidth:(CGFloat)graphWidth graphHeight:(CGFloat)graphHeight;

-(void) addChartOverlay:(FNKChartOverlayBars*)chartOverlay;

-(void) focusAtPoint:(CGPoint)point show:(BOOL)show;

-(void) drawGraph:(void (^) (void))completion;

@end

@protocol FNKChartsViewDelegate
@optional
-(void)touchedGraph:(FNKGraphsViewController*)chart val:(CGFloat)value point:(CGPoint)point userGenerated:(BOOL)userGenerated;
-(void)graphTouchesEnded:(FNKGraphsViewController*)chart;
-(void)touchedBar:(FNKGraphsViewController*)chart data:(FNKChartOverlayData*)data;

//Returns -1 as the index if no slices are selected
-(void)pieSliceSelected:(FNKGraphsViewController*)chart sliceIndex:(int)sliceIndex;
@end
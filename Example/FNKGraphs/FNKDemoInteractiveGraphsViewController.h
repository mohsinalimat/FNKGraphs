//
//  FNKDemoInteractiveGraphsViewController.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 1/13/15.
//  Copyright (c) 2015 Phillip Connaughton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FNKGraphs/FNKGraphsHistogramGraphViewController.h>
#import <FNKGraphs/FNKGraphsPieGraphViewController.h>
#import <FNKGraphs/FNKGraphsLineGraphViewController.h>

@interface FNKDemoInteractiveGraphsViewController : UIViewController<FNKChartsViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *pieChartContainer;
@property (strong, nonatomic) IBOutlet UIView *lineGraphContainer;
@property (strong, nonatomic) IBOutlet UIView *barGraphContainer;

@property (nonatomic, strong) FNKGraphsPieGraphViewController* pieGraphVC;
@property (nonatomic, strong) FNKGraphsLineGraphViewController* lineGraphVC;
@property (nonatomic, strong) FNKGraphsHistogramGraphViewController* barGraphVC;
@end

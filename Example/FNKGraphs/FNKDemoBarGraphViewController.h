//
//  FNKDemoBarGraphViewController.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 1/12/15.
//  Copyright (c) 2015 Phillip Connaughton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FNKGraphs/FNKGraphsHistogramGraphViewController.h>

@interface FNKDemoBarGraphViewController : UIViewController<FNKChartsViewDelegate>

@property (nonatomic, strong) IBOutlet UIView* barGraphContainer;
@property (nonatomic, strong) FNKGraphsHistogramGraphViewController* barGraphVC;

@end

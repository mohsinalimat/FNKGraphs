//
//  FNKPieGraphViewController.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 1/11/15.
//  Copyright (c) 2015 Phillip Connaughton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FNKGraphs/FNKGraphsViewController.h>

@interface FNKPieGraphViewController : UIViewController<FNKChartsViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *pieContainerView;
@property (nonatomic, strong) FNKGraphsViewController* pieChartsVC;
@property (strong, nonatomic) IBOutlet UILabel *degreesLabel;

@end

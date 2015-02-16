//
//  FNKViewController.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 01/07/2015.
//  Copyright (c) 2014 Phillip Connaughton. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FNKGraphs/FNKGraphsLineGraphViewController.h>

@interface FNKDemoLineGraphViewController : UIViewController<FNKChartsViewDelegate>


@property (nonatomic, strong) FNKGraphsLineGraphViewController* paceChartsVC;
@property (nonatomic, strong) FNKGraphsLineGraphViewController* elevationChartsVC;
@property (strong, nonatomic) IBOutlet UILabel *paceLabel;
@property (strong, nonatomic) IBOutlet UILabel *elevationLabel;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;


@end

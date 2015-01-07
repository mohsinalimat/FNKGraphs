//
//  FNKViewController.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 01/07/2015.
//  Copyright (c) 2014 Phillip Connaughton. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FNKGraphs/FNKGraphsViewController.h>

@interface FNKViewController : UIViewController


@property (nonatomic, strong) FNKGraphsViewController* paceChartsVC;
@property (nonatomic, strong) FNKGraphsViewController* elevationChartsVC;
@property (strong, nonatomic) IBOutlet UILabel *paceLabel;
@property (strong, nonatomic) IBOutlet UILabel *elevationLabel;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;


@end

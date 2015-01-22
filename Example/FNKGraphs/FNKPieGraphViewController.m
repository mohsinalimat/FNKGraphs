//
//  FNKPieGraphViewController.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 1/11/15.
//  Copyright (c) 2015 Phillip Connaughton. All rights reserved.
//

#import "FNKPieGraphViewController.h"
#import <FNKGraphs/FNKGraphsPieGraphViewController.h>
#import <FNKGraphs/FNKPieSectionData.h>
@interface FNKPieGraphViewController ()

@end

@implementation FNKPieGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addPieGraph];
}

-(void)addPieGraph
{
    self.pieChartsVC = [[FNKGraphsPieGraphViewController alloc] initWithFrame:CGRectMake(0, 70, 320, 160)];
    
    NSMutableArray* dataArray = [NSMutableArray array];
    [dataArray addObject:[FNKPieSectionData pieSectionWithName:@"1-2 miles" color:[UIColor greenColor] percentage:.1]];
    [dataArray addObject:[FNKPieSectionData pieSectionWithName:@"2-4 miles" color:[UIColor purpleColor] percentage:.2]];
    [dataArray addObject:[FNKPieSectionData pieSectionWithName:@"4-7 miles" color:[UIColor redColor] percentage:.3]];
    [dataArray addObject:[FNKPieSectionData pieSectionWithName:@"7-10 miles" color:[UIColor yellowColor] percentage:.4]];
    [self.pieChartsVC setDataArray:dataArray];
    
    self.pieChartsVC.delegate = self;
    
    [self addChildViewController:self.pieChartsVC];
    
    [self.pieContainerView addSubview:self.pieChartsVC.view];
    
    UIView* pieView = self.pieChartsVC.view;
    
    pieView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(pieView);
    NSString *constraintString = [NSString stringWithFormat:@"|-10-[pieView]-10-|"];
    NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewDictionary];
    [self.pieContainerView addConstraints:widthConstraints];
    
    constraintString = [NSString stringWithFormat:@"V:|-10-[pieView]-10-|"];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewDictionary];
    [self.pieContainerView addConstraints:heightConstraints];
    
    [self.pieContainerView layoutSubviews];
}

#pragma mark Delegate methods

-(void)touchedGraph:(FNKGraphsViewController*)chart val:(CGFloat)val point:(CGPoint)point userGenerated:(BOOL)userGenerated
{
    [self.degreesLabel setText:[NSString stringWithFormat:@"%.2f",val]];
}

-(void)graphTouchesEnded:(FNKGraphsViewController*)chart
{
    
}

-(void)touchedBar:(FNKGraphsViewController*)chart data:(FNKChartOverlayData*)data
{
    
}

@end

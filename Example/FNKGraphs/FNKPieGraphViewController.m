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

#define fnkName @"name"
#define fnkDist @"distance"

@interface FNKPieGraphViewController ()

@end

@implementation FNKPieGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addPieGraph];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChartsVC drawGraph:^{}];
}

-(void)addPieGraph
{
    self.pieChartsVC = [[FNKGraphsPieGraphViewController alloc] initWithFrame:CGRectMake(0, 70, 320, 160)];
    
    NSArray* dataArray = @[@{fnkName : @"1-2 miles", fnkDist : @(10)},
                           @{fnkName : @"2-4 miles", fnkDist : @(20)},
                           @{fnkName : @"4-7 miles", fnkDist : @(30)},
                           @{fnkName : @"7-10 miles", fnkDist : @(40)},];
    
    [self.pieChartsVC setDataArray:[NSMutableArray arrayWithArray:dataArray]];
    
    [self.pieChartsVC setNumberOfSlices:^int{
        return (int)dataArray.count;
    }];
    
    [self.pieChartsVC setSliceForObject:^NSInteger(id object) {
        return [dataArray indexOfObject:object];
    }];
    
    [self.pieChartsVC setValueForObject:^CGFloat(id object) {
        NSDictionary* obj = (NSDictionary*)object;
        NSNumber* num = [obj objectForKey:fnkDist];
        return num.floatValue;
    }];
    
    [self.pieChartsVC setNameForSlice:^NSString *(int num) {
        NSDictionary* dict = [dataArray objectAtIndex:num];
        return [dict objectForKey:fnkName];
    }];
    
    [self.pieChartsVC setColorForSlice:^UIColor *(int slice) {
        if(slice == 0)
        {
            return [UIColor purpleColor];
        }
        else if(slice == 1)
        {
            return [UIColor yellowColor];
        }
        else if(slice == 2)
        {
            return [UIColor orangeColor];
        }
        else if(slice == 3)
        {
            return [UIColor redColor];
        }
        return nil;
    }];
    
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

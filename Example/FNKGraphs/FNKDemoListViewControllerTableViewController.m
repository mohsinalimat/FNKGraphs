//
//  FNKDemoListViewControllerTableViewController.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 1/11/15.
//  Copyright (c) 2015 Phillip Connaughton. All rights reserved.
//

#import "FNKDemoListViewControllerTableViewController.h"
#import "FNKDemoCellTableViewCell.h"

#define kFNKDemoLineGraph 0
#define kFNKDemoPieGraph 1
#define kFNKDemoBarGraph 2
#define kFNKDemoInteractiveGraph 3

@interface FNKDemoListViewControllerTableViewController ()

@end

@implementation FNKDemoListViewControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FNKDemoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demoCell" forIndexPath:indexPath];
    
    if(indexPath.row == kFNKDemoLineGraph)
    {
        [cell.demoTitle setText:@"Line Graph"];
    }
    else if(indexPath.row == kFNKDemoPieGraph)
    {
        [cell.demoTitle setText:@"Pie Graph"];
    }
    else if(indexPath.row == kFNKDemoBarGraph)
    {
        [cell.demoTitle setText:@"Bar Graph"];
    }
    else if(indexPath.row == kFNKDemoInteractiveGraph)
    {
        [cell.demoTitle setText:@"Interactive Graphs"];
    }
    
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == kFNKDemoLineGraph)
    {
        [self performSegueWithIdentifier:@"lineGraphPush" sender:self];
    }
    else if(indexPath.row == kFNKDemoPieGraph)
    {
        [self performSegueWithIdentifier:@"pieGraphPush" sender:self];
    }
    else if(indexPath.row == kFNKDemoBarGraph)
    {
        [self performSegueWithIdentifier:@"barGraphPush" sender:self];
    }
    
}
@end

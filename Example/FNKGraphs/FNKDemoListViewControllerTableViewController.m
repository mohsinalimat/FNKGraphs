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
    return 2;
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
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end

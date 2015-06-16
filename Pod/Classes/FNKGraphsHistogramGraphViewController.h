//
//  FNKGraphsBarGraphViewController.h
//  Pods
//
//  Created by Phillip Connaughton on 1/12/15.
//
//

#import <UIKit/UIKit.h>
#import "FNKGraphsViewController.h"
#import "FNKXAxis.h"
#import "FNKYAxis.h"
#import "FNKBar.h"

@interface FNKGraphsHistogramGraphViewController : FNKGraphsViewController

@property (nonatomic, strong) UIView* yLabelView;
@property (nonatomic, strong) UIView* xLabelView;

/* xAxis - The X axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,readonly) FNKXAxis* xAxis;

/* yAxis - The Y axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,readonly) FNKYAxis* yAxis;

/* The number of buckets your graph contains*/
@property (nonatomic, copy) int (^numberOfBuckets)();

/* The time bucket that this object will fit into*/
@property (nonatomic, copy) int (^bucketForObject)(id object);

/* The value for the specific object in the graph data (the length of the bar)*/
@property (nonatomic, copy) CGFloat (^valueForObject)(id object);

/* The color for the specfic bar given the object */
@property (nonatomic, copy) UIColor* (^colorForBar)(int index);

/* The value for the specific object in the graph data (the length of the bar)*/
@property (nonatomic, copy) NSDate* (^dateForObject)(id object);

/* Specify a ymin to make your graph more readable*/
@property (nonatomic) NSNumber* yMin;

/* Specify a min date to add padding to the left side of the graph */
@property (nonatomic) NSDate* minDate;

/* Specify a min date to add padding to the right side of the graph */
@property (nonatomic) NSDate* maxDate;

/* The padding between each of the bars (defaults 5)*/
@property (nonatomic) CGFloat barPadding;

/* The time bucket that this object will fit into*/
@property (nonatomic, copy) void (^barAdded)(FNKBar* bar, int barNum);

/* Pass in new data and the bars will animate to their new positins */
-(void)filterBars:(NSMutableArray*)filteredData duration:(CGFloat)duration completion:(void (^)(void))completion;

/* When using the bar graph in a UITableViewCell you might have to reset the bar colors when the cell is clicked*/
-(void)resetBarColors;

@end

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

@interface FNKGraphsBarGraphViewController : FNKGraphsViewController

@property (nonatomic, strong) UIColor* barColor;

@property (nonatomic, strong) UIView* yLabelView;
@property (nonatomic, strong) UIView* xLabelView;

/* xAxis - The X axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,readonly) FNKXAxis* xAxis;

/* yAxis - The Y axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,readonly) FNKYAxis* yAxis;

@property (nonatomic, copy) int (^numberOfBuckets)();

@property (nonatomic, copy) int (^bucketForObject)(id object);
@property (nonatomic, copy) CGFloat (^valueForObject)(id object);

@property (nonatomic) NSNumber* yMin;
@property (nonatomic) NSDate* minDate;
@property (nonatomic) NSDate* maxDate;

-(void)filterBars:(NSMutableArray*)filteredData duration:(CGFloat)duration;

@end

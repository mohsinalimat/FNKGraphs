//
//  FNKGraphsBarGraphViewController.h
//  Pods
//
//  Created by Phillip Connaughton on 2/10/15.
//
//

#import "FNKGraphsViewController.h"
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

@property (nonatomic, copy) CGFloat (^labelValueForObject)(id object);
@property (nonatomic, copy) CGFloat (^valueForObject)(id object);

@property (nonatomic) CGFloat barPadding;

-(void)resetBarColors;

-(void)drawGraph:(void (^) (void))completion;

-(double)scaleYValue:(double)value;

@end

//
//  FNKGraphsLineGraphViewController.h
//  Pods
//
//  Created by Phillip Connaughton on 1/11/15.
//
//

#import "FNKGraphsViewController.h"
#import "FNKXAxis.h"
#import "FNKYAxis.h"

@interface FNKGraphsLineGraphViewController : FNKGraphsViewController

@property (nonatomic, strong) UIView* yLabelView;
@property (nonatomic, strong) UIView* xLabelView;

// This is the color that the line graphs line will be
@property (nonatomic, strong) UIColor* lineStrokeColor;

@property (nonatomic, strong) CAShapeLayer* selectedLineLayer;
@property (nonatomic, strong) CAShapeLayer* selectedLineCircleLayer;

/* averageLineColor - Is the color that the average will show up as*/
@property (nonatomic, strong) UIColor* averageLineColor;

/* averageLine - This is the value where the average line will be. It is always horizontal */
@property (nonatomic) double averageLine;

/* xAxis - The X axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,readonly) FNKXAxis* xAxis;

/* yAxis - The Y axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,readonly) FNKYAxis* yAxis;

@property (nonatomic) CGFloat yPadding;

@property (nonatomic, copy) CGPoint (^pointForObject)(id object);
@property (nonatomic, copy) CGFloat (^valueForObject)(id object);

#pragma mark customGraph features
@property (nonatomic) BOOL circleAtLinePoints;
@property (nonatomic, strong) UIColor* circleAtLinePointColor;
@property (nonatomic, strong) UIColor* circleAtLinePointFillColor;

-(void)showLineComparison:(NSMutableArray*)comparisonData color:(UIColor*)lineColor duration:(CGFloat)duration;

-(void)filterLine:(NSMutableArray*)filteredData duration:(CGFloat)duration;

-(CGPoint)normalizedPointForObject:(id)object;



@end

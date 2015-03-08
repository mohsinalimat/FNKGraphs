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

//This is the color that the line graph will be filled in with
@property (nonatomic, strong) UIColor* graphFillColor;

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

@property (nonatomic) BOOL fillGraph;

@property (nonatomic, copy) CGPoint (^pointForObject)(id object);
@property (nonatomic, copy) CGFloat (^valueForObject)(id object);

#pragma mark customGraph features
@property (nonatomic) BOOL circleAtLinePoints;
@property (nonatomic, strong) UIColor* circleAtLinePointColor;
@property (nonatomic, strong) UIColor* circleAtLinePointFillColor;

/* Displays a comparison line*/
-(void)showLineComparison:(NSMutableArray*)comparisonData color:(UIColor*)lineColor duration:(CGFloat)duration completion:(void (^) (void))completion;

/* Filters the line graph down to the new set of data*/
-(void)filterLine:(NSMutableArray*)filteredData duration:(CGFloat)duration completion:(void (^)(void))completion;

/* Returns the point that an object would exist at in the graph*/
-(CGPoint)normalizedPointForPoint:(CGPoint)point;

/* Returns the point that an object would exist at in the graph*/
-(CGPoint)normalizedPointForObject:(id)object;

/* Draws a linear trend line that starts at the left and extends to the right side*/
-(void)drawTrendLine:(UIColor*)color completion:(void (^) (void))completion;

/* Draws a linear trend line that starts a specific point in the graph and runs all the way to the right side*/
-(void)drawTrendLine:(UIColor*)color startPoint:(CGPoint)startPoint completion:(void (^) (void))completion;

@end

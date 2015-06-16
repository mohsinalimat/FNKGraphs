//
//  FNKPointUtils.h
//  Pods
//
//  Created by Phillip Connaughton on 4/10/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FNKYAxis.h"
#import "FNKXAxis.h"
#import "FNKLineGraphRange.h"

@interface FNKPointUtils : NSObject

+(FNKLineGraphRange*)calcMaxMinLineGraph:(NSArray*)points
                          overridingXMin:(NSNumber*)overridingXMin
                          overridingXMax:(NSNumber*)overridingXMax
                          overridingYMin:(NSNumber*)overridingYMin
                          overridingYMax:(NSNumber*)overridingYMax
                      yPaddingPercentage:(NSNumber*)yPaddingPercentage
                              graphWidth:(CGFloat)graphWidth
                             graphHeight:(CGFloat)graphHeight;

@end

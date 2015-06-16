//
//  FNKPointUtils.m
//  Pods
//
//  Created by Phillip Connaughton on 4/10/15.
//
//

#import "FNKPointUtils.h"


@implementation FNKPointUtils

+(FNKLineGraphRange*)calcMaxMinLineGraph:(NSArray*)points
                          overridingXMin:(NSNumber*)overridingXMin
                          overridingXMax:(NSNumber*)overridingXMax
                          overridingYMin:(NSNumber*)overridingYMin
                          overridingYMax:(NSNumber*)overridingYMax
                      yPaddingPercentage:(NSNumber*)yPaddingPercentage
                              graphWidth:(CGFloat)graphWidth
                             graphHeight:(CGFloat)graphHeight
{
    FNKLineGraphRange* range = [[FNKLineGraphRange alloc] init];
    
    CGFloat maxX= DBL_MIN;
    CGFloat minX = DBL_MAX;
    CGFloat maxY = DBL_MIN;
    CGFloat minY = DBL_MAX;
    
    for (NSValue* val in points)
    {
        CGPoint point = [val CGPointValue];
        if(point.x > maxX)
        {
            maxX = point.x;
        }
        
        if(point.x < minX)
        {
            minX = point.x;
        }
        
        if(point.y > maxY)
        {
            maxY = point.y;
        }
        
        if(point.y < minY)
        {
            minY = point.y;
        }
    }
    
    if(overridingYMin && overridingYMin.floatValue < minY)
    {
        minY = overridingYMin.floatValue;
    }
    
    if(overridingYMax && overridingYMax.floatValue > maxY)
    {
        maxY = overridingYMax.floatValue;
    }
    
    if(overridingXMin && overridingXMin.floatValue < minX)
    {
        minX = overridingXMin.floatValue;
    }
    
    if(overridingXMax && overridingXMax.floatValue > maxX)
    {
        maxX = overridingXMax.floatValue;
    }
    
    if(maxX == DBL_MIN || minX == DBL_MAX || maxY == DBL_MIN || minY == DBL_MAX)
    {
        NSLog(@"FNKGraphsLineGraphViewController: The max or min on one of your axii is infinite!");
        range.hasValidValues = NO;
        return range;
    }
    
    CGFloat yPadding = (maxY - minY) * yPaddingPercentage.floatValue;
    
    minY = minY - yPadding;
    maxY = maxY + yPadding;
    
    //Okay so now we have the min's and max's
    range.xRange = maxX - minX;
    range.yRange = maxY - minY;
    
    if(range.yRange == 0)
    {
        //Just make a range of 10%
        double percentRange = maxY * 0.1;
        maxY = maxY + percentRange;
        minY = minY - percentRange;
        range.yRange = maxY - minY;
    }
    
    if(range.xRange == 0)
    {
        //Just make a range of 10%
        double percentRange = maxX * 0.1;
        maxX = maxX + percentRange;
        minX = minX - percentRange;
        range.xRange = maxX - minX;
    }
    
    range.xScaleFactor = graphWidth / range.xRange;
    range.yScaleFactor = graphHeight / range.yRange;
    
    range.minY = minY;
    range.minX = minX;
    range.hasValidValues = YES;
    
    return range;
}

@end

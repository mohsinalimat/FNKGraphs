//
//  FNKChartOverlayBars.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKChartOverlayBars.h"
#import "FNKChartOverlayData.h"
#import "FNKOverlayBar.h"

@implementation FNKChartOverlayBars

-(void)drawInView:(UIView*)view
{
    [self updateChartData];
    
    self.barsArray = [NSMutableArray array];
    int bars = (int)self.dataSet.count;
    
    for (int index = 0 ; index < bars ; index++)
    {
        FNKChartOverlayData* data = (FNKChartOverlayData*)[self.dataSet objectAtIndex:index];
        FNKOverlayBar* barView = [[FNKOverlayBar alloc] initWithData:data frame:CGRectMake(data.x + self.marginLeft, self.graphHeight + self.marginTop, data.width, 0)];
        barView.backgroundColor = [self randomColor];
        barView.alpha = 0.1;
        [view insertSubview:barView atIndex:6];
        
        [self.barsArray addObject:barView];
        
        double delay = 0.1*index;
        
        [UIView animateWithDuration:2
                              delay:delay
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             barView.originalFrame = CGRectMake(data.x + self.marginLeft, self.marginTop, data.width, self.graphHeight);
                             barView.frame = CGRectMake(data.x + self.marginLeft, self.marginTop, data.width, self.graphHeight);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

-(UIColor*)randomColor
{
    CGFloat aRedValue =(arc4random()%255);
    CGFloat aGreenValue = (arc4random()%255);
    CGFloat aBlueValue = (arc4random()%255);
    
    return [UIColor colorWithRed:aRedValue/256.0 green:aGreenValue/256.0 blue:aBlueValue/256.0 alpha:1];
}

-(void)updateChartData
{
    FNKChartOverlayData* prevBarData = nil;
    for (FNKChartOverlayData* barData in self.dataSet)
    {
        barData.x = barData.x * self.scale;
        
        if (prevBarData)
        {
            prevBarData.width = barData.x - prevBarData.x;
        }
        
        prevBarData = barData;
    }
    
    prevBarData.width = self.graphWidth - prevBarData.x;
}

-(FNKChartOverlayData*)touchAtPoint:(CGPoint)point view:(UIView*)view
{
    FNKChartOverlayData* touchedData = nil;
    for (FNKOverlayBar* barView in self.barsArray)
    {
        CGPoint cPoint = [view convertPoint:point toView: barView];
        BOOL expand = [barView pointInside:cPoint withEvent: nil];
        
        if (expand)
        {
            touchedData = barView.data;
        }
        
        [barView updateBar:expand];
    }
    
    return touchedData;
}

@end

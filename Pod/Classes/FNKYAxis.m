//
//  FNKYAxis.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKYAxis.h"

@implementation FNKYAxis

-(void) drawAxis:(UIView*) view
{
    UIBezierPath* bezPath = [[UIBezierPath alloc] init];
    [bezPath moveToPoint:CGPointMake(self.marginLeft, self.marginTop)];
    [bezPath addLineToPoint:CGPointMake(self.marginLeft, self.graphHeight + self.marginTop)];
    [bezPath closePath];
    
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.path = bezPath.CGPath;
    layer.fillColor = self.fillColor.CGColor;
    layer.strokeColor = self.strokeColor.CGColor;
    
    [view.layer addSublayer:layer];
    
    CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2;
    pathAnimation.fromValue = @(0);
    pathAnimation.toValue = @(1);
    
    [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    //Draw all lines
    CGFloat tickInterval = self.graphHeight / self.ticks;
    for (int index = 0 ; index < self.ticks+1 ; index++)
    {
        UIBezierPath* bezPath = [[UIBezierPath alloc] init];
        
        CGFloat xVal = self.marginLeft;
        CGFloat yVal = self.marginTop + (index * tickInterval);
        
        [bezPath moveToPoint:CGPointMake(xVal, yVal)];
        
        if(self.tickType == FNKTickTypeOutside)
        {
            [bezPath addLineToPoint:CGPointMake(xVal - 3.0, yVal)];
        }
        else if(self.tickType == FNKTickTypeBehind)
        {
            [bezPath addLineToPoint:CGPointMake(xVal + self.graphWidth, yVal)];
        }
        
        CAShapeLayer* layer  = [[CAShapeLayer alloc] init];
        layer.path = bezPath.CGPath;
        layer.fillColor = self.tickFillColor.CGColor;
        layer.strokeColor = self.tickStrokeColor.CGColor;
        
        [view.layer addSublayer:layer];
        
        CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1;
        pathAnimation.fromValue = @(0);
        pathAnimation.toValue = @(1);
        
        [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
}

-(UIView*) addTicksToView:(UIView*) view
{
    CGFloat tickInterval = self.graphHeight / self.ticks;
    
    UIView* labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
    
    for (int index = 0 ; index < self.ticks ; index++)
    {
        if (index == self.ticks)
        {
            continue;
        }
        
        CGFloat yVal = self.marginTop + (index * tickInterval);
        
        //Okay those are the ticks. Now we need the labels
        UILabel* tickLabel = [[UILabel alloc] init];
        
        CGFloat originalVal = ((self.marginTop + self.graphHeight - yVal) / self.scaleFactor) + self.yAxisNum;
        tickLabel.text = self.tickFormat(originalVal);
        [tickLabel sizeToFit];
        tickLabel.frame = CGRectMake(0, yVal-5, tickLabel.frame.size.width, 10);
        tickLabel.textAlignment = NSTextAlignmentLeft;
        tickLabel.font = self.tickFont;
        [labelView addSubview:tickLabel];
    }
    
    [labelView setAlpha:0.0];
    
    [view addSubview:labelView];
    
    [UIView animateWithDuration:1
                     animations:^{
                         [labelView setAlpha:1.0];
    
    }];
    
    
    
    return labelView;
}

@end

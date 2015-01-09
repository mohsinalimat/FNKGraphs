//
//  FNKLineGraph+AverageLine.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 1/2/15.
//  Copyright (c) 2015 fnk. All rights reserved.
//

#import "FNKLineGraph+AverageLine.h"

@implementation FNKLineGraph (AverageLine)

-(void)drawAverageLine:(CGFloat)yVal
{
    if(self.averageLineColor)
    {
        UIBezierPath* bezPath = [[UIBezierPath alloc] init];
        [bezPath moveToPoint:CGPointMake(self.yAxis.marginLeft, yVal)];
        [bezPath addLineToPoint:CGPointMake(self.xAxis.graphWidth + self.yAxis.marginLeft, yVal)];
        
        CAShapeLayer* layer = [[CAShapeLayer alloc] init];
        layer.path = bezPath.CGPath;
        layer.fillColor = self.averageLineColor.CGColor;
        layer.strokeColor = self.averageLineColor.CGColor;
        layer.lineWidth = 1;
        [layer setLineDashPattern:@[@(3),@(5)]];
        layer.lineCap = @"round";
        layer.lineJoin = @"round";
        
        [self.parentView.layer addSublayer:layer];
        
        CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1;
        pathAnimation.fromValue = @(0);
        pathAnimation.toValue = @(1);
        
        [layer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
}

@end

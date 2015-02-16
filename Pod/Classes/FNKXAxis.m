//
//  FNKXAxis.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKXAxis.h"
#import "FNKBar.h"

@implementation FNKXAxis

-(void) drawAxis:(UIView*) view
{
    UIBezierPath* bezPath = [[UIBezierPath alloc] init];
    [bezPath moveToPoint:CGPointMake(self.marginLeft, self.graphHeight)];
    [bezPath addLineToPoint:CGPointMake(self.graphWidth + self.marginLeft, self.graphHeight)];
    [bezPath closePath];
    
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.path = bezPath.CGPath;
    layer.fillColor = self.fillColor.CGColor;
    layer.strokeColor = self.strokeColor.CGColor;
    
    [view.layer addSublayer:layer];
}

-(UIView*) addTicksToView:(UIView*) view
{
    return [self addTicksToView:view tickFormat:nil];
}

-(UIView*) addTicksToView:(UIView*) view tickFormat:(NSString* (^)(CGFloat value))graphTickFormat
{
    CGFloat tickInterval = self.graphWidth / self.ticks;
    
    UIView* labelView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height, view.frame.size.width, 20)];
    
    for (int index = 0 ; index < self.ticks+1 ; index++)
    {
        UIBezierPath* bezPath = [[UIBezierPath alloc] init];
        
        CGFloat xVal = self.marginLeft + (index * tickInterval);
        CGFloat yVal = self.graphHeight;
        
        [bezPath moveToPoint:CGPointMake(xVal, yVal)];
        [bezPath addLineToPoint:CGPointMake(xVal, yVal + 3)];
        
        CAShapeLayer* layer = [[CAShapeLayer alloc] init];
        layer.path = bezPath.CGPath;
        layer.fillColor = self.tickFillColor.CGColor;
        layer.strokeColor = self.tickStrokeColor.CGColor;
        
        [view.layer addSublayer:layer];
        
        //Okay those are the ticks. Now we need the labels
        
        UILabel* tickLabel = [[UILabel alloc] init];
        if(graphTickFormat != nil)
        {
            tickLabel.text = graphTickFormat(xVal);
        }
        else if(self.scaleFactor == 0)
        {
            tickLabel.text = self.tickFormat((xVal - self.marginLeft));
        }
        else
        {
            tickLabel.text = self.tickFormat(((xVal - self.marginLeft) / self.scaleFactor) + self.axisMin);
        }
        [tickLabel sizeToFit];
        CGFloat textWidth = tickLabel.frame.size.width;
        tickLabel.frame = CGRectMake( xVal - textWidth/2, 0, textWidth, 10);
        tickLabel.textAlignment = NSTextAlignmentCenter;
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

-(UIView*) addTicksToView:(UIView*) view atBars:(NSArray*)bars tickFormat:(NSString* (^)(int index))graphTickFormat
{
    UIView* labelView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height, view.frame.size.width, 20)];
    
    int index = 0;
    for (FNKBar* bar in bars)
    {
        UIBezierPath* bezPath = [[UIBezierPath alloc] init];
        
        CGFloat xVal = bar.frame.origin.x + bar.frame.size.width / 2;
        CGFloat yVal = self.graphHeight;
        
        [bezPath moveToPoint:CGPointMake(xVal, yVal)];
        [bezPath addLineToPoint:CGPointMake(xVal, yVal + 3)];
        
        CAShapeLayer* layer = [[CAShapeLayer alloc] init];
        layer.path = bezPath.CGPath;
        layer.fillColor = self.tickFillColor.CGColor;
        layer.strokeColor = self.tickStrokeColor.CGColor;
        
        [view.layer addSublayer:layer];
        
        //Okay those are the ticks. Now we need the labels
        
        UILabel* tickLabel = [[UILabel alloc] init];
        tickLabel.text = graphTickFormat(index);
        [tickLabel sizeToFit];
        CGFloat textWidth = tickLabel.frame.size.width;
        tickLabel.frame = CGRectMake( xVal - textWidth/2, 0, textWidth, 10);
        tickLabel.textAlignment = NSTextAlignmentCenter;
        tickLabel.font = self.tickFont;
        [labelView addSubview:tickLabel];
        
        index++;
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

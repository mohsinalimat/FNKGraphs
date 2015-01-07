//
//  FNKGraph.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKGraph.h"

@interface FNKGraph()

@property (nonatomic,strong) FNKXAxis* xAxis;
@property (nonatomic,strong) FNKYAxis* yAxis;

@end

@implementation FNKGraph

-(FNKGraph*) initWithMarginLeft:(CGFloat)marginLeft marginRight:(CGFloat)marginRight marginTop:(CGFloat)marginTop marginBottom:(CGFloat)marginBottom
{
    if(self = [super init])
    {
        self.xAxis = [[FNKXAxis alloc] initWithMarginLeft:marginLeft marginRight:marginRight marginTop:marginTop marginBottom:marginBottom];
        self.yAxis = [[FNKYAxis alloc] initWithMarginLeft:marginLeft marginRight:marginRight marginTop:marginTop marginBottom:marginBottom];
        self.yPadding = 0;
    }
    
    return self;
}

-(void)draw:(UIView*)view
{
    self.yLabelView = [self.yAxis addTicksToView:view];
    self.xLabelView = [self.xAxis addTicksToView:view];
}

-(void)drawAxii:(UIView*)view
{
    [self.yAxis drawAxis:view];
    
//    [self.xAxis drawAxis:view];
}

@end

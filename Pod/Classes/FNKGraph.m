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

-(void)draw
{    
    [self drawData];
}

-(void)drawAxii:(UIView*)view
{
    [self.yAxis drawAxis:view];
    
//    [self.xAxis drawAxis:view];
}

-(void)drawData
{
    //Should be implemented by child class
}

-(void)setGraphWidth:(CGFloat)graphWidth
{
    _graphWidth = graphWidth;
    [self.xAxis setGraphWidth:graphWidth];
    [self.yAxis setGraphWidth:graphWidth];
}

-(void)setGraphHeight:(CGFloat)graphHeight
{
    _graphHeight = graphHeight;
    [self.xAxis setGraphHeight:graphHeight];
    [self.yAxis setGraphHeight:graphHeight];
}

-(CGFloat)valueAtPoint:(CGPoint)point
{
    return 0;
}

-(void)removeSelection
{
    
}

@end

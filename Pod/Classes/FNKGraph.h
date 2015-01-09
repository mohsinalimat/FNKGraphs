//
//  FNKGraph.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNKYAxis.h"
#import "FNKXAxis.h"

@interface FNKGraph : NSObject

/* xAxis - The X axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,strong, readonly) FNKXAxis* xAxis;

/* yAxis - The Y axis of the graph. This cannot be assigned but it's properties can be*/
@property (nonatomic,strong, readonly) FNKYAxis* yAxis;

@property (nonatomic, strong) UIView* yLabelView;
@property (nonatomic, strong) UIView* xLabelView;
@property (nonatomic) CGFloat yPadding;
@property (nonatomic) CGFloat graphHeight;
@property (nonatomic) CGFloat graphWidth;

@property (nonatomic, weak) UIView* parentView;

-(FNKGraph*) initWithMarginLeft:(CGFloat)marginLeft marginRight:(CGFloat)marginRight marginTop:(CGFloat)marginTop marginBottom:(CGFloat)marginBottom;

-(void)draw;

-(void)drawAxii:(UIView*)view;

//These functions must be implemented by subclasses
-(void)drawData;
-(CGFloat)valueAtPoint:(CGPoint)point;
-(void)removeSelection;

@end

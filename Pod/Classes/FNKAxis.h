//
//  FNKAxis.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    FNKTickTypeOutside, FNKTickTypeBehind
} FNKTickType;

@interface FNKAxis : NSObject

//Graph Sizes
@property (nonatomic) CGFloat marginLeft;
@property (nonatomic) CGFloat marginTop;
@property (nonatomic) CGFloat marginRight;
@property (nonatomic) CGFloat marginBottom;
@property (nonatomic) CGFloat graphHeight;
@property (nonatomic) CGFloat graphWidth;
@property (nonatomic) CGFloat scaleFactor;
@property (nonatomic) CGFloat axisMin;

@property (nonatomic) FNKTickType tickType;

@property (nonatomic) int ticks;
@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic, strong) UIColor* strokeColor;

@property (nonatomic, strong) UIColor* tickFillColor;
@property (nonatomic, strong) UIColor* tickStrokeColor;

@property (nonatomic, strong) UIFont* tickFont;

@property (nonatomic, copy) NSString* (^tickFormat)(CGFloat value);

-(FNKAxis*)initWithMarginLeft:(CGFloat)marginLeft marginRight:(CGFloat)marginRight marginTop:(CGFloat)marginTop marginBottom:(CGFloat)marginBottom;

-(UIView*) addTicksToView:(UIView*) view;

-(void) drawAxis:(UIView*) view;

@end

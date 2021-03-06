//
//  FNKXAxis.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKAxis.h"
#import <UIKit/UIKit.h>

typedef enum {
    FNKTickTypeBelow, FNKTickTypeTallTickBelow,
} FNKXTickType;

@interface FNKXAxis : FNKAxis

@property (nonatomic) FNKXTickType tickType;

-(UIView*) addTicksToView:(UIView*) view tickFormat:(NSString* (^)(CGFloat value))graphTickFormat;
-(UIView*) addTicksToView:(UIView*) view atBars:(NSArray*)bars tickFormat:(NSString* (^)(int index))graphTickFormat;

@end

//
//  FNKXAxis.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKAxis.h"
#import <UIKit/UIKit.h>


@interface FNKXAxis : FNKAxis

-(UIView*) addTicksToView:(UIView*) view tickFormat:(NSString* (^)(CGFloat value))graphTickFormat;

@end

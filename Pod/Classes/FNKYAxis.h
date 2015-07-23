//
//  FNKYAxis.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKAxis.h"

typedef enum {
    FNKYTickTypeOutside, FNKYTickTypeBehind, FNKYTickTypeAbove
} FNKYTickType;

@interface FNKYAxis : FNKAxis

@property (nonatomic) FNKYTickType tickType;

@property (nonatomic) NSNumber* paddingPercentage;

@end

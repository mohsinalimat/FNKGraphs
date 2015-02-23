//
//  FNKAxis.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKAxis.h"

@implementation FNKAxis

-(FNKAxis*)initWithMarginLeft:(CGFloat)marginLeft marginBottom:(CGFloat)marginBottom
{
    if(self = [super init])
    {
        self.marginLeft = marginLeft;
        self.marginBottom = marginBottom;
        self.tickFont = [UIFont fontWithName:@"Avenir" size:9];
        self.animationDuration = .7;
    }
    return self;
}

-(UIView*) addTicksToView:(UIView*) view
{
    return nil;
}

-(void) drawAxis:(UIView*) view
{
}

@end

//
//  FNKChartOverlayData.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKChartOverlayData.h"

@implementation FNKChartOverlayData

-(FNKChartOverlayData*) initWithX:(CGFloat)x data:(NSDictionary*)data
{
    if(self = [super init])
    {
        self.x = x;
        self.data = data;
    }
    return self;
}

@end

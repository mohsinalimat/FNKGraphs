//
//  FNKChartOverlayBars.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKChartOverlayBase.h"
#import "FNKChartOverlayData.h"

@interface FNKChartOverlayBars : FNKChartOverlayBase

@property (nonatomic, strong) NSArray* dataSet;
@property (nonatomic, strong) NSMutableArray* barsArray;

-(void)drawInView:(UIView*)view;

-(FNKChartOverlayData*)touchAtPoint:(CGPoint)point view:(UIView*)view;

@end

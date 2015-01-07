//
//  FNKLineGraph.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNKGraph.h"


@interface FNKLineGraph : FNKGraph

// This is the color that the line graphs line will be
@property (nonatomic, strong) UIColor* lineStrokeColor;

/* averageLineColor - Is the color that the average will show up as*/
@property (nonatomic, strong) UIColor* averageLineColor;

/* averageLine - This is the value where the average line will be. It is always horizontal */
@property (nonatomic) double averageLine;

@end

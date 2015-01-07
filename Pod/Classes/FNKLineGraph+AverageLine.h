//
//  FNKLineGraph+AverageLine.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 1/2/15.
//  Copyright (c) 2015 fnk. All rights reserved.
//

#import "FNKLineGraph.h"

@interface FNKLineGraph (AverageLine)

-(void)drawAverageLine:(CGFloat)yVal parentView:(UIView*)view;

@end

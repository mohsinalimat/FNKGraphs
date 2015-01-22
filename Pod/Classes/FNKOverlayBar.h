//
//  FNKBar.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FNKChartOverlayData.h"

@interface FNKOverlayBar : UIView

@property (nonatomic) CGFloat adjustmentHeight;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic, strong) FNKChartOverlayData* data;

-(FNKOverlayBar*)initWithData:(FNKChartOverlayData*)data frame:(CGRect)frame;
-(void)updateBar:(BOOL)expand;

@end

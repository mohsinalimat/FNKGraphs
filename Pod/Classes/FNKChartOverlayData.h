//
//  FNKChartOverlayData.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FNKChartOverlayData : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic) CGFloat width;

-(FNKChartOverlayData*) initWithX:(CGFloat)x data:(NSDictionary*)data;

@end

//
//  FNKChartOverlayBase.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FNKChartOverlayBase : NSObject

@property (nonatomic) CGFloat marginLeft;
@property (nonatomic) CGFloat marginRight;
@property (nonatomic) CGFloat marginTop;
@property (nonatomic) CGFloat marginBottom;
@property (nonatomic) CGFloat graphWidth;
@property (nonatomic) CGFloat graphHeight;
@property (nonatomic) CGFloat scale;

@end

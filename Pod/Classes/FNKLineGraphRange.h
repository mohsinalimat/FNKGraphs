//
//  FNKLineGraphRange.h
//  Pods
//
//  Created by Phillip Connaughton on 4/10/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FNKLineGraphRange : NSObject

@property (nonatomic) BOOL hasValidValues;

@property (nonatomic) CGFloat xScaleFactor;
@property (nonatomic) CGFloat yScaleFactor;
@property (nonatomic) CGFloat xRange;
@property (nonatomic) CGFloat yRange;
@property (nonatomic) CGFloat minX;
@property (nonatomic) CGFloat minY;

@end

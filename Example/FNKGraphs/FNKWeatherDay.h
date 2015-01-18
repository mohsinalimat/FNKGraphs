//
//  FNKWeatherDay.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 1/13/15.
//  Copyright (c) 2015 Phillip Connaughton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNKWeatherDay : NSObject

@property (nonatomic) CGFloat avgTemp;
@property (nonatomic) CGFloat percipitation;
@property (nonatomic) CGFloat windSpeed;
@property (nonatomic) NSDate* date;

@end

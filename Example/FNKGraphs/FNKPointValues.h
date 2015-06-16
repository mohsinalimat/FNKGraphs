//
//  FNKPointValues.h
//  FNKGraphs
//
//  Created by Phillip Connaughton on 1/9/15.
//  Copyright (c) 2015 Phillip Connaughton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNKPointValues : NSObject

+(NSMutableArray*) addPointsPaceByDistanceOne;
+(NSMutableArray*) addPointsPaceByDistanceTwo;
+(NSMutableArray*) addPointsElevationByDistanceOne;

+(NSMutableArray*) addAllZerosTest;
+(NSMutableArray*) addAllXZerosTest;
+(NSMutableArray*) addAllYZerosTest;
+(NSMutableArray*) addAllOnesTest;
+(NSMutableArray*) addAllNegativeOnesTest;

@end

//
//  FNKBucketData.h
//  Pods
//
//  Created by Phillip Connaughton on 6/16/15.
//
//

#import <Foundation/Foundation.h>

@interface FNKHistogramBucketData : NSObject

@property (nonatomic, strong) NSNumber* data;
@property (nonatomic, strong) NSDate* minDate;
@property (nonatomic, strong) NSDate* maxDate;

//Set's the provided date as the min or max if applicable
-(void)addDate:(NSDate*)date;

@end

//
//  FNKBucketData.m
//  Pods
//
//  Created by Phillip Connaughton on 6/16/15.
//
//

#import "FNKHistogramBucketData.h"

@implementation FNKHistogramBucketData

-(id) init
{
    if(self == [super init])
    {
        self.data = @(0);
    }
    
    return self;
}

-(void)addDate:(NSDate*)date
{
    if(self.minDate == nil || [date compare:self.minDate] == NSOrderedAscending)
    {
        self.minDate = date;
    }
    
    if(self.maxDate == nil || [date compare:self.maxDate] == NSOrderedAscending)
    {
        self.maxDate = date;
    }
}

@end

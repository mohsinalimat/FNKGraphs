//
//  FNKBarSectionData.m
//  Pods
//
//  Created by Phillip Connaughton on 1/12/15.
//
//

#import "FNKBarSectionData.h"

@implementation FNKBarSectionData

+(FNKBarSectionData*)barSectionData:(id)data bucket:(int)bucket
{
    FNKBarSectionData* bsd = [[FNKBarSectionData alloc] init];
    [bsd setData:data];
    [bsd setBucket:bucket];
    return bsd;
}

@end

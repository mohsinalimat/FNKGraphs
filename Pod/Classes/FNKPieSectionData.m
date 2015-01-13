//
//  FNKPieSectionData.m
//  Pods
//
//  Created by Phillip Connaughton on 1/11/15.
//
//

#import "FNKPieSectionData.h"

@implementation FNKPieSectionData

+(FNKPieSectionData*) pieSectionWithName:(NSString*)name color:(UIColor*)color percentage:(CGFloat)percentage
{
    FNKPieSectionData* data = [[FNKPieSectionData alloc] init];
    data.name = name;
    data.color = color;
    data.percentage = percentage;
    return data;
}

@end

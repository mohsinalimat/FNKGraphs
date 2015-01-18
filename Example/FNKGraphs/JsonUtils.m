//
//  JsonUtils.m
//  Mixtura
//
//  Created by Phillip Connaughton on 1/18/14.
//  Copyright (c) 2014 bpc. All rights reserved.
//

#import "JsonUtils.h"

@implementation JsonUtils

+(NSString*) jsonString:(id)object
{
    if(![NSJSONSerialization isValidJSONObject:object])
    {
        NSLog(@"Not valid JSON: %@", [object description]);
    }
    
    NSError* jsonError = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&jsonError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(NSDictionary*) dictionaryFromJson:(NSString*)jsonString
{
    NSError* jsonError = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
}

+(NSArray*) arrayFromJson:(NSString*)jsonString
{
    NSError* jsonError = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
}


@end

//
//  JsonUtils.h
//  Mixtura
//
//  Created by Phillip Connaughton on 1/18/14.
//  Copyright (c) 2014 bpc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject

+(NSString*) jsonString:(id)object;
+(NSDictionary*) dictionaryFromJson:(NSString*)jsonString;
+(NSArray*) arrayFromJson:(NSString*)jsonString;

@end

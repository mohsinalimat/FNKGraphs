//
//  FNKBarSectionData.h
//  Pods
//
//  Created by Phillip Connaughton on 1/12/15.
//
//

#import <Foundation/Foundation.h>

@interface FNKBarSectionData : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic) int bucket;

+(FNKBarSectionData*)barSectionData:(id)data bucket:(int)bucket;

@end

//
//  FNKPieSectionData.h
//  Pods
//
//  Created by Phillip Connaughton on 1/11/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FNKPieSectionData : NSObject

@property (nonatomic) CGFloat percentage;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) CAShapeLayer* slice;

+(FNKPieSectionData*) pieSectionWithName:(NSString*)name color:(UIColor*)color percentage:(CGFloat)percentage;

@end

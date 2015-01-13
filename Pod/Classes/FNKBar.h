//
//  FNKBar.h
//  Pods
//
//  Created by Phillip Connaughton on 1/13/15.
//
//

#import <UIKit/UIKit.h>
#import "FNKBarSectionData.h"

@interface FNKBar : UIView

@property (nonatomic) CGFloat adjustmentHeight;
@property (nonatomic) CGRect originalFrame;
//@property (nonatomic, strong) FNKBarSectionData* data;

//-(FNKBar*)initWithData:(FNKBarSectionData*)data frame:(CGRect)frame;
-(void)updateBar:(BOOL)expand;

@end

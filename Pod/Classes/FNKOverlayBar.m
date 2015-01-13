//
//  FNKBar.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKOverlayBar.h"

@implementation FNKOverlayBar


-(FNKOverlayBar*)initWithData:(FNKChartOverlayData*)data frame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.data = data;
        self.adjustmentHeight = 5;
    }
    return self;
}


-(void)updateBar:(BOOL)expand
{
    if(expand)
    {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x, self.originalFrame.origin.y - self.adjustmentHeight, self.frame.size.width, self.originalFrame.size.height + self.adjustmentHeight);
                             self.alpha = .7;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x, self.originalFrame.origin.y, self.frame.size.width, self.originalFrame.size.height);
                             self.alpha = 0.2;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
}

@end

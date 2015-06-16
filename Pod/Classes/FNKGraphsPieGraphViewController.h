//
//  FNKGraphsPieGraphViewController.h
//  Pods
//
//  Created by Phillip Connaughton on 1/11/15.
//
//

#import "FNKGraphsViewController.h"

@interface FNKGraphsPieGraphViewController : FNKGraphsViewController

@property (nonatomic) CGFloat xLabelPosPercentOfRadius;
@property (nonatomic) CGFloat yLabelPosPercentOfRadius;

@property (nonatomic, copy) int (^numberOfSlices)();
@property (nonatomic, copy) NSInteger (^sliceForObject)(id object);
@property (nonatomic, copy) CGFloat (^valueForObject)(id object);
@property (nonatomic, copy) UIColor* (^colorForSlice)(int sliceNum);
@property (nonatomic, copy) NSString* (^nameForSlice)(int sliceNum);
@property (nonatomic, strong) UIColor* sliceLabelColor;
@property (nonatomic, strong) UIColor* sliceBorderColor;
@property (nonatomic, strong) UIFont* sliceLabelFont;

-(FNKGraphsPieGraphViewController*)initWithFrame:(CGRect)frame;


@end
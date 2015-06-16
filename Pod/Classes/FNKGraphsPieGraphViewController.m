//
//  FNKGraphsPieGraphViewController.m
//  Pods
//
//  Created by Phillip Connaughton on 1/11/15.
//
//

#import "FNKGraphsPieGraphViewController.h"
#import "FNKPieSectionData.h"

#define DEG2RAD(angle) angle*M_PI/180.0
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )
#define fnkSliceLineWidth 1
#define fnkSelectedSliceLineWidth 2
#define fnkMinPercentForLabel .04
#define fnkLabelAnimationDuration .3

@interface FNKGraphsPieGraphViewController ()

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGPoint center;
@property (nonatomic) FNKPieSectionData* selectedSlice;
@property (nonatomic) int selectedSliceIndex;

@end

@implementation FNKGraphsPieGraphViewController

-(FNKGraphsPieGraphViewController*)initWithFrame:(CGRect)frame
{
    return [self initWithRect:frame
                   marginLeft:0
                 marginBottom:0
                   graphWidth:frame.size.width
                  graphHeight:frame.size.height];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupLocalVars
{
}

-(void)willAppear
{
    
}

-(void)removeSelection
{
}

-(void)drawGraph:(void (^) (void))completion
{
    [super drawGraph:nil];
    self.radius = self.graphHeight >= self.graphWidth ? self.graphWidth / 2 : self.graphHeight / 2;
    self.center = CGPointMake(self.graphWidth/2, self.graphHeight/2);
    
    int numSlices = self.numberOfSlices();
    self.graphData = [NSMutableArray array];
    
    for(int i = 0 ; i < numSlices ; i++)
    {
        FNKPieSectionData* data = [[FNKPieSectionData alloc] init];
        [self.graphData addObject:data];
    }
    
    CGFloat totalValue = 0.0;
    for(id data in self.dataArray)
    {
        NSInteger sliceNum = self.sliceForObject(data);
        FNKPieSectionData* sectionData = [self.graphData objectAtIndex:sliceNum];
        
        CGFloat objectValue = self.valueForObject(data);
        [sectionData setSliceValue:@(sectionData.sliceValue.floatValue + objectValue)];
        totalValue += objectValue;
    }
    
    int i = 0;
    for(FNKPieSectionData* data in self.graphData)
    {
        [data setPercentage:(data.sliceValue.floatValue / totalValue)];
        [data setColor:self.colorForSlice(i)];
        [data setName:self.nameForSlice(i)];
        i++;
    }
    
    [self drawPie:self.graphData];
    
    if(completion)
    {
        completion();
    }
}

-(CAShapeLayer*)drawPie:(NSMutableArray*)data
{
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    
    CGFloat start = 0;
    for(FNKPieSectionData* sectionData in data)
    {
        CGFloat end = 360*sectionData.percentage + start;
        sectionData.slice = [self createPieSlice:start endAngle:end color:sectionData.color];
        sectionData.sliceLabel = [self addLabelForSlice:sectionData startAngle:start endAngle:end];
        start = end;
    }
    
    return layer;
}

-(CGPathRef)createPieSliceWithCenter:(CGPoint)center
                              radius:(CGFloat)radius
                          startAngle:(CGFloat)degStartAngle
                            endAngle:(CGFloat)degEndAngle {
    
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center];
    
    CGFloat xAddition = radius * cosf(DEG2RAD(-degStartAngle));
    CGFloat yAddition = radius * sinf(DEG2RAD(-degStartAngle));
    
    [piePath addLineToPoint:CGPointMake(center.x + xAddition, center.y + yAddition)];
    
    [piePath addArcWithCenter:center radius:radius startAngle:DEG2RAD(-degStartAngle) endAngle:DEG2RAD(-degEndAngle) clockwise:NO];
    
    [piePath closePath]; // this will automatically add a straight line to the center
    
    return piePath.CGPath;
}

-(CAShapeLayer *)createPieSlice:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor*)color
{
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.fillColor = color.CGColor;
    slice.strokeColor = self.sliceBorderColor.CGColor;
    slice.lineWidth = fnkSliceLineWidth;
    slice.path = [self createPieSliceWithCenter:self.center radius:self.radius startAngle:startAngle endAngle:endAngle];
    
    [self.view.layer insertSublayer:slice atIndex:0];
    return slice;
}

-(UILabel*)addLabelForSlice:(FNKPieSectionData*) data startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    CGFloat labelAngle = startAngle + (endAngle - startAngle)/2;
    
    CGFloat xDistFromRadius = (self.xLabelPosPercentOfRadius == 0) ? 1.0 : (self.xLabelPosPercentOfRadius / 100);
    CGFloat yDistFromRadius = (self.yLabelPosPercentOfRadius == 0) ? 1.0 : (self.yLabelPosPercentOfRadius / 100);
    
    CGFloat labelX = self.center.x + (self.radius * xDistFromRadius) * cos(DEG2RAD(labelAngle));
    CGFloat labelY = self.center.y + (self.radius * yDistFromRadius) * sin(DEG2RAD(-labelAngle));
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labelX-50, labelY-10, 100, 20)];
    [label setTextColor:self.sliceLabelColor];
    [label setText:data.name];
    [label setFont:self.sliceLabelFont];
    
    if(data.percentage < fnkMinPercentForLabel)
    {
        [label setAlpha:0.0];
    }
    
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    return label;
}

#pragma mark Handle touches

// we capture the touch move events by overriding touchesMoved method

-(void)touchedGraphAtPoint:(CGPoint)point userGenerated:(BOOL)userGenerated
{
    CGFloat value = [self valueAtPoint:point];
    
    FNKPieSectionData* data = [self dataForDegree:value];
    
    //Clear out the previous selection
    if([data isEqual:self.selectedSlice])
    {
        self.selectedSliceIndex = -1;
        self.selectedSlice = nil;
    }
    else
    {
        self.selectedSlice = data;
    }
    
    int index = 0;
    
    for(FNKPieSectionData* d in self.graphData)
    {
        if(self.selectedSlice != nil)
        {
            if(![d isEqual:self.selectedSlice])
            {
                CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
                colorAnimation.toValue = (id)[UIColor grayColor].CGColor;
                [colorAnimation setRemovedOnCompletion:NO];
                [colorAnimation setFillMode:kCAFillModeForwards];
                
                [d.slice addAnimation:colorAnimation forKey:nil];
                
                CABasicAnimation *widthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
                widthAnimation.toValue = (id)[NSNumber numberWithInt:fnkSliceLineWidth];
                [widthAnimation setRemovedOnCompletion:NO];
                [widthAnimation setFillMode:kCAFillModeForwards];
                
                [d.slice addAnimation:widthAnimation forKey:nil];
                
                if(d.sliceLabel.alpha == 1.0)
                {
                    [UIView animateWithDuration:.2
                                     animations:^{
                                         [d.sliceLabel setAlpha:0.0];
                                     }];
                }
            }
            else
            {
                self.selectedSliceIndex = index;
                CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
                colorAnimation.toValue = (id)d.color.CGColor;
                [colorAnimation setRemovedOnCompletion:NO];
                [colorAnimation setFillMode:kCAFillModeForwards];
                
                [d.slice addAnimation:colorAnimation forKey:nil];
                
                CABasicAnimation *widthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
                widthAnimation.toValue = (id)[NSNumber numberWithInt:fnkSelectedSliceLineWidth];
                [widthAnimation setRemovedOnCompletion:NO];
                [widthAnimation setFillMode:kCAFillModeForwards];
                
                [d.slice addAnimation:widthAnimation forKey:nil];
                
                if(d.sliceLabel.alpha == 0.0)
                {
                    [UIView animateWithDuration:.2
                                     animations:^{
                                         [d.sliceLabel setAlpha:1.0];
                                     }];
                }
            }
        }
        else
        {
            CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
            colorAnimation.toValue = (id)d.color.CGColor;
            [colorAnimation setRemovedOnCompletion:NO];
            [colorAnimation setFillMode:kCAFillModeForwards];
            
            [d.slice addAnimation:colorAnimation forKey:nil];
            
            CABasicAnimation *widthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
            widthAnimation.toValue = (id)[NSNumber numberWithInt:fnkSliceLineWidth];
            [widthAnimation setRemovedOnCompletion:NO];
            [widthAnimation setFillMode:kCAFillModeForwards];
            
            [d.slice addAnimation:widthAnimation forKey:nil];
            
            if(d.percentage > fnkMinPercentForLabel && d.sliceLabel.alpha == 0.0)
            {
                [UIView animateWithDuration:.2
                                 animations:^{
                                     [d.sliceLabel setAlpha:1.0];
                                 }];
            }
            else if(d.percentage < fnkMinPercentForLabel)
            {
                [UIView animateWithDuration:.2
                                 animations:^{
                                     [d.sliceLabel setAlpha:0.0];
                                 }];
            }
        }
        
        index++;
    }
    
    //Okay let's select that section of the graph
    
    if(self.delegate)
    {
        [self.delegate pieSliceSelected:self sliceIndex:self.selectedSliceIndex];
    }
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    //Pie graphs will not implement this
}

-(void)handleTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    
    [self handleGesture:point];
}

-(void) handleGesture:(CGPoint)point
{
    if(point.x > self.graphWidth + self.marginLeft || point.x < self.marginLeft)
    {
        [self removeSelection];
        
        if(self.delegate)
        {
            [self.delegate graphTouchesEnded:self];
        }
    }
    else
    {
        [self touchedGraphAtPoint:point userGenerated:YES];
    }
}

-(void) focusAtPoint:(CGPoint)point show:(BOOL)show
{
    //ViewController should override
}

-(CGFloat)valueAtPoint:(CGPoint)point
{
    //This function handles selecting a piece of the pie
    CGFloat xValue = point.x - self.center.x;
    CGFloat yValue = point.y - self.center.y;
    
    //We need to determine which piece of the pie has been touched
    //To do that we need to figure out which degree this would be in.
    //To do so we can subtract the center from the value and then work backwards to determine the angle
    
    CGFloat tan = atan2(yValue, xValue);
    
    CGFloat degrees = radiansToDegrees(tan);
    
    if(degrees < 0)
    {
        degrees = fabs(degrees);
    }
    else
    {
        degrees = 180 + (180 - degrees);
    }
    
    return degrees;
}

-(FNKPieSectionData*)dataForDegree:(CGFloat)degrees
{
    CGFloat start = 0;
    for(FNKPieSectionData* sectionData in self.graphData)
    {
        CGFloat end = 360*sectionData.percentage + start;
        
        if(degrees >= start && degrees <= end)
        {
            return sectionData;
        }
        start = end;
    }
    
    return nil;
}

@end

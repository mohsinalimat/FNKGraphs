//
//  FNKGraphsViewController.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKGraphsViewController.h"
#import "FNKChartOverlayBars.h"
#import "FNKChartOverlayData.h"

@interface FNKGraphsViewController ()

@property (nonatomic) CGFloat marginLeft;
@property (nonatomic) CGFloat marginRight;
@property (nonatomic) CGFloat marginTop;
@property (nonatomic) CGFloat marginBottom;
@property (nonatomic) CGFloat graphWidth;
@property (nonatomic) CGFloat graphHeight;

@property (nonatomic) BOOL drawBars;

@end

@implementation FNKGraphsViewController

-(FNKGraphsViewController*)initWithFrame:(CGRect)frame
{
    return [self initWithRect:frame
                   marginLeft:10
                  marginRight:10
                    marginTop:5
                 marginBottom:5
                   graphWidth:frame.size.width - 10 - 10
                  graphHeight:frame.size.height - 5 - 5];
}

-(FNKGraphsViewController*)initWithRect:(CGRect)rect marginLeft:(CGFloat)marginLeft marginRight:(CGFloat)marginRight marginTop:(CGFloat) marginTop marginBottom:(CGFloat)marginBottom graphWidth:(CGFloat)graphWidth graphHeight:(CGFloat)graphHeight
{
    if(self = [super init])
    {        
        self.marginLeft = marginLeft;
        self.marginRight = marginRight;
        self.marginTop = marginTop;
        self.marginBottom = marginBottom;
        self.graphWidth = graphWidth;
        self.graphHeight = graphHeight;

        self.drawBars = false;
        
        [self initializers];
    }
    return self;
}

-(void)initializers
{
    
}

-(void)viewDidLoad
{    
    [super viewDidLoad];
    
    [self.view setUserInteractionEnabled:YES];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.hasDrawn)
    {
        CGFloat height = self.view.frame.size.height - self.marginTop - self.marginBottom;
        CGFloat width = self.view.frame.size.width - self.marginLeft - self.marginRight;
        
        self.graphHeight = height;
        self.graphWidth = width;
    }
}

-(void) addChartOverlay:(FNKChartOverlayBars*)chartOverlay
{
    self.chartOverlay = chartOverlay;
}

// we capture the touch move events by overriding touchesMoved method

-(void)touchedGraphAtPoint:(CGPoint)point userGenerated:(BOOL)userGenerated
{
    //ViewController should override
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    //ViewController should override
}

-(void)handleTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    
    [self handleGesture:point];
}

-(void) handleGesture:(CGPoint)point
{
    //ViewController should override
}

-(void) focusAtPoint:(CGPoint)point show:(BOOL)show
{
    //ViewController should override
}

@end

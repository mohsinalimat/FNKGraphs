//
//  FNKGraphsViewController.m
//  FNKGraphs
//
//  Created by Phillip Connaughton on 11/26/14.
//  Copyright (c) 2014 fnk. All rights reserved.
//

#import "FNKGraphsViewController.h"
#import "FNKLineGraph.h"
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

@property (nonatomic) BOOL hasDrawn;

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
                  graphHeight:frame.size.height - 5 - 5
                     yPadding:0];
}

-(FNKGraphsViewController*)initWithRect:(CGRect)rect marginLeft:(CGFloat)marginLeft marginRight:(CGFloat)marginRight marginTop:(CGFloat) marginTop marginBottom:(CGFloat)marginBottom graphWidth:(CGFloat)graphWidth graphHeight:(CGFloat)graphHeight yPadding:(CGFloat)yPadding
{
    if( self = [super init])
    {
        self.yPadding = yPadding;
        self.marginLeft = marginLeft;
        self.marginRight = marginRight;
        self.marginTop = marginTop;
        self.marginBottom = marginBottom;
        self.graphWidth = graphWidth;
        self.graphHeight = graphHeight;
        
        self.yPadding = yPadding;
        self.drawBars = false;
        
        self.chart = [[FNKLineGraph alloc] initWithMarginLeft:marginLeft marginRight:marginRight marginTop:marginTop marginBottom:marginBottom];
        
        self.chart.xAxis.ticks = 5;
        self.chart.yAxis.ticks = 5;
        
    }
    return self;
}

-(void)viewDidLoad
{    
    [super viewDidLoad];
    
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
        
        [self.chart setGraphHeight:height];
        [self.chart setGraphWidth:width];
        [self.chart setParentView:self.view];
        
        [self.chart willAppear];
        
        if(self.chartOverlay)
        {
            self.chartOverlay.marginBottom = self.marginBottom;
            self.chartOverlay.marginTop = self.marginTop;
            self.chartOverlay.marginRight = self.marginRight;
            self.chartOverlay.marginLeft = self.marginLeft;
            self.chartOverlay.graphWidth = self.graphWidth;
            self.chartOverlay.graphHeight = self.graphHeight;
        }
    }
}

-(void) addChartOverlay:(FNKChartOverlayBars*)chartOverlay
{
    self.chartOverlay = chartOverlay;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.hasDrawn)
    {
        [self.chart drawAxii:self.view];
        
        __weak __typeof(self) safeSelf = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [safeSelf loadData];
        });
        self.hasDrawn = YES;
    }
}

-(void)loadData
{
    [self.chart loadData:self.dataArray];
    [self.chart draw];
    
    if (self.chartOverlay != nil)
    {
        [self.chartOverlay drawInView:self.view];
        self.chart.yLabelView.userInteractionEnabled = false;
    }
}

// we capture the touch move events by overriding touchesMoved method

-(void)touchedGraphAtPoint:(CGPoint)point userGenerated:(BOOL)userGenerated
{
    //Take the x value and get the corresponding y value;
    
    CGFloat value = [self.chart valueAtPoint:point];
    
    [self.delegate touchedGraph:self val:value point:point userGenerated:userGenerated];
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.chart removeSelection];
        [self.delegate graphTouchesEnded:self];
    }
    else
    {
        [self handleGesture:point];
    }
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
        [self.chart removeSelection];
        [self.delegate graphTouchesEnded:self];
    }
    else
    {
        [self touchedGraphAtPoint:point userGenerated:YES];
        
        FNKChartOverlayData* data = [self.chartOverlay touchAtPoint:point view:self.view];
        
        if (data != nil)
        {
            [self.delegate touchedBar:self data: data];
        }
    }
}

-(void) focusAtPoint:(CGPoint)point show:(BOOL)show
{
    if(show)
    {
        [self touchedGraphAtPoint:point userGenerated:NO];
    }
    else
    {
        [self.chart removeSelection];
    }
}

@end

//
//  Pods_FNKGraphs_Tests.m
//  Pods-FNKGraphs Tests
//
//  Created by Phillip Connaughton on 4/10/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FNKPointUtils.h"

@interface Pods_FNKGraphs_Tests : XCTestCase

@property (nonatomic, strong) NSMutableArray* points;

@end

@implementation Pods_FNKGraphs_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    CGPoint point = CGPointMake(8102,309);
    NSValue* val = [NSValue valueWithCGPoint:point];
    
    self.points = [NSMutableArray array];
    [self.points addObject:val];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8126.988265,300.156521)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8168.134679,433.849210)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8192.783575,462.880365)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8218.568141,481.063257)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8249.879053,521.594813)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8271.641812,535.833009)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8293.923030,540.046100)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8329.755630,438.060678)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8354.062829,393.129118)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8377.109253,350.610571)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8415.966958,289.484548)]];
    [self.points addObject:[NSValue valueWithCGPoint:CGPointMake(8441.897111,268.725668)]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    FNKLineGraphRange* range = [FNKPointUtils calcMaxMinLineGraph:self.points
                                                   overridingXMin:@(0)
                                                   overridingXMax:@(0)
                                                   overridingYMin:@(0)
                                                   overridingYMax:@(0)
                                               yPaddingPercentage:@(0)
                                                       graphWidth:320
                                                      graphHeight:150];
    XCTAssert(!range.hasValidValues, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

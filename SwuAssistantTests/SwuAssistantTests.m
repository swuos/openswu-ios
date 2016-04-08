//
//  SwuAssistantTests.m
//  SwuAssistantTests
//
//  Created by Kric on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Router.h"


@interface SwuAssistantTests : XCTestCase

@end

@implementation SwuAssistantTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample {
//    XCTAssert(1 == 1);
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

- (void)testLogin {
    Router *r = [Router sharedInstance];
    XCTestExpectation *expectation = [self expectationWithDescription:@"test"];
    
    [r loginWithName:@"x352389286" Password:@"123456" CompletionHandler:^(NSString *string) {
        [expectation fulfill];
        XCTAssert([string containsString:@"successed"] == true, @"Server may be down");
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError * _Nullable error) {
        
    }];
}

- (void)testGetGrade {
    Router *r = [Router sharedInstance];
    XCTestExpectation *expectation = [self expectationWithDescription:@"tex"];
    [r getGradesInAcademicYear:@"2015" Semester:@"1" CompletionHandler:^(NSString *resultString) {
        [expectation fulfill];
        XCTAssertEqual(@"successed", resultString, "server may be down");
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end

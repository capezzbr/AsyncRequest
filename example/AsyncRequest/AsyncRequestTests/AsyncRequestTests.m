//
//  AsyncRequestTests.m
//  AsyncRequestTests
//
//  Created by Bruno Capezzali on 15/04/14.
//  Copyright (c) 2014 Bruno Capezzali. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AsyncRequest.h"

static NSString *kWrongURL  = @"http:/wwwerror.url/problem";
static NSString *kRightURL  = @"http://brunocapezzali.com/examples/capezzbrTweetsAPI.php";

// Set the flag for a block completion handler
#define StartBlock() __block BOOL waitingForBlock = YES

// Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO

// Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
#define WaitWhile(condition) \
do { \
    while(condition) { \
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
    } \
} while(0)

// Macro defined for creating a small delay
#define WaitFor(seconds) \
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:seconds]]


@interface AsyncRequestTests : XCTestCase

@end

@implementation AsyncRequestTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWrongURL {
    StartBlock();
    AsyncRequest *request =
    [AsyncRequest requestWithURL:kWrongURL
                          params:nil
                       onSuccess:^(NSData *data) {
                           XCTAssert(NO, @"onSuccess called with wrong URL");
                           EndBlock();
                       } onErrror:^(NSError *error) {
                           XCTAssertNotNil(error, @"onError called with empty error parameter");
                           EndBlock();
                       }];
    [request setTimeoutInterval:4]; // seconds
    [request start];
    WaitUntilBlockCompletes();
    WaitFor(1); // else the tests end before the object dealloc
}

- (void)testRightURL {
    StartBlock();
    AsyncRequest *request =
    [AsyncRequest requestWithURL:kRightURL
                          params:nil
                       onSuccess:^(NSData *data) {
                           XCTAssert([data length] > 0, @"No data returned in onSuccess callback");
                           EndBlock();
                       } onErrror:^(NSError *error) {
                           XCTAssert(NO, @"onErrror called with right URL");
                           EndBlock();
                       }];
    [request setTimeoutInterval:4]; // seconds
    [request start];
    WaitUntilBlockCompletes();
}

- (void)testTimeout {
    StartBlock();
    AsyncRequest *request =
    [AsyncRequest requestWithURL:kRightURL
                          params:nil
                       onSuccess:^(NSData *data) {
                           XCTAssert(NO, @"onSuccess called but instead had to call onError");
                           EndBlock();
                       } onErrror:^(NSError *error) {
                           XCTAssertNotNil(error, @"onError called with empty error parameter");
                           XCTAssertEqual(error.code, kCFURLErrorTimedOut, @"Error isn't timeout");
                           EndBlock();
                       }];
    [request setTimeoutInterval:0.5f]; // seconds
    [request start];
    WaitUntilBlockCompletes();
}

- (void)testCancelRequest {
    StartBlock();
    AsyncRequest *request =
    [AsyncRequest requestWithURL:kRightURL
                          params:nil
                       onSuccess:^(NSData *data) {
                           XCTAssertNil(data, @"data is not nil when request was cancelled");
                           EndBlock();
                       } onErrror:^(NSError *error) {
                           XCTAssert(NO, @"onErrror called when request was cancelled");
                           EndBlock();
                       }];
    [request setTimeoutInterval:4]; // seconds
    [request start];
    WaitFor(0.5f);
    [request cancel]; // force a request cancel after half second
    WaitUntilBlockCompletes();
}

@end

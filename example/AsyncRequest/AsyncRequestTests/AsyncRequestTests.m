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
static NSString *kBigFile   = @"https://central.github.com/mac/latest";

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
                           XCTAssert(NO, @"This must return error");
                           EndBlock();
                       } onErrror:^(NSError *error) {
                           XCTAssertNotNil(error, @"Error not occurred with wrong URL");
                           EndBlock();
                       }];
    [request setTimeoutInterval:4]; // seconds
    [request start];
    
    WaitUntilBlockCompletes();
}

@end

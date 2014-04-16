//
//  ViewController.m
//  AsyncRequest
//
//  Created by Bruno Capezzalion 15/04/14.
//  Copyright (c) 2014 Bruno Capezzali. All rights reserved.
//

#import "ViewController.h"
#import "AsyncRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)refreshTweets:(id)sender {
    
    NSString *requestURL = @"http://brunocapezzali.com/examples/capezzbrTweetsAPI.php";
    AsyncRequest *request =
    [AsyncRequest requestWithURL:requestURL
                          params:@{@"limitTweets": [NSNumber numberWithInt:3], @"otherParameter": @"empty"}
                       onSuccess:^(NSData *data) {
                           NSLog(@"OK: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                       } onErrror:^(NSError *error) {
                           NSLog(@"ERRORE");
                       }];
    [request setTimeoutInterval:4]; // seconds
    [request start];
}

@end

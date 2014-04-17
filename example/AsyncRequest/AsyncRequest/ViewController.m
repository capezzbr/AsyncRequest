//
//  ViewController.m
//  AsyncRequest
//
//  Created by Bruno Capezzalion 15/04/14.
//  Copyright (c) 2014 Bruno Capezzali. All rights reserved.
//

#import "ViewController.h"
#import "AsyncRequest.h"
#import <QuartzCore/QuartzCore.h>

#define kCustomCellNameField        (1)
#define kCustomCellTimestampField   (2)
#define kCustomCellStatusField      (3)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadTweets];
}

- (IBAction)refreshTweets:(id)sender {
    [self loadTweets];
}

#pragma mark -- Core functions

- (void)loadTweets {
    [self showLoadingView];
    AsyncRequest *request =
    [AsyncRequest requestWithURL:@"http://brunocapezzali.com/examples/capezzbrTweetsAPI.php"
                          params:@{@"limitTweets": [NSNumber numberWithInt:20], @"otherParameter": @"empty"}
                       onSuccess:^(NSData *data) {
                           [self hideLoadingView];
                           [self processTweets:data];
                       } onErrror:^(NSError *error) {
                           [self hideLoadingView];
                           [self showErrorDialog:error.localizedDescription withTitle:@"Error"];
                       }];
    [request setTimeoutInterval:4]; // seconds
    [request start];
}

-(void)processTweets:(NSData *)response {
    NSError *jsonParsingError = nil;
    self.tweets = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    if ( jsonParsingError == nil && self.tweets ) {
        [self.resultTable reloadData];
    }
}

#pragma mark -- UITableView's Stuffs

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CustomTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:kCustomCellNameField];
    nameLabel.text = [@"@" stringByAppendingString:[tweet objectForKey:@"username"]];
    
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:kCustomCellTimestampField];
    timeLabel.text = [tweet objectForKey:@"time"];
    
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:kCustomCellStatusField];
    statusLabel.text = [tweet objectForKey:@"status"];
    statusLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

#pragma mark -- Some GUI's Stuffs

- (CGSize)screenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize size = screenRect.size;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        size = CGSizeMake(size.height, size.width);
    }
    return size;
}

- (UIView *)rootView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.rootViewController.view;
}

- (UIView *)viewRectangle {
    CGSize winSize = [self screenSize];
    int side = MIN(winSize.width, winSize.height)*0.5f;
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake((winSize.width-side)*0.5f,
                                                                 (winSize.height-side)*0.5f, side, side)];
    [blackView setBackgroundColor:[UIColor darkGrayColor]];
    [blackView setAlpha:0.9f];
    [[blackView layer] setCornerRadius:12];
    [[blackView layer] setMasksToBounds:YES];
    return blackView;
}

- (UIActivityIndicatorView *)activityIndicator {
    CGSize winSize = [self screenSize];
    int side = MIN(winSize.width, winSize.height)*0.5f;
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setCenter:CGPointMake(side*0.5f, side*0.5f)];
    [activityIndicator startAnimating];
    return activityIndicator;
}

- (void)showLoadingView {
    if ( _loadingView != nil ) return;
    
    UIView *rootView = [self rootView];
    rootView.userInteractionEnabled = NO;
    _loadingView = [self viewRectangle];
    [_loadingView addSubview:[self activityIndicator]];
    [rootView addSubview:_loadingView];
}

- (void)hideLoadingView {
    if ( _loadingView == nil ) return;
    
    UIView *rootView = [self rootView];
    rootView.userInteractionEnabled = YES;
    [_loadingView removeFromSuperview];
    _loadingView = nil;
}

-(void)showErrorDialog:(NSString *)message withTitle:(NSString *)title {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:title message:message delegate:nil
                     cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}

@end

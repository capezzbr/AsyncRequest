//
//  ViewController.h
//  AsyncRequest
//
//  Created by Bruno Capezzalion 15/04/14.
//  Copyright (c) 2014 Bruno Capezzali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    __strong UIView *_loadingView;
}

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, weak) IBOutlet UITableView *resultTable;

@end

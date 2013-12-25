//
//  WRecentsViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRecentsViewController.h"

@interface WRecentsViewController ()

@end

@implementation WRecentsViewController


#pragma mark -
#pragma mark Initialization methods

- (void)reload {
    [WRequest listRecentFilesWithSuccess:^(id json) {
        self.data = json;
        [self endRefreshing];
    } failure:^(id error) {
        DDLogError(@"Failure while listing favorite files: %@", error);
        [self endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"RecentsPageTitle");
    self.homeCellIndex = kHomeRecentsCellIndex;
}

@end

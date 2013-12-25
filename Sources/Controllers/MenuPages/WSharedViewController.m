//
//  WSharedViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WSharedViewController.h"

@interface WSharedViewController ()

@end

@implementation WSharedViewController


#pragma mark -
#pragma mark Initialization methods

- (void)reload {
    [WRequest listSharedFilesWithSuccess:^(id json) {
        self.data = json;
        [self.refreshControl endRefreshing];
    } failure:^(id error) {
        DDLogError(@"Failure while listing shared files: %@", error);
        [self.refreshControl endRefreshing];
    }];
    
//    [self.noFileLabel setText:@"No webservice available"];
//    self.data = @{};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"SharedPageTitle");
    self.homeCellIndex = kHomeSharedCellIndex;
}

@end

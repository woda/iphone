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
//    [WRequest listUpdatedFilesWithSuccess:^(id json) {
//        self.data = json;
//    } failure:^(id error) {
//        DDLogError(@"Failure while listing favorite files: %@", error);
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"SharedPageTitle");
    self.homeCellIndex = kHomeSharedCellIndex;
}

@end

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

- (id)init {
    self = [super init];
    if (self) {
        [WRequest listUpdatedFilesWithSuccess:^(id json) {
            self.data = json;
        } failure:^(id error) {
            DDLogError(@"Failure while listing favorite files: %@", error);
        }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"RecentsPageTitle");
    self.homeCellIndex = kHomeRecentsCellIndex;
}

@end

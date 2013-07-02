//
//  WSharedViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WSharedViewController.h"
#import "WHomeViewController.h"

@interface WSharedViewController ()

@end

@implementation WSharedViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Shared";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [((WNavigationController *)self.navigationController).homeController setSelected:kHomeSharedCellIndex];
}

@end

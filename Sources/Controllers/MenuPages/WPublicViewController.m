//
//  WPublicViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WPublicViewController.h"
#import "WHomeViewController.h"

@interface WPublicViewController ()

@end

@implementation WPublicViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Public";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [((WNavigationController *)self.navigationController).homeController setSelected:kHomePublicCellIndex];
}

@end

//
//  WRootViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRootViewController.h"

@interface WRootViewController ()

@end

@implementation WRootViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Woda";
    self.homeCellIndex = kHomeFoldersCellIndex;
}

@end

//
//  WPublicViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WPublicViewController.h"

@interface WPublicViewController ()

@end

@implementation WPublicViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Public";
    self.homeCellIndex = kHomePublicCellIndex;
}

@end
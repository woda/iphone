//
//  WUploadingViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUploadingViewController.h"

@interface WUploadingViewController ()

@end

@implementation WUploadingViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Uploading";
    self.homeCellIndex = kHomeUploadCellIndex;
}

@end

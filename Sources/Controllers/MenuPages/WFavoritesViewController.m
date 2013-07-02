//
//  WFavoritesViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WFavoritesViewController.h"
#import "WHomeViewController.h"

@interface WFavoritesViewController ()

@end

@implementation WFavoritesViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Favorites";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [((WNavigationController *)self.navigationController).homeController setSelected:kHomeFavoritesCellIndex];
}

@end

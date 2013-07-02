//
//  WHomeViewController.m
//  Woda
//
//  Created by Théo LUBERT on 11/21/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WHomeViewController.h"
#import "NSManagedObjectContext-EasyFetch.h"
#import "NSArray+Shortcuts.h"
#import "WUser.h"
#import "WRootViewController.h"
#import "WFavoritesViewController.h"
#import "WRecentsViewController.h"
#import "WUploadingViewController.h"
#import "WOfflineViewController.h"
#import "WSharedViewController.h"
#import "WPublicViewController.h"
#import "WSettingViewController.h"

@interface WHomeViewController ()

@end

@implementation WHomeViewController


#pragma mark -
#pragma mark Initialization methods

- (id)init {
    self = [super initWithNibName:[self xibFullName:@"WHomeView"] bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:kFileUpdated object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:kUserStatusChanged object:nil];
    }
    return self;
}

- (void)updateLabels {
    // do nothing
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    [self updateLabels];
}

- (void)setSelected:(HomeCellIndex)index {
    [_foldersCell setSelected:NO];
    [_favoritesCell setSelected:NO];
    [_recentsCell setSelected:NO];
    [_uploadCell setSelected:NO];
    [_offlineCell setSelected:NO];
    [_sharedCell setSelected:NO];
    [_publicCell setSelected:NO];
    [_settingsCell setSelected:NO];
    [_foldersCell setSelected:NO];
    switch (index) {
        case kHomeFoldersCellIndex:
            [_foldersCell setSelected:YES];
            break;
        case kHomeFavoritesCellIndex:
            [_favoritesCell setSelected:YES];
            break;
        case kHomeRecentsCellIndex:
            [_recentsCell setSelected:YES];
            break;
        case kHomeUploadCellIndex:
            [_uploadCell setSelected:YES];
            break;
        case kHomeOfflineCellIndex:
            [_offlineCell setSelected:YES];
            break;
        case kHomeSharedCellIndex:
            [_sharedCell setSelected:YES];
            break;
        case kHomePublicCellIndex:
            [_publicCell setSelected:YES];
            break;
        case kHomeSettingsCellIndex:
            [_settingsCell setSelected:YES];
            break;
        default:
            [_foldersCell setSelected:YES];
            break;
    }
}


#pragma mark -
#pragma mark TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (kHomeCellCount);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kHomeSettingsCellIndex) {
            return MAX(75.0, (tableView.frame.size.height - (55 * kHomeSettingsCellIndex)));
    }
    return (55);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kHomeFoldersCellIndex:
            return (_foldersCell);
        case kHomeFavoritesCellIndex:
            return (_favoritesCell);
        case kHomeRecentsCellIndex:
            return (_recentsCell);
        case kHomeUploadCellIndex:
            return (_uploadCell);
        case kHomeOfflineCellIndex:
            return (_offlineCell);
        case kHomeSharedCellIndex:
            return (_sharedCell);
        case kHomePublicCellIndex:
            return (_publicCell);
        case kHomeSettingsCellIndex:
            return (_settingsCell);
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *login = [[_navController viewControllers] first];
    switch (indexPath.row) {
        case kHomeFoldersCellIndex: {
            UIViewController *c = [[WRootViewController alloc] initWithItem:nil];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
        case kHomeFavoritesCellIndex: {
            UIViewController *c = [[WFavoritesViewController alloc] initWithItem:nil];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
        case kHomeRecentsCellIndex: {
            UIViewController *c = [[WRecentsViewController alloc] initWithItem:nil];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
        case kHomeUploadCellIndex: {
            UIViewController *c = [[WUploadingViewController alloc] initWithItem:nil];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
        case kHomeOfflineCellIndex: {
            UIViewController *c = [[WOfflineViewController alloc] initWithItem:nil];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
        case kHomeSharedCellIndex: {
            UIViewController *c = [[WSharedViewController alloc] initWithItem:nil];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
        case kHomePublicCellIndex: {
            UIViewController *c = [[WPublicViewController alloc] initWithItem:nil];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
        case kHomeSettingsCellIndex: {
            [WUser logout];
            
            [self.navController swipeLeft];
            [_navController setViewControllers:@[login] animated:NO];
            break;
        }
        default:
            break;
    }
}

@end

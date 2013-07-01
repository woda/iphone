//
//  WHomeViewController.m
//  Woda
//
//  Created by Théo LUBERT on 11/21/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WHomeViewController.h"
#import "WDirectoryViewController.h"
#import "NSManagedObjectContext-EasyFetch.h"
#import "NSArray+Shortcuts.h"
#import "WUser.h"

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
            UIViewController *c = [[WDirectoryViewController alloc] initWithItem:nil];
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

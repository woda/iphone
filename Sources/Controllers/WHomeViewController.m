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
    NSManagedObjectContext *context = [NSManagedObjectContext shared:nil];
    
    [_versionLabel setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    [_folderLabel setText:NSLocal(@"FolderLabel")];
    [_folderDetailsLabel setText:[NSString stringWithFormat:@"%@ %.2f / %.2fGB", NSLocal(@"FolderDetailsLabel"), 18.54, 30.0]];
    
    [_starredLabel setText:NSLocal(@"StarredLabel")];
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    [req setPredicate:[NSPredicate predicateWithFormat:@"starred == YES"]];
    int n = [context countForFetchRequest:req error:nil];
    if (n <= 0) {
        [_starredDetailsLabel setText:NSLocal(@"NoDataLabel")];
    } else if (n == 1) {
        [_starredDetailsLabel setText:[NSString stringWithFormat:@"%d %@", n, NSLocal(@"File")]];
    } else {
        [_starredDetailsLabel setText:[NSString stringWithFormat:@"%d %@", n, NSLocal(@"Files")]];
    }
    
    [_recentLabel setText:NSLocal(@"RecentLabel")];
    req = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    [req setPredicate:[NSPredicate predicateWithFormat:@"isDirectory == NO && openedAt != nil"]];
    n = [context countForFetchRequest:req error:nil];
    if (n <= 0) {
        [_recentDetailsLabel setText:NSLocal(@"NoDataLabel")];
    } else if (n == 1) {
        [_recentDetailsLabel setText:[NSString stringWithFormat:@"%d %@", n, NSLocal(@"File")]];
    } else {
        [_recentDetailsLabel setText:[NSString stringWithFormat:@"%d %@", n, NSLocal(@"Files")]];
    }
    
    [_offlineLabel setText:NSLocal(@"OfflineLabel")];
    [_offlineDetailsLabel setText:NSLocal(@"OfflineDetailsLabel")];
    
    if ([[WUser current] status] == Connected) {
        [_accountLabel setText:NSLocal(@"AccountLabel")];
        [_accountDetailsLabel setText:[NSLocal(@"AccountDetailsLabel") stringByAppendingString:[[WUser current] login]]];
        
        [_logoutLabel setText:NSLocal(@"LogoutLabel")];
    }
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kHomeFoldersCellIndex:
            return (_foldersCell);
        case kHomeStarredCellIndex:
            return (_starredCell);
        case kHomeRecentCellIndex:
            return (_recentCell);
        case kHomeOfflineCellIndex:
            return (_offlineCell);
        case kHomeBlankCellIndex:
            return (_blankCell);
        case kHomeLogoutCellIndex:
            return (_logoutCell);
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *login = [[_navController viewControllers] first];
    switch (indexPath.row) {
        case kHomeFoldersCellIndex: {
            UIViewController *c = [[WDirectoryViewController alloc] initWithItem:nil];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
        case kHomeStarredCellIndex: {
            WFolderViewController *c = [[WFolderViewController alloc] init];
            [c setPredicate:[NSPredicate predicateWithFormat:@"starred == YES"]];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
        case kHomeRecentCellIndex: {
            WFolderViewController *c = [[WFolderViewController alloc] init];
            [c setPredicate:[NSPredicate predicateWithFormat:@"isDirectory == NO && openedAt != nil"]];
            [_navController setViewControllers:@[login, c] animated:NO];
            break;
        }
//        case kHomeOfflineCellIndex: {
//            UIViewController *c = [[WFolderViewController alloc] init];
//            [self.navigationController pushViewController:c animated:YES];
//            break;
//        }
//        case kHomeBlankCellIndex: {
//            // Do nothing
//        }
        case kHomeLogoutCellIndex: {
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

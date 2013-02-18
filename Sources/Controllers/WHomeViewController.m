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

@interface WHomeViewController ()

@end

@implementation WHomeViewController


#pragma mark -
#pragma mark Initialization methods

- (id)init {
    self = [super initWithNibName:[self xibFullName:@"WHomeView"] bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabels) name:kFileUpdated object:nil];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    [self updateLabels];
}


#pragma mark -
#pragma mark TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (kCellCount);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kFoldersCellIndex:
            return (_foldersCell);
        case kStarredCellIndex:
            return (_starredCell);
        case kRecentCellIndex:
            return (_recentCell);
        case kOfflineCellIndex:
            return (_offlineCell);
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case kFoldersCellIndex: {
            UIViewController *c = [[WDirectoryViewController alloc] initWithItem:nil];
            [_navController setViewControllers:@[c] animated:NO];
            break;
        }
        case kStarredCellIndex: {
            WFolderViewController *c = [[WFolderViewController alloc] init];
            [c setPredicate:[NSPredicate predicateWithFormat:@"starred == YES"]];
            [_navController setViewControllers:@[c] animated:YES];
            break;
        }
        case kRecentCellIndex: {
            WFolderViewController *c = [[WFolderViewController alloc] init];
            [c setPredicate:[NSPredicate predicateWithFormat:@"isDirectory == NO && openedAt != nil"]];
            [_navController setViewControllers:@[c] animated:NO];
            break;
        }
//        case kOfflineCellIndex: {
//            UIViewController *c = [[WFolderViewController alloc] init];
//            [self.navigationController pushViewController:c animated:YES];
//            break;
//        }
        default:
            break;
    }
}

@end

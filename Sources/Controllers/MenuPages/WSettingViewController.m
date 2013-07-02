//
//  WSettingViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WSettingViewController.h"
#import "WRequest.h"
#import "WUser.h"

@interface WSettingViewController ()

@end

@implementation WSettingViewController


#pragma mark -
#pragma mark Initialization methods

- (id)init {
    self = [super initWithNibName:[self xibFullName:@"WSettingsView"] bundle:nil];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIView *bg = [[UIView alloc] initWithFrame:(CGRect) {
        .origin = (CGPoint) {
            .x = 0,
            .y = -3000
        },
        .size = (CGSize) {
            .width = self.view.frame.size.width,
            .height = 3000
        }
    }];
    [bg setBackgroundColor:[UIColor colorWithRed:(30/255.0) green:(33.0/255.0) blue:(40.0/255.0) alpha:1.0]];
    [self.tableView insertSubview:bg atIndex:0];
}

- (double)appSize {
    NSFileManager *_manager = [NSFileManager defaultManager];
    NSArray *_documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentsDirectory = [_documentPaths objectAtIndex:0];
    NSArray *_documentsFileList;
    NSEnumerator *_documentsEnumerator;
    NSString *_documentFilePath;
    double _documentsFolderSize = 0;
    
    NSError *error = nil;
    _documentsFileList = [_manager subpathsAtPath:_documentsDirectory];
    _documentsEnumerator = [_documentsFileList objectEnumerator];
    while (_documentFilePath = [_documentsEnumerator nextObject]) {
        NSDictionary *_documentFileAttributes = [_manager attributesOfItemAtPath:[_documentsDirectory stringByAppendingPathComponent:_documentFilePath] error:&error];
        if (error) {
            DDLogError(@"Failure occurred while computing app size: %@", [error localizedDescription]);
            return (-1);
        }
        _documentsFolderSize += [[_documentFileAttributes objectForKey:NSFileSize] doubleValue];
    }
    
    return _documentsFolderSize;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Settings";
    self.homeCellIndex = kHomeSettingsCellIndex;
    
    [self.serverLabel setText:[[[WRequest client] baseURL] relativeString]];
    [self.nameLabel setText:[[[[WUser current] firstName] capitalizedString] stringByAppendingFormat:@" %@", [[[WUser current] lastName] capitalizedString]]];
    [self.emailLabel setText:[[WUser current] email]];
    [self.versionLabel setText:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    double appSize = [self appSize];
    NSString *text = @"Unknown memory use";
    if (appSize > (1024.0*1024.0*1024.0)) {
        text = [NSString stringWithFormat:@"%.1f GB used", (appSize / (1024.0*1024.0*1024.0))];
    } else if (appSize > (1024.0*1024.0)) {
        text = [NSString stringWithFormat:@"%.1f MB used", (appSize / (1024.0*1024.0))];
    } else if (appSize > 1024.0) {
        text = [NSString stringWithFormat:@"%.1f kB used", (appSize / 1024.0)];
    } else if (appSize >= 0) {
        text = [NSString stringWithFormat:@"%.1f Bytes used", appSize];
    }
    [self.memoryLabel setText:text];
}


#pragma mark -
#pragma mark TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (kSettingCellCount);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kSettingHelpCellIndex:
            return (_helpCell);
        case kSettingFeedbackCellIndex:
            return (_feedbackCell);
        case kSettingLegalNoticeCellIndex:
            return (_noticeCell);
        case kSettingLogoutIndex:
            return (_logoutCell);
            
        default:
            return (_helpCell);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case kSettingHelpCellIndex:
            break;
        case kSettingFeedbackCellIndex:
            break;
        case kSettingLegalNoticeCellIndex:
            break;
        case kSettingLogoutIndex: {
            [WUser logout];
            
            WNavigationController *nav = (WNavigationController *)self.navigationController;
            UIViewController *login = [[nav viewControllers] first];
            [nav swipeLeft];
            [self performBlock:^{
                [nav setViewControllers:@[login] animated:YES];
            } afterDelay:0.3];
            break;
        }
            
        default:
            break;
    }
}

@end

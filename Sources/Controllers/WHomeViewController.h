//
//  WHomeViewController.h
//  Woda
//
//  Created by Théo LUBERT on 11/21/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNavigationController.h"

enum kCellIndexes {
    kFoldersCellIndex = 0,
    kStarredCellIndex,
    kRecentCellIndex,
    kOfflineCellIndex,
    kBlankCellIndex,
    kAccountCellIndex,
    kLogoutCellIndex,
    kCellCount
};

@interface WHomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) WNavigationController     *navController;

@property (nonatomic, retain) IBOutlet UITableView      *tableView;

@property (nonatomic, retain) IBOutlet UILabel          *versionLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell  *foldersCell;
@property (nonatomic, retain) IBOutlet UILabel          *folderLabel;
@property (nonatomic, retain) IBOutlet UILabel          *folderDetailsLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell  *starredCell;
@property (nonatomic, retain) IBOutlet UILabel          *starredLabel;
@property (nonatomic, retain) IBOutlet UILabel          *starredDetailsLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell  *recentCell;
@property (nonatomic, retain) IBOutlet UILabel          *recentLabel;
@property (nonatomic, retain) IBOutlet UILabel          *recentDetailsLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell  *offlineCell;
@property (nonatomic, retain) IBOutlet UILabel          *offlineLabel;
@property (nonatomic, retain) IBOutlet UILabel          *offlineDetailsLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell  *blankCell;

@property (nonatomic, retain) IBOutlet UITableViewCell  *accountCell;
@property (nonatomic, retain) IBOutlet UILabel          *accountLabel;
@property (nonatomic, retain) IBOutlet UILabel          *accountDetailsLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell  *logoutCell;
@property (nonatomic, retain) IBOutlet UILabel          *logoutLabel;

@end

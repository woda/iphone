//
//  WSettingViewController.h
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WMenuPageViewController.h"

typedef enum kSettingCellIndexes {
    kSettingHelpCellIndex = 0,
    kSettingFeedbackCellIndex,
    kSettingLegalNoticeCellIndex,
    kSettingCacheIndex,
    kSettingLogoutIndex,
    kSettingCellCount
}   SettingCellIndex;

@interface WSettingViewController : WMenuPageViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView      *tableView;

@property (nonatomic, retain) IBOutlet UILabel          *serverLabel;
@property (nonatomic, retain) IBOutlet UILabel          *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel          *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel          *memoryLabel;
@property (nonatomic, retain) IBOutlet UILabel          *versionLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell  *helpCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *feedbackCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *noticeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *cacheCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *logoutCell;

@end

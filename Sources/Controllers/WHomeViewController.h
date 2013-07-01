//
//  WHomeViewController.h
//  Woda
//
//  Created by Théo LUBERT on 11/21/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNavigationController.h"

enum kHomeCellIndexes {
    kHomeFoldersCellIndex = 0,
    kHomeFavoritesCellIndex,
    kHomeRecentsCellIndex,
    kHomeUploadCellIndex,
    kHomeOfflineCellIndex,
    kHomeSharedCellIndex,
    kHomePublicCellIndex,
    kHomeSettingsCellIndex,
    kHomeCellCount
};

@interface WHomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) WNavigationController     *navController;

@property (nonatomic, retain) IBOutlet UITableView      *tableView;

@property (nonatomic, retain) IBOutlet UITableViewCell  *foldersCell;

@property (nonatomic, retain) IBOutlet UITableViewCell  *favoritesCell;

@property (nonatomic, retain) IBOutlet UITableViewCell  *recentsCell;

@property (nonatomic, retain) IBOutlet UITableViewCell  *uploadCell;

@property (nonatomic, retain) IBOutlet UITableViewCell  *offlineCell;

@property (nonatomic, retain) IBOutlet UITableViewCell  *sharedCell;

@property (nonatomic, retain) IBOutlet UITableViewCell  *publicCell;

@property (nonatomic, retain) IBOutlet UITableViewCell  *settingsCell;

@end

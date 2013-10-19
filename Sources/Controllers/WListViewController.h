//
//  WListViewController.h
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WMenuPageViewController.h"
#import "WRequest+List.h"

@interface WListViewController : WMenuPageViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView      *tableView;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *loading;

@property (nonatomic, retain) IBOutlet UITableViewCell  *foldersHeaderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *filesHeaderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *noFileCell;
@property (nonatomic, retain) IBOutlet UILabel          *noFileLabel;

@property (nonatomic, retain) IBOutlet UIView           *footerView;
@property (nonatomic, retain) IBOutlet UILabel          *countLabel;
@property (nonatomic, retain) IBOutlet UILabel          *updatedLabel;

@property (nonatomic, retain) NSDictionary    *data;

- (void)openFolder:(NSDictionary *)folder;

@end

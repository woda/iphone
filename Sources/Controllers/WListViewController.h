//
//  WListViewController.h
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WImagePreviewViewController.h"
#import "WHomeViewController.h"
#import "WRequest+List.h"

@interface WListViewController : UITableViewController <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableViewCell  *foldersHeaderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *filesHeaderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *noFileCell;
@property (nonatomic, retain) IBOutlet UILabel          *noFileLabel;

@property (nonatomic, retain) IBOutlet UIView           *footerView;
@property (nonatomic, retain) IBOutlet UILabel          *countLabel;
@property (nonatomic, retain) IBOutlet UILabel          *updatedLabel;


@property (assign) HomeCellIndex                        homeCellIndex;
@property (nonatomic, retain) NSDictionary              *data;
@property (nonatomic, strong) id<QLPreviewItem>         item;

- (void)openFolder:(NSDictionary *)folder;

@end

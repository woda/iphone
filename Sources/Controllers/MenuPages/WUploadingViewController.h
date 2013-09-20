//
//  WUploadingViewController.h
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WListViewController.h"
#import "WUploadCollectionHeader.h"
#import "WUploadCollectionFooter.h"

@interface WUploadingViewController : WMenuPageViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *loading;

@property (nonatomic, retain) IBOutlet UITableViewCell  *foldersHeaderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *filesHeaderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *noFileCell;

@property (nonatomic, retain) WUploadCollectionHeader   *headerView;
@property (nonatomic, retain) WUploadCollectionFooter   *footerView;

@property (nonatomic, retain) NSMutableArray            *data;

@end

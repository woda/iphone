//
//  WUploadingViewController.h
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WListViewController.h"

@interface WUploadingViewController : WMenuPageViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *loading;

@property (nonatomic, retain) IBOutlet UITableViewCell  *foldersHeaderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *filesHeaderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell  *noFileCell;

@property (nonatomic, retain) IBOutlet UICollectionReusableView *headerView;
@property (nonatomic, retain) IBOutlet UIImageView      *stateImageView;
@property (nonatomic, retain) IBOutlet UILabel          *stateLabel;
@property (nonatomic, retain) IBOutlet UIView           *progressBarView;
@property (nonatomic, retain) IBOutlet UIView           *progressView;
@property (nonatomic, retain) IBOutlet UILabel          *firstSectionLabel;

@property (nonatomic, retain) IBOutlet UICollectionReusableView *footerView;
@property (nonatomic, retain) IBOutlet UILabel          *countLabel;
@property (nonatomic, retain) IBOutlet UILabel          *updatedLabel;

@property (nonatomic, retain) NSMutableArray            *data;

@end

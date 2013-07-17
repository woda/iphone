//
//  WUploadingViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUploadingViewController.h"
#import "WUploadManager.h"
#import "WUploadFileCell.h"


@interface WUploadingViewController ()

@end

@implementation WUploadingViewController


#pragma mark -
#pragma mark Initialization methods

- (id)init {
    self = [super initWithNibName:[self xibFullName:@"WUploadListView"] bundle:nil];
    if (self) {
        self.data = nil;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"UploadsPageTitle");
    self.homeCellIndex = kHomeUploadCellIndex;
    
    [self reloadData];
}


#pragma mark - Data related methods

- (void)reloadData {
    self.data = [NSMutableArray array];
    [self.data addObject:[NSMutableArray array]];
    [self.data[0] addObjectsFromArray:[[[WUploadManager uploadList] allValues] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *info1, NSDictionary *info2) {
        return ([info2[kUploadDate] compare:info1[kUploadDate]]);
    }]];
}


#pragma mark - Collection related methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (self.data.count);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (((NSArray *)self.data[section]).count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView registerClass:[WUploadFileCell class] forCellWithReuseIdentifier:[WUploadFileCell reuseIdentifier]];
    UICollectionViewCell *cell = nil;// [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [UIViewController collectionCellOfClass:[WUploadFileCell class]];
    }
    [(WUploadFileCell *)cell setInfo:self.data[indexPath.section][indexPath.row]];
    return (cell);
}

@end

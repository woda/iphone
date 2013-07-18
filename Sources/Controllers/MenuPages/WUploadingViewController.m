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
#import "WUploadSectionHeader.h"


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

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.collectionView registerClass:[WUploadFileCell class] forCellWithReuseIdentifier:[WUploadFileCell reuseIdentifier]];
//    [self.collectionView registerClass:[WUploadSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[WUploadSectionHeader reuseIdentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[UIViewController xibFullName:[WUploadFileCell xibName]] bundle:nil] forCellWithReuseIdentifier:[WUploadFileCell reuseIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[UIViewController xibFullName:[WUploadSectionHeader xibName]] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[WUploadSectionHeader reuseIdentifier]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"UploadsPageTitle");
    self.homeCellIndex = kHomeUploadCellIndex;
    
    [self reloadData];
}


#pragma mark - Data related methods

- (NSArray *)filesForPeriod:(NSString *)period inFiles:(NSMutableArray *)files {
    NSMutableArray *today = [[NSMutableArray alloc] init];
    NSArray *array = [files copy];
    for (NSDictionary *file in array) {
        if ([[file[kUploadDate] toFormat:@"yyyy-MM-dd"] hasPrefix:period]) {
            [today addObject:file];
            [files removeObject:file];
        }
    }
    return (today);
}

- (void)reloadData {
    NSMutableArray *files = [[[[WUploadManager uploadList] allValues] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *info1, NSDictionary *info2) {
        return ([info2[kUploadDate] compare:info1[kUploadDate]]);
    }] mutableCopy];
    
    [self.countLabel setText:[NSString stringWithFormat:@"%d files", files.count]];
    if (files.count > 0) {
        [self.updatedLabel setText:[NSString stringWithFormat:@"Last updated: %@", [files[0][kUploadDate] toFormat:@"MM/dd/yyyy' at 'hh:mm a"]]];
    } else {
        [self.updatedLabel setText:@""];
    }
    
    
    self.data = [NSMutableArray array];
    
    // Today
    NSString *period = [[NSDate date] toFormat:@"yyyy-MM-dd"];
    NSArray *filesInPeriod = [self filesForPeriod:period inFiles:files];
    if (filesInPeriod.count > 0) {
        [self.data addObject:@{@"period": period, @"info": filesInPeriod}];
    }
    
    // By month
    while (files.count > 0) {
        period = [(NSDate *)files[0][kUploadDate] toFormat:@"yyyy-MM"];
        filesInPeriod = [self filesForPeriod:period inFiles:files];
        [self.data addObject:@{@"period": period, @"info": filesInPeriod}];
    }
}


#pragma mark - Collection related methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (self.data.count);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (((NSArray *)self.data[section][@"info"]).count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[WUploadFileCell reuseIdentifier] forIndexPath:indexPath];
    [(WUploadFileCell *)cell setInfo:self.data[indexPath.section][@"info"][indexPath.row]];
    return (cell);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            [self.firstSectionLabel setText:[WUploadSectionHeader sectionTitleForPeriod:self.data[indexPath.section][@"period"]]];
            return (self.headerView);
        }
        
        UICollectionReusableView *cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[WUploadSectionHeader reuseIdentifier] forIndexPath:indexPath];
        [(WUploadSectionHeader *)cell setPeriod:self.data[indexPath.section][@"period"]];
        return (cell);
    } else if (([kind isEqualToString:UICollectionElementKindSectionFooter]) && (indexPath.section == (self.data.count - 1))) {
        return (self.footerView);
    }
    return (nil);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView.frame.size;
    }
    return  CGSizeMake(320, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == self.data.count - 1) {
        return self.footerView.frame.size;
    }
    return  CGSizeMake(320, 0);
}

@end

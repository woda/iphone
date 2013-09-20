//
//  WUploadingViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WUploadingViewController.h"
#import "WUploadManager.h"
#import "WUploadFileCell.h"
#import "WUploadSectionHeader.h"
#import "WUploadCollectionLayout.h"


@interface WUploadingViewController ()

@property NSMutableDictionary   *uploadingFiles;
@property NSInteger             status;

@end

@implementation WUploadingViewController


#pragma mark -
#pragma mark Initialization methods

- (id)init {
    self = [super initWithNibName:[self xibFullName:@"WUploadListView"] bundle:nil];
    if (self) {
        self.data = nil;
        self.uploadingFiles = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerCell:(Class<XibViewDelegate>)class {
    [self.collectionView registerNib:[UINib nibWithNibName:[UIViewController xibFullName:[class xibName]] bundle:nil] forCellWithReuseIdentifier:[class reuseIdentifier]];
}

- (void)registerReusableView:(Class<XibViewDelegate>)class forKind:(NSString *)kind {
    [self.collectionView registerNib:[UINib nibWithNibName:[UIViewController xibFullName:[class xibName]] bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:[class reuseIdentifier]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.status = -1;
    
    [self registerCell:[WUploadFileCell class]];
    [self registerReusableView:[WUploadSectionHeader class] forKind:WUploadSectionHeaderKind];
    [self registerReusableView:[WUploadCollectionHeader class] forKind:WUploadCollectionHeaderKind];
    [self registerReusableView:[WUploadCollectionFooter class] forKind:WUploadCollectionFooterKind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"UploadsPageTitle");
    self.homeCellIndex = kHomeUploadCellIndex;
    
    [self reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    self.status = -1;
    [self infoChanged:nil];
}


#pragma mark - Data related methods

- (void)updateStateView {
    self.status = [self.headerView updateStateView:self.status ofCollectionView:self.collectionView];
}

- (void)upToDate {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.uploadingFiles removeAllObjects];
    
    // display 'up to date'
    NSLog(@"Up to date");
    
    [self.headerView upToDate];
    
    [self updateStateView];
}

- (void)uploading:(NSInteger)count completed:(NSInteger)completed progress:(NSInteger)progress {
    // display progress bar
    NSLog(@"Uploading %d / %d (%d%%)", completed, self.uploadingFiles.count, progress);
    
    [self.headerView uploading:count completed:completed progress:progress];
    
    [self updateStateView];
}

- (void)infoChanged:(NSNotification *)notif {
    if (notif) {
        NSDictionary *file = notif.userInfo;
        self.uploadingFiles[file[kUploadFileName]] = file;
//        [self reloadData];
    }// else {
        Boolean allUploaded = YES;
        NSInteger uploaded = 0;
        NSInteger progress = 0;
        for (NSDictionary *file in [self.uploadingFiles allValues]) {
            allUploaded &= ![file[kUploadNeedsUpload] boolValue];
            uploaded += ([file[kUploadNeedsUpload] boolValue] ? 0 : 1);
            progress += [file[kUploadProgress] integerValue];
        }
        if (allUploaded) {
            [self upToDate];
        } else {
            progress /= self.uploadingFiles.count;
            [self uploading:self.uploadingFiles.count completed:uploaded progress:progress];
        }
    //}
}

- (NSArray *)filesForPeriod:(NSString *)period inFiles:(NSMutableArray *)files {
    NSMutableArray *today = [[NSMutableArray alloc] init];
    NSArray *array = [files copy];
    for (NSDictionary *file in array) {
        if ([[file[kUploadDate] toFormat:@"yyyy-MM-dd"] hasPrefix:period]) {
            [today addObject:file];
            [files removeObject:file];
            
            if ([file[kUploadNeedsUpload] boolValue]) {
                self.uploadingFiles[file[kUploadFileName]] = file;
                NSString *notifName = file[kUploadNotificationName];
                if (notifName) {
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoChanged:) name:notifName object:nil];
                }
            }
        }
    }
    return (today);
}


- (void)reloadData {
    NSMutableArray *files = [[[[WUploadManager uploadList] allValues] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *info1, NSDictionary *info2) {
        return ([info2[kUploadDate] compare:info1[kUploadDate]]);
    }] mutableCopy];
    
    self.data = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    
    [self.footerView update:self.data];
    [self infoChanged:nil];
}


#pragma mark - Collection related methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MAX(1, self.data.count);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.data.count > 0) {
        return (((NSArray *)self.data[section][@"info"]).count);
    }
    return (0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WUploadFileCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[WUploadFileCell reuseIdentifier] forIndexPath:indexPath];
    [cell prepareForReuse];
    [cell setInfo:self.data[indexPath.section][@"info"][indexPath.row]];
    return (cell);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *cell = nil;
    if ([kind isEqualToString:WUploadCollectionHeaderKind]) {
        cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[WUploadCollectionHeader reuseIdentifier] forIndexPath:indexPath];
        self.headerView = (WUploadCollectionHeader *)cell;
        [self infoChanged:nil];
    } else if ([kind isEqualToString:WUploadCollectionFooterKind]) {
        cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[WUploadCollectionFooter reuseIdentifier] forIndexPath:indexPath];
        self.footerView = (WUploadCollectionFooter *)cell;
        [self.footerView update:self.data];
    } else if ([kind isEqualToString:WUploadSectionHeaderKind]) {
        cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[WUploadSectionHeader reuseIdentifier] forIndexPath:indexPath];
        [(WUploadSectionHeader *)cell setPeriod:self.data[indexPath.section][@"period"]];
    }
    return (cell);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [WUploadCollectionHeader sizeForStatus:self.status];
    }
    return  CGSizeMake(320, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == self.data.count - 1) {
        return [WUploadCollectionFooter size];
    }
    return  CGSizeMake(320, 0);
}

@end

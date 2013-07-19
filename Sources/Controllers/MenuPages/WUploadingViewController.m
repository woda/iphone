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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.status = -1;
    
    [self.collectionView registerNib:[UINib nibWithNibName:[UIViewController xibFullName:[WUploadFileCell xibName]] bundle:nil] forCellWithReuseIdentifier:[WUploadFileCell reuseIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[UIViewController xibFullName:[WUploadSectionHeader xibName]] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[WUploadSectionHeader reuseIdentifier]];
    
    [self.progressBarView.layer setCornerRadius:1];
    [self.progressView.layer setCornerRadius:1];
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
    if ((self.status == -1) || (self.status ^ self.progressBarView.hidden)) {
        CGSize textSize = [self.stateLabel.text sizeWithFont:self.stateLabel.font constrainedToSize:CGSizeMake(200, 20)];
        [self.stateLabel setFrame:(CGRect) {
            .origin = (CGPoint) {
                .x = (self.stateLabel.superview.frame.size.width - textSize.width) / 2,
                .y = 3
            },
            .size = textSize
        }];
        
        [self.stateImageView setFrame:(CGRect) {
            .origin = (CGPoint) {
                .x = self.stateLabel.frame.origin.x - textSize.height - 7,
                .y = self.stateLabel.frame.origin.y
            },
            .size = (CGSize) {
                .width = textSize.height,
                .height = textSize.height
            }
        }];
        
        [self.progressBarView setFrame:(CGRect) {
            .origin = (CGPoint) {
                .x = (self.progressBarView.superview.frame.size.width - self.progressBarView.frame.size.width) / 2,
                .y = self.stateLabel.frame.origin.y + self.stateLabel.frame.size.height + 4
            },
            .size = self.progressBarView.frame.size
        }];
        
        NSInteger h = self.headerView.frame.size.height;
        [self.headerView setFrame:(CGRect) {
            .origin = self.headerView.frame.origin,
            .size = (CGSize) {
                .width = self.headerView.frame.size.width,
                .height = ((self.progressBarView.hidden) ? 47 : 60)
            }
        }];
        if (h != self.headerView.frame.size.height) {
            [self.collectionView reloadData];
        }
        
        self.status = self.progressBarView.hidden;
    }
}

- (void)upToDate {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.uploadingFiles removeAllObjects];
    
    // display 'up to date'
    NSLog(@"Up to date");
    
    [self.stateLabel setText:NSLocal(@"UpToDate")];
    [self.stateLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:14]];
    [self.stateImageView setImage:[UIImage imageNamed:@"upload_grey_check.png"]];
    [self.stateImageView.layer removeAnimationForKey:@"rotationAnimation"];
    [self.progressBarView setHidden:YES];
    
    [self updateStateView];
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat; {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    if ([view.layer animationForKey:@"rotationAnimation"] == nil) {
        [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)uploading:(NSInteger)count completed:(NSInteger)completed progress:(NSInteger)progress {
    // display progress bar
    NSLog(@"Uploading %d / %d (%d%%)", completed, self.uploadingFiles.count, progress);
    
    [self.stateLabel setText:[NSString stringWithFormat:@"%d / %d", completed, self.uploadingFiles.count]];
    [self.stateLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18]];
    [self.stateImageView setImage:[UIImage imageNamed:@"upload_green_refresh.png"]];
    [self runSpinAnimationOnView:self.stateImageView duration:1 rotations:1 repeat:10000000000];
    [self.progressBarView setHidden:NO];
    
    [self updateStateView];
    
    [self.progressView setFrame:(CGRect) {
        .origin = (CGPoint) {
            .x = 1,
            .y = 1
        },
        .size = (CGSize) {
            .width = (self.progressBarView.frame.size.width - 2) * progress / 100,
            .height = (self.progressBarView.frame.size.height - 2)
        }
    }];
}

- (void)infoChanged:(NSNotification *)notif {
    if (notif) {
        NSDictionary *file = notif.userInfo;
        self.uploadingFiles[file[kUploadFileName]] = file;
        [self reloadData];
    } else {
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
    }
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
    
    [self.countLabel setText:[NSString stringWithFormat:@"%d files", files.count]];
    if (files.count > 0) {
        [self.updatedLabel setText:[NSString stringWithFormat:@"Last updated: %@", [files[0][kUploadDate] toFormat:@"MM/dd/yyyy' at 'hh:mm a"]]];
    } else {
        [self.updatedLabel setText:@""];
    }
    
    
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
    
    [self infoChanged:nil];
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

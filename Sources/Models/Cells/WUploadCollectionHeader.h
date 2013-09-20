//
//  WUploadCollectionHeader.h
//  Woda
//
//  Created by Théo LUBERT on 9/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUploadCollectionHeader : UICollectionReusableView <XibViewDelegate>

@property (nonatomic, retain) IBOutlet UIImageView      *stateImageView;
@property (nonatomic, retain) IBOutlet UILabel          *stateLabel;
@property (nonatomic, retain) IBOutlet UIView           *progressBarView;
@property (nonatomic, retain) IBOutlet UIView           *progressView;

+ (CGSize)sizeForStatus:(NSInteger)status;

- (NSInteger)updateStateView:(NSInteger)status ofCollectionView:(UICollectionView *)collectionView;
- (void)upToDate;
- (void)uploading:(NSInteger)count completed:(NSInteger)completed progress:(NSInteger)progress;

@end

//
//  WUploadCollectionLayout.h
//  Woda
//
//  Created by Théo LUBERT on 9/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *WUploadCollectionHeaderKind;
UIKIT_EXTERN NSString *WUploadCollectionFooterKind;
UIKIT_EXTERN NSString *WUploadSectionHeaderKind;


@interface WUploadCollectionLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat collectionHeaderHeight;
@property (nonatomic) CGFloat sectionHeaderHeight;
@property (nonatomic) CGFloat collectionFooterHeight;

@end

//
//  WUploadCollectionLayout.m
//  Woda
//
//  Created by Théo LUBERT on 9/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUploadCollectionLayout.h"

NSString *WUploadPictureCellKind = @"WUploadPictureCellKind";
NSString *WUploadCollectionHeaderKind = @"WUploadCollectionHeaderKind";
NSString *WUploadCollectionFooterKind = @"WUploadCollectionFooterKind";
NSString *WUploadSectionHeaderKind = @"WUploadSectionHeaderKind";


@interface WUploadCollectionLayout ()

@property (nonatomic, strong) NSDictionary      *layoutInfo;
@property (nonatomic, strong) NSMutableArray    *sectionOffsets;

@end

@implementation WUploadCollectionLayout

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.itemInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0);
    self.itemSize = CGSizeMake(97.0, 97.0);
    self.interItemSpacingY = 5.0;
    self.numberOfColumns = 3;
    self.collectionHeaderHeight = 40.0;
    self.collectionFooterHeight = 44.0;
    self.sectionHeaderHeight = 20.0;
}

- (void)setCollectionHeaderHeight:(CGFloat)collectionHeaderHeight {
    if (_collectionHeaderHeight != collectionHeaderHeight) {
        _collectionHeaderHeight = collectionHeaderHeight;
        [self invalidateLayout];
    }
}

- (void)setCollectionFooterHeight:(CGFloat)collectionFooterHeight {
    if (_collectionFooterHeight != collectionFooterHeight) {
        _collectionFooterHeight = collectionFooterHeight;
        [self invalidateLayout];
    }
}

- (void)setSectionHeaderHeight:(CGFloat)sectionHeaderHeight {
    if (_sectionHeaderHeight != sectionHeaderHeight) {
        _sectionHeaderHeight = sectionHeaderHeight;
        [self invalidateLayout];
    }
}


#pragma mark - Private

- (CGRect)frameForPictureCellAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger offset = 66 + self.collectionHeaderHeight;
    if (indexPath.section > 0) {
        offset = [self.sectionOffsets[indexPath.section - 1] integerValue];
    }
    NSInteger row = indexPath.item / self.numberOfColumns;
    NSInteger column = indexPath.item % self.numberOfColumns;
    
    CGFloat spacingX = self.collectionView.bounds.size.width -
    self.itemInsets.left -
    self.itemInsets.right -
    (self.numberOfColumns * self.itemSize.width);
    
    if (self.numberOfColumns > 1) spacingX = spacingX / (self.numberOfColumns - 1);
    
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
    
    CGFloat originY = floor(self.itemInsets.top +
                            offset + self.sectionHeaderHeight +
                            (self.itemSize.height + self.interItemSpacingY) * row);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CGRect)frameForCollectionHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = CGRectMake(0, 66, 320, self.collectionHeaderHeight);
    
    return frame;
}

- (CGRect)frameForCollectionFooterAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger offset = 66 + self.collectionHeaderHeight;
    if (self.sectionOffsets.count > 0) {
        offset = [self.sectionOffsets.lastObject integerValue];
    }
    CGRect frame = CGRectMake(0, offset, 320, self.collectionFooterHeight);
    
    return frame;
}

- (CGRect)frameForSectionHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger offset = 66 + self.collectionHeaderHeight;
    if (indexPath.section > 0) {
        offset = [self.sectionOffsets[indexPath.section - 1] integerValue];
    }
    CGRect frame = CGRectMake(0, offset, 320, self.sectionHeaderHeight);
    
    return frame;
}


#pragma mark - Layout

- (void)prepareLayout {
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *collectionHeaderLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *collectionFooterLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *sectionHeaderLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    self.sectionOffsets = [[NSMutableArray alloc] init];
    
    UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:WUploadCollectionHeaderKind withIndexPath:indexPath];
    titleAttributes.frame = [self frameForCollectionHeaderAtIndexPath:indexPath];
    collectionHeaderLayoutInfo[indexPath] = titleAttributes;
    
    NSInteger offset = 0;
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForPictureCellAtIndexPath:indexPath];
            cellLayoutInfo[indexPath] = itemAttributes;
            
            offset = itemAttributes.frame.origin.y + itemAttributes.frame.size.height + self.itemInsets.bottom;
            
            if (indexPath.item == 0) {
                UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:WUploadSectionHeaderKind withIndexPath:indexPath];
                titleAttributes.frame = [self frameForSectionHeaderAtIndexPath:indexPath];
                sectionHeaderLayoutInfo[indexPath] = titleAttributes;
            }
        }
        self.sectionOffsets[section] = [NSNumber numberWithInteger:offset];
    }
    
    titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:WUploadCollectionFooterKind withIndexPath:indexPath];
    titleAttributes.frame = [self frameForCollectionFooterAtIndexPath:indexPath];
    collectionFooterLayoutInfo[indexPath] = titleAttributes;
    
    newLayoutInfo[WUploadPictureCellKind] = cellLayoutInfo;
    newLayoutInfo[WUploadCollectionHeaderKind] = collectionHeaderLayoutInfo;
    newLayoutInfo[WUploadCollectionFooterKind] = collectionFooterLayoutInfo;
    newLayoutInfo[WUploadSectionHeaderKind] = sectionHeaderLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInfo[WUploadPictureCellKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[kind][indexPath];
}

- (CGSize)collectionViewContentSize {
    CGFloat height = [self.sectionOffsets.lastObject integerValue] +
    self.collectionFooterHeight + self.itemInsets.bottom;
    return CGSizeMake(self.collectionView.bounds.size.width, MAX(height, self.collectionView.frame.size.height + 1));
}

@end

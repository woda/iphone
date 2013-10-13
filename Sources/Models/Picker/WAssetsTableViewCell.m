//
//  WAssetsTableViewCell.m
//  Woda
//
//  Created by Théo LUBERT on 7/26/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WAssetsTableViewCell.h"
#import "WSAssetWrapper.h"
#import "WAssetViewColumn.h"
#import "WFileCell.h"

@implementation WAssetsTableViewCell

@synthesize cellAssetViews = _cellAssetViews;

- (void)setCellAssetViews:(NSArray *)assets
{
    [self performSelector:@selector(stopObserving)];
    
    // Create new WSAssetViews
    NSMutableArray *columns = [NSMutableArray arrayWithCapacity:[assets count]];
    
    for (WSAssetWrapper *assetWrapper in assets) {
        
        WAssetViewColumn *assetViewColumn = [[WAssetViewColumn alloc] initWithImage:[UIImage imageWithCGImage:assetWrapper.asset.thumbnail]];
        assetViewColumn.column = [assets indexOfObject:assetWrapper];
        assetViewColumn.selected = assetWrapper.isSelected;
        
        NSString *fileName = [assetWrapper.asset defaultRepresentation].filename;
        [assetViewColumn setVideo:[WFileCell isFileAVideo:[fileName componentsSeparatedByString:@"."].last]];
        
        __weak __typeof__(self) weakSelf = self;
        [assetViewColumn setShouldSelectItemBlock:^BOOL(NSInteger column) {
            return [weakSelf.delegate assetsTableViewCell:weakSelf shouldSelectAssetAtColumn:column];
        }];
        
        // Observe the column's isSelected property.
        [assetViewColumn addObserver:self forKeyPath:@"isSelected" options:NSKeyValueObservingOptionNew context:NULL];
        
        [columns addObject:assetViewColumn];
    }
    
    _cellAssetViews = columns;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isMemberOfClass:[WAssetViewColumn class]]) {
        
        WAssetViewColumn *column = (WAssetViewColumn *)object;
        if ([self.delegate respondsToSelector:@selector(assetsTableViewCell:didSelectAsset:atColumn:)]) {
            
            [self.delegate assetsTableViewCell:self didSelectAsset:column.isSelected atColumn:column.column];
        }
    }
}

@end

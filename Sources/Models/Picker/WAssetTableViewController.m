//
//  WAssetTableViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/26/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WAssetTableViewController.h"
#import "WSAssetPickerState.h"
#import "WAssetsTableViewCell.h"

@interface WAssetTableViewController ()

@end

@implementation WAssetTableViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"navbar_left_white_arrow.png"] forState:UIControlStateNormal];
    [button setBounds:CGRectMake(0, 0, 21, 18)];
    [button setImageEdgeInsets:(UIEdgeInsets) {
        .top = 0,
        .left = 10,
        .bottom = 0,
        .right = 0
    }];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButton;
    
    button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"navbar_white_upload.png"] forState:UIControlStateNormal];
    [button setBounds:CGRectMake(0, 0, 30, 20)];
    [button setImageEdgeInsets:(UIEdgeInsets) {
        .top = 0,
        .left = 0,
        .bottom = 0,
        .right = 10
    }];
    [button addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.uploadButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.uploadButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = self.uploadButton;
}

- (void)assetsTableViewCell:(WSAssetsTableViewCell *)cell didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column {
    [super assetsTableViewCell:cell didSelectAsset:selected atColumn:column];
    
    [self.uploadButton setEnabled:(self.assetPickerState.selectedCount > 0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AssetCellIdentifier = @"WSAssetCell";
    WAssetsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AssetCellIdentifier];
    
    if (cell == nil) {
        
        cell = [[WAssetsTableViewCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:AssetCellIdentifier];
    } else {
        
        cell.cellAssetViews = [self assetsForIndexPath:indexPath];
    }
    cell.delegate = self;
    
    return cell;
}


#pragma mark -
#pragma mark Action methods

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

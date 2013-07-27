//
//  WAlbumTableViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/26/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WAlbumTableViewController.h"
#import "WAssetTableViewController.h"

@interface WAlbumTableViewController ()

@end

@implementation WAlbumTableViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count < 2) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"navbar_cross_big.png"] forState:UIControlStateNormal];
        [button setBounds:CGRectMake(0, 0, 30, 20)];
        [button setImageEdgeInsets:(UIEdgeInsets) {
            .top = 0,
            .left = 0,
            .bottom = 0,
            .right = 10
        }];
        [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = listButton;
    }
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WSAlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get the group from the datasource.
    ALAssetsGroup *group = [self.assetGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allAssets]]; // TODO: Make this a delegate choice.
    
    // Setup the cell.
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", [group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]];
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *group = [self.assetGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allAssets]]; // TODO: Make this a delegate choice.
    
    WAssetTableViewController *assetTableViewController = [[WAssetTableViewController alloc] initWithStyle:UITableViewStylePlain];
    assetTableViewController.assetPickerState = self.assetPickerState;
    assetTableViewController.assetsGroup = group;
    
    [self.navigationController pushViewController:assetTableViewController animated:YES];
}


#pragma mark -
#pragma mark Action methods

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end

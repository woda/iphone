//
//  WPicturePickerViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/3/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WPicturePickerViewController.h"
#import "WAlbumTableViewController.h"

@interface WPicturePickerViewController ()

@end

@implementation WPicturePickerViewController

#pragma mark - Initialization

- (id)initWithAssetsLibrary:(ALAssetsLibrary *)assetsLibrary {
    self = [super initWithAssetsLibrary:assetsLibrary];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlackOpaque;
        self.toolbar.barStyle = UIBarStyleBlackOpaque;
        
        WAlbumTableViewController *albumTableViewController = [[WAlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
        albumTableViewController.assetPickerState = [self performSelector:@selector(assetPickerState)];
        [self setViewControllers:@[albumTableViewController]];
    }
    
    return self;
}

@end

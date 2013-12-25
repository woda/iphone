//
//  WMenuPageViewController.m
//  Woda
//
//  Created by Théo LUBERT on 10/18/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSManagedObjectContext-EasyFetch.h"
#import "AFHTTPRequestOperation.h"
#import "WMenuPageViewController.h"
#import "WImagePreviewViewController.h"
#import "WCell.h"

@interface WMenuPageViewController ()

@end

@implementation WMenuPageViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Woda";
    
    if (self.navigationController.viewControllers.count <= 2) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"navbar_white_menu.png"] forState:UIControlStateNormal];
        [button setBounds:CGRectMake(0, 0, 35, 18)];
        [button setImageEdgeInsets:(UIEdgeInsets) {
            .top = 0,
            .left = 10,
            .bottom = 0,
            .right = 0
        }];
        [button addTarget:self.navigationController action:@selector(swipe) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = listButton;
    } else {
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
        UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = listButton;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [((WNavigationController *)self.navigationController).homeController setSelected:self.homeCellIndex];
}

@end

//
//  WImagePreviewViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WImagePreviewViewController.h"

@interface WImagePreviewViewController ()

@property (nonatomic, retain) UIImage   *image;

@end

@implementation WImagePreviewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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


#pragma mark - Action methods

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

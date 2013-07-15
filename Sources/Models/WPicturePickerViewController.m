//
//  WPicturePickerViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/3/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WPicturePickerViewController.h"

@interface WPicturePickerViewController ()

@end

@implementation WPicturePickerViewController


#pragma mark -
#pragma mark Initialization methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Woda";
    
    if (self.navigationController.viewControllers.count <= 2) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"navbar_cross_big.png"] forState:UIControlStateNormal];
        [button setBounds:CGRectMake(0, 0, 35, 25)];
        [button setImageEdgeInsets:(UIEdgeInsets) {
            .top = 0,
            .left = 10,
            .bottom = 0,
            .right = 0
        }];
        [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = listButton;
    }
}

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        // do nothing
    }];
}

@end

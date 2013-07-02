//
//  WFolderViewController.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WFolderViewController.h"

@interface WFolderViewController ()

@end

@implementation WFolderViewController


#pragma mark -
#pragma mark Initialization methods

- (id)initWithPath:(NSString *)path {
    self = [super initWithNibName:[self xibFullName:@"WFolderView"] bundle:nil];
    if (self) {
        _path = path;
    }
    return self;
}

- (id)initWithData:(NSDictionary *)data {
    self = [super initWithNibName:[self xibFullName:@"WFolderView"] bundle:nil];
    if (self) {
        _data = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"navbar_plus.png"] forState:UIControlStateNormal];
    [button setBounds:CGRectMake(0, 0, 30, 20)];
    [button setImageEdgeInsets:(UIEdgeInsets) {
        .top = 0,
        .left = 0,
        .bottom = 0,
        .right = 10
    }];
    [button addTarget:self action:@selector(insertNewObject:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = addButton;
}


#pragma mark -
#pragma mark Test methods

- (void)insertNewObject:(id)sender {
    // do nothing
}

@end

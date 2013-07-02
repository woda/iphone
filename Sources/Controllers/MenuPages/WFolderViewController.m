//
//  WFolderViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WFolderViewController.h"

@interface WFolderViewController ()

@end

@implementation WFolderViewController


#pragma mark -
#pragma mark Initialization methods

- (id)initWithPath:(NSString *)path andData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _path = path;
        _data = data;
        
        void (^success)(NSDictionary *) = ^(NSDictionary *json) {
            _data = json;
            DDLogWarn(@"data: %@", _data);
            [self.tableView reloadData];
        };
        void (^failure)(id) = ^(NSDictionary *error) {
            DDLogError(@"Failure while listing files: %@", error);
        };
        if (_path == nil) {
            [WRequest listAllFilesWithSuccess:success failure:failure];
        } else if (_data == nil) {
            [WRequest listFilesInDir:_path success:success failure:failure];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"RootPageTitle");
    self.homeCellIndex = kHomeFoldersCellIndex;
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
    [button addTarget:self action:@selector(addFile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = addButton;
}


#pragma mark -
#pragma mark Upload methods

- (void)addFile:(id)sender {
    // do nothing
}

@end

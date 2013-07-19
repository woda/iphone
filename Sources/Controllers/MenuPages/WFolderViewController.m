//
//  WFolderViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WFolderViewController.h"
#import "WUploadManager+Picker.h"
#import "WRequest+Sync.h"

@interface WFolderViewController ()

@end

@implementation WFolderViewController


#pragma mark -
#pragma mark Initialization methods

- (void)reload {
    void (^success)(NSDictionary *) = ^(NSDictionary *json) {
        self.data = json;
    };
    void (^failure)(id) = ^(NSDictionary *error) {
        DDLogError(@"Failure while listing files: %@", error);
    };
    if (_path == nil) {
        [WRequest listAllFilesWithSuccess:success failure:failure];
    } else if (self.data == nil) {
        [WRequest listFilesInDir:_path success:success failure:failure];
    }
}

- (id)initWithPath:(NSString *)path andData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.path = path;
        self.data = data;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"RootPageTitle");
    self.homeCellIndex = kHomeFoldersCellIndex;
    
    [self reload];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:kFileDeletedNotificationName object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [WUploadManager presentPickerInController:self];
    
//    NSDictionary *file = [[self.data objectForKey:@"files"] first];
//    if ([[file objectForKey:@"favorite"]  boolValue]) {
//        [WRequest unmarkFileAsFavorite:[file objectForKey:@"id"] success:^(id json) {
//            [WRequest listAllFilesWithSuccess:^(NSDictionary *json) {
//                self.data = json;
//            } failure:^(NSDictionary *error) {
//                DDLogError(@"Failure while listing files: %@", error);
//            }];
//        } failure:^(id error) {
//            DDLogError(@"Failure while marking file as favorite: %@", error);
//        }];
//    } else {
//        [WRequest markFileAsFavorite:[file objectForKey:@"id"] success:^(id json) {
//            [WRequest listAllFilesWithSuccess:^(NSDictionary *json) {
//                self.data = json;
//            } failure:^(NSDictionary *error) {
//                DDLogError(@"Failure while listing files: %@", error);
//            }];
//        } failure:^(id error) {
//            DDLogError(@"Failure while marking file as favorite: %@", error);
//        }];
//    }
}

- (void)imagePickerDismissed:(UIImagePickerController *)picker {
    [WRequest listAllFilesWithSuccess:^(NSDictionary *json) {
        self.data = json;
        
        WHomeViewController *home = [(WNavigationController *)self.navigationController homeController];;
        [home tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:kHomeUploadCellIndex inSection:0]];
    } failure:^(NSDictionary *error) {
        DDLogError(@"Failure while listing files: %@", error);
    }];
}

@end

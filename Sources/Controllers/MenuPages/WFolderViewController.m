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
    if (self.path == nil && self.data == nil) {
        [WRequest listAllFilesWithSuccess:success failure:failure];
    } else if (self.data == nil) {
        [WRequest listFilesInDir:self.path success:success failure:failure];
    }
}

- (NSString *)path {
    if (_path == nil)
        return @"";
    if (![_path hasSuffix:@"/"])
        return [_path stringByAppendingString:@"/"];
    return _path;
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
    
    if (self.data[@"name"] == nil)
        self.title = NSLocal(@"RootPageTitle");
    else
        self.title = self.data[@"name"];
    self.homeCellIndex = kHomeFoldersCellIndex;
    
    if (self.data != nil)
        [self.loading stopAnimating];
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

- (void)openFolder:(NSDictionary *)folder {
    NSString *p = [self.path stringByAppendingFormat:@"%@/", folder[@"name"]];
    WFolderViewController *c = [[WFolderViewController alloc] initWithPath:p andData:folder];
    [self.navigationController pushViewController:c animated:YES];
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

- (void)imagePickerDismissed:(WSAssetPickerController *)picker {
    [WRequest listAllFilesWithSuccess:^(NSDictionary *json) {
        self.data = json;
        
        WHomeViewController *home = [(WNavigationController *)self.navigationController homeController];
        [home tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:kHomeUploadCellIndex inSection:0]];
    } failure:^(NSDictionary *error) {
        DDLogError(@"Failure while listing files: %@", error);
    }];
}

@end

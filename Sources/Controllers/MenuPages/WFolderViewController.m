//
//  WFolderViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WFolderViewController.h"
#import "WUploadManager+Picker.h"
#import "WImagePreviewViewController.h"
#import "WDownloadingViewController.h"
#import "WOfflineManager.h"
#import "WRequest+Sync.h"
#import "WFileCell.h"

@interface WFolderViewController ()

@end

@implementation WFolderViewController


#pragma mark -
#pragma mark Initialization methods

- (void)reload {
    void (^success)(NSDictionary *) = ^(NSDictionary *json) {
        self.data = json;
        [self.refreshControl endRefreshing];
    };
    void (^failure)(id) = ^(NSDictionary *error) {
        DDLogError(@"Failure while listing files: %@", error);
        [self.refreshControl endRefreshing];
    };
    if (self.folderId == nil && self.data == nil) {
        [WRequest listAllFilesWithSuccess:success failure:failure];
    } else {
        [WRequest file:self.folderId success:success failure:failure];
    }
}

- (id)initWithId:(NSNumber *)folderId andData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.folderId = folderId;
        self.data = data;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.data[@"name"] == nil || [self.data[@"name"] isEqualToString:@"/"])
        self.title = NSLocal(@"RootPageTitle");
    else
        self.title = self.data[@"name"];
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

- (void)openFolder:(NSDictionary *)folder {
    NSString *p = self.path;
    if (p) {
        p = [p stringByAppendingPathComponent:folder[@"name"]];
    } else {
        p = folder[@"name"];
    }
    WFolderViewController *c = [[WFolderViewController alloc] initWithId:folder[@"id"] andData:folder];
    c.path = p;
    [self.navigationController pushViewController:c animated:YES];
}

//- (void)openFile:(NSDictionary *)file {
//    if (file[@"size"] && file[@"part_size"]) {
//        NSData *data = [WOfflineManager fileForId:file[@"id"]];
//        if (data) {
//            NSString *type = file[@"type"];
//            if ([WFileCell isFileAnImage:type]) {
//                WImagePreviewViewController *c = [[WImagePreviewViewController alloc] initWithImage:[UIImage imageWithData:data]];
//                [self.navigationController pushViewController:c animated:YES];
//            }
//        } else {
//            WDownloadingViewController *c = [[WDownloadingViewController alloc] initWithFile:file inFolder:self.path];
//            [self.navigationController pushViewController:c animated:YES];
//        }
//    }
//}


#pragma mark -
#pragma mark Upload methods

- (void)addFile:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocal(@"CancelButtonTitle")
                                  destructiveButtonTitle:NSLocal(@"NewFile")
                                  otherButtonTitles:NSLocal(@"NewFolder"), nil];
    [actionSheet showInView:self.view];
    
    
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


#pragma mark - Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [WUploadManager presentPickerInController:self];
    } else if (buttonIndex == 1) {
        UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"New folder"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocal(@"CancelButtonTitle")
                                               otherButtonTitles:NSLocal(@"CreateButtonTitle"), nil];
        prompt.alertViewStyle = UIAlertViewStylePlainTextInput;
        [prompt textFieldAtIndex:0].placeholder = @"Folder name";
        [prompt show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *text = [alertView textFieldAtIndex:0].text;
    if ((buttonIndex == 1) && text.length) {
        NSString *p = (self.path) ? self.path : @"";
        [WRequest createFolder:[p stringByAppendingPathComponent:text] success:^(id json) {
            [self reload];
        } failure:^(id error) {
            // Do nothing
        }];
    }
}

@end

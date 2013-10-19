//
//  WUploadManager+Picker.h
//  Woda
//
//  Created by Théo LUBERT on 7/3/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUploadManager.h"
#import "WPicturePickerViewController.h"

@protocol WUploadManagerPickerDelegate <NSObject>

- (NSString *)path;
- (void)imagePickerDismissed:(WSAssetPickerController *)picker;

@end


@interface WUploadManager (Picker) <WSAssetPickerControllerDelegate>

@property (nonatomic, retain) UIViewController<WUploadManagerPickerDelegate> *delegate;
@property (nonatomic, retain) ALAssetsLibrary   *assetsLibrary;

+ (void)presentPickerInController:(UIViewController *)c;

@end

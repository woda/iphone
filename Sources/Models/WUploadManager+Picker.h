//
//  WUploadManager+Picker.h
//  Woda
//
//  Created by Théo LUBERT on 7/3/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUploadManager.h"

@protocol WUploadManagerPickerDelegate <NSObject>

- (void)imagePickerDismissed:(UIImagePickerController *)picker;

@end


@interface WUploadManager (Picker) <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIViewController<WUploadManagerPickerDelegate> *delegate;

+ (void)presentPickerInController:(UIViewController *)c;

@end

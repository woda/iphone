//
//  WUploadManager+Picker.m
//  Woda
//
//  Created by Théo LUBERT on 7/3/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <objc/runtime.h>
#import "WUploadManager+Picker.h"
#import "WPicturePickerViewController.h"

static char const * const delegateKey = "delegate";


@implementation WUploadManager (Picker)

@dynamic delegate;

- (UIViewController<WUploadManagerPickerDelegate> *)delegate {
    return (UIViewController<WUploadManagerPickerDelegate> *)objc_getAssociatedObject(self, delegateKey);
}

- (void)setDelegate:(UIViewController<WUploadManagerPickerDelegate> *)delegate {
    objc_setAssociatedObject(self, delegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+ (void)presentPickerInController:(UIViewController<WUploadManagerPickerDelegate> *)c {
//    WPicturePickerViewController *picker = [[WPicturePickerViewController alloc] init];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType source = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        source |= UIImagePickerControllerSourceTypePhotoLibrary;
    }
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
//        source |= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    }
    [picker setSourceType:source];
    
    [WUploadManager shared].delegate = c;
    picker.delegate = [WUploadManager shared];
    
    [c presentViewController:picker animated:YES completion:^{
        // do nothing
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self uploadFile:UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"])
                name:nil
           mediaType:[info objectForKey:@"UIImagePickerControllerMediaType"]
            assetURL:[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        [self.delegate imagePickerDismissed:picker];
        picker.delegate = nil;
        self.delegate = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        [self.delegate imagePickerDismissed:picker];
        picker.delegate = nil;
        self.delegate = nil;
    }];
}

@end

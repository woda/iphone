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
static char const * const assetsLibraryKey = "assetsLibrary";


@implementation WUploadManager (Picker)

@dynamic delegate;
@dynamic assetsLibrary;

- (UIViewController<WUploadManagerPickerDelegate> *)delegate {
    return (UIViewController<WUploadManagerPickerDelegate> *)objc_getAssociatedObject(self, delegateKey);
}

- (void)setDelegate:(UIViewController<WUploadManagerPickerDelegate> *)delegate {
    objc_setAssociatedObject(self, delegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ALAssetsLibrary *)assetsLibrary {
    return (ALAssetsLibrary *)objc_getAssociatedObject(self, assetsLibraryKey);
}

- (void)setAssetsLibrary:(ALAssetsLibrary *)assetsLibrary {
    objc_setAssociatedObject(self, assetsLibraryKey, assetsLibrary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+ (void)presentPickerInController:(UIViewController<WUploadManagerPickerDelegate> *)c {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [WUploadManager shared].assetsLibrary = library;
    
    WPicturePickerViewController *picker = [[WPicturePickerViewController alloc] initWithAssetsLibrary:[WUploadManager shared].assetsLibrary];
    picker.delegate = [WUploadManager shared];
    [WUploadManager shared].delegate = c;
    
    [c presentViewController:picker animated:YES completion:^{
        // do nothing
    }];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    NSLog(@"Picker return: %@", info);
//    [self uploadFile:UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"])
//                name:nil
//           mediaType:[info objectForKey:@"UIImagePickerControllerMediaType"]
//            assetURL:[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
//    [self.delegate dismissViewControllerAnimated:YES completion:^{
//        [self.delegate imagePickerDismissed:picker];
//        picker.delegate = nil;
//        self.delegate = nil;
//    }];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self.delegate dismissViewControllerAnimated:YES completion:^{
//        [self.delegate imagePickerDismissed:picker];
//        picker.delegate = nil;
//        self.delegate = nil;
//    }];
//}

- (void)assetPickerController:(WSAssetPickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)assets {
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        [self.delegate imagePickerDismissed:picker];
        NSLog(@"Picker return: %@", assets);
        for (ALAsset *asset in assets) {
            [self uploadFileWihAsset:asset inFolder:[self.delegate path]];
        }
        
        picker.delegate = nil;
        self.delegate = nil;
    }];
}

- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)picker {
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        [self.delegate imagePickerDismissed:picker];
        picker.delegate = nil;
        self.delegate = nil;
    }];
}

@end

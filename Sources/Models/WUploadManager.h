//
//  WUploadManager.h
//  Woda
//
//  Created by Théo LUBERT on 7/3/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kUploadList             @"kUploadList"
#define kUploadListLastUpdate   @"kUploadListLastUpdate"
#define kUploadFileName         @"kUploadFileName"
#define kUploadMediaType        @"kUploadMediaType"
#define kUploadThumbnail        @"kUploadThumbnail"
#define kUploadAssetURL         @"kUploadAssetURL"
#define kUploadNotificationName @"kUploadNotificationName"
#define kUploadDate             @"kUploadDate"
#define kUploadProgress         @"kUploadProgress"
#define kUploadNeedsUpload      @"kUploadNeedsUpload"


@protocol WUploadManagerPickerDelegate;

@interface WUploadManager : NSObject

+ (WUploadManager *)shared;
+ (NSDictionary *)uploadList;

- (void)uploadFileWihAsset:(ALAsset *)asset inFolder:(NSString *)path;

@end

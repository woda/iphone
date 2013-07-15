//
//  WUploadManager.m
//  Woda
//
//  Created by Théo LUBERT on 7/3/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "WUploadManager.h"
#import "WRequest+Sync.h"

//static const int ddLogLevel = LOG_LEVEL_INFO;
static WUploadManager *shared = nil;

@implementation WUploadManager

+ (WUploadManager *)shared {
    if (shared == nil) {
        shared = [[WUploadManager alloc] init];
    }
    return (shared);
}

#define kUploadList         @"kUploadList"
#define kUploadFileName     @"kUploadFileName"
#define kUploadMediaType    @"kUploadMediaType"
#define kUploadAssetURL     @"kUploadAssetURL"
#define kUploadDate         @"kUploadDate"
#define kUploadProgress     @"kUploadProgress"
#define kUploadNeedsUpload  @"kUploadNeedsUpload"

- (void)addFileToUploadList:(NSMutableDictionary *)info {
    info[kUploadNeedsUpload] = @YES;
    info[kUploadProgress] = @0;
    NSLog(@"Uploading: %@", info);
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *list = [NSMutableDictionary dictionaryWithDictionary:[df objectForKey:kUploadList]];
    [list setObject:info forKey:[info objectForKey:kUploadFileName]];
    [df setObject:list forKey:kUploadList];
    [df synchronize];
}

- (void)updateFileInUploadList:(NSDictionary *)info {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *list = [NSMutableDictionary dictionaryWithDictionary:[df objectForKey:kUploadList]];
    [list setObject:info forKey:[info objectForKey:kUploadFileName]];
    [df setObject:list forKey:kUploadList];
    [df synchronize];
}

- (void)uploadFile:(NSData *)file name:(NSString *)name mediaType:(NSString *)mediaType assetURL:(NSURL *)url {
    __block WUploadManager *blockSelf = self;
    __block NSString *fileName = name;
    NSDate *date = [NSDate date];
    
    void (^addFile)(ALAsset *) = ^(ALAsset *asset) {
        if ((asset) && (fileName == nil)) {
            fileName = [[asset defaultRepresentation] filename];
        }
        if (fileName.length <= 0) {
            DDLogError(@"Failed uploading file: The filename must contain at least 1 character");
        } else {
            NSMutableDictionary *info =[NSMutableDictionary dictionaryWithDictionary:@{
                                        kUploadFileName: fileName,
                                        kUploadMediaType: mediaType,
                                        kUploadAssetURL: [url relativeString],
                                        kUploadDate: date
                                        }];
            [blockSelf addFileToUploadList:info];
            
            [WRequest addFile:fileName withData:file success:^(id json) {
                info[kUploadNeedsUpload] = @NO;
                info[kUploadProgress] = @100;
                [blockSelf updateFileInUploadList:info];
            } loading:^(double pourcentage) {
                info[kUploadProgress] = @(pourcentage * 100);
                [blockSelf updateFileInUploadList:info];
            } failure:^(id error) {
                info[kUploadNeedsUpload] = @NO;
                [blockSelf updateFileInUploadList:info];
            }];
        }
    };
    
    if (url) {
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:url resultBlock:addFile failureBlock:^(NSError *error) {
            DDLogError(@"Failed finding the asset: %@", error);
        }];
    } else {
        addFile(nil);
    }
}

@end

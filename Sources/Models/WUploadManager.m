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

@interface WUploadManager ()

@property (nonatomic, retain) NSOperationQueue *operations;

@end

@implementation WUploadManager

+ (WUploadManager *)shared {
    if (shared == nil) {
        shared = [[WUploadManager alloc] init];
    }
    return (shared);
}

+ (NSDictionary *)uploadList {
    return ([[NSUserDefaults standardUserDefaults] objectForKey:kUploadList]);
}

- (id)init {
    self = [super init];
    if (self) {
        self.operations = [[NSOperationQueue alloc] init];
    }
    return (self);
}

- (void)addFileToUploadList:(NSMutableDictionary *)info {
    info[kUploadNeedsUpload] = @YES;
    info[kUploadProgress] = @0;
    NSLog(@"Uploading: %@", info);
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *list = [NSMutableDictionary dictionaryWithDictionary:[df objectForKey:kUploadList]];
    [list setObject:info forKey:[info objectForKey:kUploadFileName]];
    [df setObject:list forKey:kUploadList];
    [df setObject:[NSDate date] forKey:kUploadListLastUpdate];
    [df synchronize];
}

- (void)updateFileInUploadList:(NSDictionary *)info {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *list = [NSMutableDictionary dictionaryWithDictionary:[df objectForKey:kUploadList]];
    [list setObject:info forKey:[info objectForKey:kUploadFileName]];
    [df setObject:list forKey:kUploadList];
    [df setObject:[NSDate date] forKey:kUploadListLastUpdate];
    [df synchronize];
}

- (NSString *)thumbnailsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *thumbnailsPath = [documentsPath stringByAppendingPathComponent:@"Thumbails"];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:thumbnailsPath
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
    return (thumbnailsPath);
}

- (NSString *)saveThumbnail:(UIImage *)thumbnail {
    NSData *data = UIImagePNGRepresentation(thumbnail);
    NSString *identifer = [NSString stringWithFormat:@"%@.png", [[NSProcessInfo processInfo] globallyUniqueString]];
    NSString *filePath = [[self thumbnailsDirectory] stringByAppendingPathComponent:identifer];
    if (filePath) {
        [data writeToFile:filePath atomically:YES];
        return (filePath);
    }
    return (nil);
}

- (void)uploadFile:(NSData *)file name:(NSString *)name mediaType:(NSString *)mediaType assetURL:(NSURL *)url {
    __block WUploadManager *blockSelf = self;
    __block NSString *fileName = name;
    __block NSString *thumbnail = nil;
    NSDate *date = [NSDate dateWithTimeInterval:-(2*30*24*3600) sinceDate:[NSDate date]];
    
    void (^addFile)(ALAsset *) = ^(ALAsset *asset) {
        DDLogWarn(@"Asset: %@", asset);
        if (asset) {
            if (fileName == nil) {
                fileName = [[asset defaultRepresentation] filename];
            }
            thumbnail = [self saveThumbnail:[UIImage imageWithCGImage:[asset thumbnail]]];
        }
        if (fileName.length <= 0) {
            DDLogError(@"Failed uploading file: The filename must contain at least 1 character");
        } else {
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                      kUploadFileName: fileName,
                                                                     kUploadMediaType: mediaType,
                                                                      kUploadAssetURL: [url relativeString],
                                                                     kUploadThumbnail: thumbnail,
                                                              kUploadNotificationName: [[NSProcessInfo processInfo] globallyUniqueString],
                                                                          kUploadDate: date
                                         }];
            [blockSelf addFileToUploadList:info];
            
            [WRequest addFile:fileName withData:file success:^(id json) {
                info[kUploadNeedsUpload] = @NO;
                info[kUploadProgress] = @100;
                [blockSelf updateFileInUploadList:info];
                [[NSNotificationCenter defaultCenter] postNotificationName:info[kUploadNotificationName] object:nil userInfo:info];
            } loading:^(double pourcentage) {
                info[kUploadProgress] = @(pourcentage * 100);
                [blockSelf updateFileInUploadList:info];
                DDLogInfo(@"Uploading '%@': %d%%", [info objectForKey:kUploadFileName], (int)(pourcentage * 100));
                [[NSNotificationCenter defaultCenter] postNotificationName:info[kUploadNotificationName] object:nil userInfo:info];
            } failure:^(id error) {
                info[kUploadNeedsUpload] = @NO;
                [blockSelf updateFileInUploadList:info];
                [[NSNotificationCenter defaultCenter] postNotificationName:info[kUploadNotificationName] object:nil userInfo:info];
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

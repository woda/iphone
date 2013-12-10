//
//  WUploadManager.m
//  Woda
//
//  Created by Théo LUBERT on 7/3/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

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

+ (void)cleanUploadList {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df removeObjectForKey:kUploadList];
    [df synchronize];
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
    [[NSFileManager defaultManager] createDirectoryAtPath:thumbnailsPath
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                    error:nil];
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

- (void)uploadFileWihAsset:(ALAsset *)asset inFolder:(NSString *)path {
    __block WUploadManager *blockSelf = self;
    NSDate *date = [NSDate date];
    
    DDLogWarn(@"Asset: %@", asset);
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    
    Byte *buffer = (Byte*)malloc(rep.size);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
    NSData *file = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
    
    NSString *fileName = (path) ? [path stringByAppendingPathComponent:[rep filename]] : [rep filename];
    NSString *mediaType = [fileName componentsSeparatedByString:@"."].last;
    NSString *thumbnail = [self saveThumbnail:[UIImage imageWithCGImage:[asset thumbnail]]];
    
    if (fileName.length <= 0) {
        DDLogError(@"Failed uploading file: The filename must contain at least 1 character");
    } else {
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                  kUploadFileName: fileName,
                                                                 kUploadMediaType: mediaType,
                                                                 kUploadThumbnail: thumbnail,
                                                          kUploadNotificationName: [[NSProcessInfo processInfo] globallyUniqueString],
                                                                      kUploadDate: date
                                     }];
        [self addFileToUploadList:info];
        
        [WRequest addFile:fileName withData:file success:^(id json) {
            info[kUploadNeedsUpload] = @NO;
            info[kUploadProgress] = @100;
            [blockSelf updateFileInUploadList:info];
            [[NSNotificationCenter defaultCenter] postNotificationName:info[kUploadNotificationName] object:nil userInfo:info];
        } loading:^(double pourcentage) {
//            [self performBlockInBackground:^{
                if ((int)(pourcentage * 100) > [info[kUploadProgress] integerValue]) {
                    info[kUploadProgress] = @((int)(pourcentage * 100));
                    [blockSelf updateFileInUploadList:info];
                    DDLogInfo(@"Uploading '%@': %@%%", [info objectForKey:kUploadFileName], info[kUploadProgress]);
                    [[NSNotificationCenter defaultCenter] postNotificationName:info[kUploadNotificationName] object:nil userInfo:info];
                }
//            }];
        } failure:^(id error) {
            info[kUploadNeedsUpload] = @NO;
            [blockSelf updateFileInUploadList:info];
            [[NSNotificationCenter defaultCenter] postNotificationName:info[kUploadNotificationName] object:nil userInfo:info];
        }];
    }
}

@end

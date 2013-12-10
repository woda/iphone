//
//  WOfflineManager.m
//  Woda
//
//  Created by Théo LUBERT on 7/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WOfflineManager.h"

static const int ddLogLevel = LOG_LEVEL_INFO;
static WOfflineManager *shared = nil;

@interface WOfflineManager ()

@end

@implementation WOfflineManager

+ (WOfflineManager *)shared {
    if (shared == nil) {
        shared = [[WOfflineManager alloc] init];
    }
    return (shared);
}

+ (NSData *)fileForId:(NSNumber *)idNumber {
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:kOfflineList][[idNumber description]][kOfflineFilePath];
    if (url == nil) {
        url = [[NSUserDefaults standardUserDefaults] objectForKey:kTemporaryList][[idNumber description]][kOfflineFilePath];
    }
    return ([NSData dataWithContentsOfFile:url]);
}

+ (NSURL *)fileURLForId:(NSNumber *)idNumber {
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:kOfflineList][[idNumber description]][kOfflineFilePath];
    if (url == nil) {
        url = [[NSUserDefaults standardUserDefaults] objectForKey:kTemporaryList][[idNumber description]][kOfflineFilePath];
    }
    if (url)
        return ([[NSURL alloc] initFileURLWithPath:url]);
    return nil;
}

+ (NSString *)filePathForId:(NSNumber *)idNumber {
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:kOfflineList][[idNumber description]][kOfflineFilePath];
    if (url == nil) {
        url = [[NSUserDefaults standardUserDefaults] objectForKey:kTemporaryList][[idNumber description]][kOfflineFilePath];
    }
    return (url);
}

+ (NSString *)directory:(NSString *)dir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *p = [documentsPath stringByAppendingPathComponent:dir];
    [[NSFileManager defaultManager] createDirectoryAtPath:p
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:nil];
    return (p);
}

+ (NSString *)offlineDirectory {
    return ([WOfflineManager directory:@"Offline"]);
}

+ (NSString *)temporaryDirectory {
    return ([WOfflineManager directory:@"Temporary"]);
}

+ (void)clearTemporaryFiles {
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:[self temporaryDirectory] error:&error]) {
        NSLog(@"Remove directory error: %@", error);
    }
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:@{} forKey:kTemporaryList];
    [df synchronize];
}

+ (void)clearOfflineFiles {
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:[self offlineDirectory] error:&error]) {
        NSLog(@"Remove directory error: %@", error);
    }
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:@{} forKey:kOfflineList];
    [df synchronize];
}

+ (void)clearAllFiles {
    [WOfflineManager clearTemporaryFiles];
    [WOfflineManager clearOfflineFiles];
}

- (void)saveFile:(NSData *)data withInfo:(NSDictionary *)info offline:(Boolean)offline {
    NSString *identifer = [NSString stringWithFormat:@"%@%@", [[NSProcessInfo processInfo] globallyUniqueString], info[@"type"]];
    NSString *filePath = nil;
    if (offline) {
        filePath = [[WOfflineManager offlineDirectory] stringByAppendingPathComponent:identifer];
    } else {
//        filePath = [[WOfflineManager offlineDirectory] stringByAppendingPathComponent:identifer];
        filePath = [[WOfflineManager temporaryDirectory] stringByAppendingPathComponent:identifer];
    }
    if (filePath) {
        [data writeToFile:filePath atomically:YES];
        
        NSString *listKey = kTemporaryList;
//        NSString *listKey = kOfflineList;
        if (offline) {
            listKey = kOfflineList;
        }
        
        NSMutableDictionary *fullInfo = [NSMutableDictionary dictionaryWithDictionary:info];
        fullInfo[kOfflineFilePath] = filePath;
        fullInfo[kOfflineFileDate] = [NSDate date];
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *list = [NSMutableDictionary dictionaryWithDictionary:[df objectForKey:listKey]];
        [list setObject:fullInfo forKey:[info[@"id"] description]];
        [df setObject:list forKey:listKey];
        [df synchronize];
    }
}

- (NSDictionary *)offlineFiles {
//    NSDictionary *list = [[NSUserDefaults standardUserDefaults] objectForKey:kOfflineList];
    NSDictionary *list = [[NSUserDefaults standardUserDefaults] objectForKey:kTemporaryList];
    NSArray *files = [list allValues];
    files = [files sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *file1, NSDictionary *file2) {
        return ([file2[kOfflineFileDate] compare:file1[kOfflineFileDate]]);
    }];
    if (files) {
        return @{@"files": files};
    }
    return @{@"files": @[]};
}

- (void)removeFileForId:(NSNumber *)idNumber {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *url = [df objectForKey:kOfflineList][[idNumber description]][kOfflineFilePath];
    
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:url error:&error]) {
        NSLog(@"Remove file error: %@", error);
    }
    
    
    NSMutableDictionary *list = [NSMutableDictionary dictionaryWithDictionary:[df objectForKey:kOfflineList]];
    [list removeObjectForKey:[idNumber description]];
    [df setObject:list forKey:kOfflineList];
    [df synchronize];
}

@end

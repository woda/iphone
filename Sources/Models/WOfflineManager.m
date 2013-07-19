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
    return ([NSData dataWithContentsOfFile:url]);
}

- (NSString *)offlineDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *thumbnailsPath = [documentsPath stringByAppendingPathComponent:@"Offline"];
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

- (void)saveFile:(NSData *)data withType:(NSString *)type forId:(NSNumber *)idNumber {
    NSString *identifer = [NSString stringWithFormat:@"%@%@", [[NSProcessInfo processInfo] globallyUniqueString], type];
    NSString *filePath = [[self offlineDirectory] stringByAppendingPathComponent:identifer];
    if (filePath) {
        [data writeToFile:filePath atomically:YES];
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *list = [NSMutableDictionary dictionaryWithDictionary:[df objectForKey:kOfflineList]];
        [list setObject:@{kOfflineFilePath: filePath} forKey:[idNumber description]];
        [df setObject:list forKey:kOfflineList];
        [df synchronize];
    }
}

@end

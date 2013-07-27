//
//  WOfflineManager.h
//  Woda
//
//  Created by Théo LUBERT on 7/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOfflineList            @"kOfflineList"
#define kTemporaryList          @"kTemporaryList"
#define kOfflineFileId          @"kOfflineFileId"
#define kOfflineFilePath        @"kOfflineFilePath"
#define kOfflineFileDate        @"kOfflineFileDate"

@interface WOfflineManager : NSObject

+ (WOfflineManager *)shared;
+ (NSData *)fileForId:(NSNumber *)idNumber;
+ (void)clearTemporaryFiles;
+ (void)clearAllFiles;

- (void)saveFile:(NSData *)data withInfo:(NSDictionary *)info offline:(Boolean)offline;
- (void)removeFileForId:(NSNumber *)idNumber;
- (NSDictionary *)offlineFiles;

@end

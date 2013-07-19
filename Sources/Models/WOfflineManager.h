//
//  WOfflineManager.h
//  Woda
//
//  Created by Théo LUBERT on 7/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOfflineList            @"kOfflineList"
#define kOfflineFileId          @"kOfflineFileId"
#define kOfflineFilePath         @"kOfflineFilePath"

@interface WOfflineManager : NSObject

+ (WOfflineManager *)shared;
+ (NSData *)fileForId:(NSNumber *)idNumber;

- (void)saveFile:(NSData *)file withType:(NSString *)type forId:(NSNumber *)idNumber;

@end

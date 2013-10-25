//
//  WFileItem.m
//  Woda
//
//  Created by Théo LUBERT on 10/25/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WFileItem.h"
#import "WOfflineManager.h"

@implementation WFileItem

+ (WFileItem *)fileWithInfo:(NSDictionary *)info {
    NSNumber *fileId = info[@"id"];
    NSString *path = [WOfflineManager filePathForId:fileId];
    if (path) {
        WFileItem *file = [[WFileItem alloc] init];
        file.url = [NSURL fileURLWithPath:path];
        file.info = info;
        return (file);
    }
    return nil;
}

- (NSString *)previewItemTitle {
    return (self.info[@"name"]);
}

-  (NSURL *)previewItemURL {
    return self.url;
}

@end

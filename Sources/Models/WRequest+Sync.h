//
//  WRequest+Sync.h
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"

@interface WRequest (Sync)

+ (void)addFile:(NSString *)filename withData:(NSData *)data;
+ (void)removeFile:(NSString *)filename;
+ (void)updateFile:(NSString *)filename withData:(NSData *)data;
+ (void)getFile:(NSString *)filename;

@end

//
//  WUploadManager.h
//  Woda
//
//  Created by Théo LUBERT on 7/3/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WUploadManagerPickerDelegate;

@interface WUploadManager : NSObject

+ (WUploadManager *)shared;

- (void)uploadFile:(NSData *)file name:(NSString *)name mediaType:(NSString *)mediaType assetURL:(NSURL *)url;

@end

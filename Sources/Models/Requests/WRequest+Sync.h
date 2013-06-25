//
//  WRequest+Sync.h
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"

@interface WRequest (Sync)

+ (void)addFile:(NSString *)filename
       withData:(NSData *)data
        success:(void (^)(id json))success
        loading:(void (^)(double pourcentage))loading
        failure:(void (^)(id error))failure;

+ (void)uploadFile:(NSString *)filename
          withPart:(NSData *)part
            number:(NSNumber *)number
           success:(void (^)(NSNumber *partNumber))success
           failure:(void (^)(id error))failure;

+ (void)uploadFile:(NSString *)filename
          partSize:(NSNumber *)partSize
          withData:(NSData *)data
           success:(void (^)(id json))success
           loading:(void (^)(double pourcentage))loading
           failure:(void (^)(id error))failure;

+ (void)comfirmUpload:(NSString *)filename
              success:(void (^)(id json))success
              failure:(void (^)(id error))failure;

+ (void)removeFile:(NSString *)filename
           success:(void (^)(id json))success
           failure:(void (^)(id error))failure;

+ (void)updateFile:(NSString *)filename
          withData:(NSData *)data
           success:(void (^)(id json))success
           loading:(void (^)(double pourcentage))loading
           failure:(void (^)(id error))failure;

+ (void)getFile:(NSString *)filename
     partNumber:(NSNumber *)part
        success:(void (^)(NSData *data, NSNumber *partNumber))success
        failure:(void (^)(id error))failure;

+ (void)getFile:(NSString *)filename
          parts:(NSNumber *)parts
        success:(void (^)(NSData *file))success
        loading:(void (^)(double pourcentage))loading
        failure:(void (^)(id error))failure;

@end

//
//  WRequest+Sync.h
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"

@interface WRequest (Sync)

+ (NSString *)sha256hash:(NSData *)data;

+ (void)addFile:(NSString *)filename
       withData:(NSData *)data
        success:(void (^)(id json))success
        loading:(void (^)(double pourcentage))loading
        failure:(void (^)(id error))failure;

+ (NSOperation *)uploadFile:(NSNumber *)fileId
                   withPart:(NSData *)part
                     number:(NSNumber *)partNumber
                    success:(void (^)(NSNumber *partNumber))success
                    loading:(void (^)(NSNumber *partNumber, double pourcentage))loading
                    failure:(void (^)(id error))failure;

+ (void)uploadFile:(NSNumber *)fileId
          partSize:(NSNumber *)partSize
          withData:(NSData *)data
           success:(void (^)(id json))success
           loading:(void (^)(double pourcentage))loading
           failure:(void (^)(id error))failure;

+ (void)comfirmUpload:(NSNumber *)fileId
              success:(void (^)(id json))success
              failure:(void (^)(id error))failure;

+ (void)createFolder:(NSString *)folder
             success:(void (^)(id json))success
             failure:(void (^)(id error))failure;

+ (void)removeFile:(NSNumber *)fileId
           success:(void (^)(id json))success
           failure:(void (^)(id error))failure;

+ (void)updateFile:(NSNumber *)fileId
              name:(NSString *)filename
          withData:(NSData *)data
           success:(void (^)(id json))success
           loading:(void (^)(double pourcentage))loading
           failure:(void (^)(id error))failure;

+ (NSOperation *)getFile:(NSNumber *)fileId
              partNumber:(NSNumber *)part
                 success:(void (^)(NSData *data, NSNumber *partNumber))success
                 loading:(void (^)(NSNumber *partNumber, double pourcentage))loading
                 failure:(void (^)(id error))failure;

+ (void)getFile:(NSNumber *)fileId
          parts:(NSNumber *)parts
        success:(void (^)(NSData *file))success
        loading:(void (^)(double pourcentage))loading
        failure:(void (^)(id error))failure;

@end

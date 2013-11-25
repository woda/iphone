//
//  WRequest+List.h
//  Woda
//
//  Created by Théo LUBERT on 6/30/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"

@interface WRequest (List)

+ (void)file:(NSNumber *)fileId
     success:(void (^)(id json))success
     failure:(void (^)(id error))failure;

+ (void)listAllFilesWithSuccess:(void (^)(id json))success
                        failure:(void (^)(id error))failure;

+ (void)listRecentFilesWithSuccess:(void (^)(id json))success
                           failure:(void (^)(id error))failure;

+ (void)listFavoriteFilesWithSuccess:(void (^)(id json))success
                             failure:(void (^)(id error))failure;

+ (void)markFileAsFavorite:(NSNumber *)fileId
                   success:(void (^)(id json))success
                   failure:(void (^)(id error))failure;

+ (void)unmarkFileAsFavorite:(NSNumber *)fileId
                     success:(void (^)(id json))success
                     failure:(void (^)(id error))failure;

+ (void)listPublicFilesWithSuccess:(void (^)(id json))success
                           failure:(void (^)(id error))failure;

+ (void)markFileAsPublic:(NSNumber *)fileId
                 success:(void (^)(id json))success
                 failure:(void (^)(id error))failure;

+ (void)unmarkFileAsPublic:(NSNumber *)fileId
                   success:(void (^)(id json))success
                   failure:(void (^)(id error))failure;

+ (void)listSharedFilesWithSuccess:(void (^)(id json))success
                           failure:(void (^)(id error))failure;

+ (void)directDownloadLinkForFile:(NSNumber *)fileId
                          success:(void (^)(id json))success
                          failure:(void (^)(id error))failure;

+ (void)listDownloadedFilesWithSuccess:(void (^)(id json))success
                               failure:(void (^)(id error))failure;

@end

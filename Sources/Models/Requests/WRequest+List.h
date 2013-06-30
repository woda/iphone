//
//  WRequest+List.h
//  Woda
//
//  Created by Théo LUBERT on 6/30/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"

@interface WRequest (List)

+ (void)listFilesInDir:(NSString *)path
                success:(void (^)(id json))success
               failure:(void (^)(id error))failure;

+ (void)listAllFilesWithSuccess:(void (^)(id json))success
                        failure:(void (^)(id error))failure;

+ (void)lastUpdatedFilesWithSuccess:(void (^)(id json))success
                            failure:(void (^)(id error))failure;

+ (void)lastFavoriteFilesWithSuccess:(void (^)(id json))success
                             failure:(void (^)(id error))failure;

+ (void)markFileAsFavorite:(NSNumber *)idNumber
                   success:(void (^)(id json))success
                   failure:(void (^)(id error))failure;

+ (void)unmarkFileAsFavorite:(NSNumber *)idNumber
                     success:(void (^)(id json))success
                     failure:(void (^)(id error))failure;

@end

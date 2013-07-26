//
//  WRequest+List.m
//  Woda
//
//  Created by Théo LUBERT on 6/30/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest+List.h"

@implementation WRequest (List)

+ (void)listFilesInDir:(NSString *)path
               success:(void (^)(id json))success
               failure:(void (^)(id error))failure
{
    path = [@"/users/files" stringByAppendingString:path];
    [WRequest requestWithMethod:@"GET" path:path parameters:nil success:success failure:failure];
}

+ (void)listAllFilesWithSuccess:(void (^)(id json))success
                        failure:(void (^)(id error))failure
{
    [WRequest listFilesInDir:@"" success:success failure:failure];
}

+ (void)listUpdatedFilesWithSuccess:(void (^)(id json))success
                            failure:(void (^)(id error))failure
{
    NSString *path = @"/users/recents";
    [WRequest requestWithMethod:@"GET" path:path parameters:nil success:success failure:failure];
}

+ (void)listFavoriteFilesWithSuccess:(void (^)(id json))success
                             failure:(void (^)(id error))failure
{
    NSString *path = @"/users/favorites";
    [WRequest requestWithMethod:@"GET" path:path parameters:nil success:success failure:failure];
}

+ (void)listSharedFilesWithSuccess:(void (^)(id json))success
                           failure:(void (^)(id error))failure
{
//    NSString *path = @"/users/shared";
//    [WRequest requestWithMethod:@"GET" path:path parameters:nil success:success failure:failure];
}

+ (void)listPublicFilesWithSuccess:(void (^)(id json))success
                           failure:(void (^)(id error))failure
{
    NSString *path = @"/users/public_files";
    [WRequest requestWithMethod:@"GET" path:path parameters:nil success:success failure:failure];
}

+ (void)markFile:(NSNumber *)idNumber
      asFavorite:(NSString *)favorite
         success:(void (^)(id json))success
         failure:(void (^)(id error))failure
{
    NSString *path = [@"/users/favorites/{id}" stringByReplacingOccurrencesOfString:@"{id}" withString:[idNumber description]];
    NSDictionary *params = @{@"favorite": favorite};
    [WRequest requestWithMethod:@"POST" path:path parameters:params success:success failure:failure];
}

+ (void)markFileAsFavorite:(NSNumber *)idNumber
                   success:(void (^)(id json))success
                   failure:(void (^)(id error))failure
{
    [WRequest markFile:idNumber asFavorite:@"true" success:success failure:failure];
}

+ (void)unmarkFileAsFavorite:(NSNumber *)idNumber
                     success:(void (^)(id json))success
                     failure:(void (^)(id error))failure
{
    [WRequest markFile:idNumber asFavorite:@"false" success:success failure:failure];
}

@end

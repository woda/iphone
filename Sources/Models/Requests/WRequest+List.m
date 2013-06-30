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
    
    [[WRequest client] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else if ([json isKindOfClass:[NSDictionary class]] && [[json objectForKey:@"success"] boolValue]) {
            success(json);
        } else {
            failure(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}

+ (void)listAllFilesWithSuccess:(void (^)(id json))success
                        failure:(void (^)(id error))failure
{
    [WRequest listFilesInDir:@"" success:success failure:failure];
}

+ (void)lastUpdatedFilesWithSuccess:(void (^)(id json))success
                            failure:(void (^)(id error))failure
{
    [[WRequest client] getPath:@"/users/files/recents" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"error"]) {
            failure(json);
        } else {
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}

+ (void)lastFavoriteFilesWithSuccess:(void (^)(id json))success
                             failure:(void (^)(id error))failure
{
    [[WRequest client] getPath:@"/users/files/favorites" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"error"]) {
            failure(json);
        } else {
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}

+ (void)markFileAsFavorite:(NSNumber *)idNumber
                   success:(void (^)(id json))success
                   failure:(void (^)(id error))failure
{
    NSString *path = [@"/users/files/favorites/{id}" stringByReplacingOccurrencesOfString:@"{id}" withString:[idNumber description]];
    
    [[WRequest client] postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"error"]) {
            failure(json);
        } else {
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}

+ (void)unmarkFileAsFavorite:(NSNumber *)idNumber
                     success:(void (^)(id json))success
                     failure:(void (^)(id error))failure
{
    [WRequest markFileAsFavorite:idNumber success:success failure:failure];
}

@end

//
//  WRequest.m
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"


static AFHTTPClient *client = nil;

@implementation WRequest

+ (AFHTTPClient *)setBaseUrl:(NSString *)url {
    client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:url]];
    return (client);
}

+ (NSString *)baseUrl {
    return ([[client baseURL] absoluteString]);
}

+ (AFHTTPClient *)client {
    if (client == nil) {
        client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseURL]];
    }
    return (client);
}

+ (id)displayError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation {
    id json = [WRequest JSONFromData:[operation responseData]];
    if ([json isKindOfClass:[NSError class]]) {
        DDLogError(@"Error: Json parsing failed");
        return ([(NSError *)json localizedDescription]);
    } else if ([json isKindOfClass:[NSDictionary class]] && json[@"error"]) {
        DDLogError(@"Error: %@ (%@)", json[@"error"], json[@"message"]);
        return [NSError errorWithDomain:json[@"error"] code:0 userInfo:json];
    } else if (json == nil) {
        DDLogError(@"Error: No json available");
        return (error);
    }
    return (json);
}

+ (NSObject *)safeJSON:(NSObject *)data {
    if ([data isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray *a = [NSMutableArray array];
        for (NSObject *obj in (NSArray *)data) {
            NSObject *v = [WRequest safeJSON:obj];
            if (v) {
                [a addObject:v];
            }
        }
        return a;
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        for (NSString *key in [(NSDictionary *)data allKeys]) {
            NSObject *v = [WRequest safeJSON:[(NSDictionary *)data objectForKey:key]];
            if (v) {
                d[key] = v;
            }
        }
        return d;
    }
    return data;
}

+ (id)JSONFromData:(NSData *)data {
    NSError *error = nil;
    if ([data length] > 0) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            return (error);
        }
        return ([WRequest safeJSON:json]);
    }
    return (nil);
}

+ (void)requestWithMethod:(NSString *)method
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id json))success
                  failure:(void (^)(id error))failure
{
	NSURLRequest *request = [[WRequest client] requestWithMethod:method path:path parameters:parameters];
    AFHTTPRequestOperation *operation = [[WRequest client] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else {
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
    [[WRequest client] enqueueHTTPRequestOperation:operation];
}

+ (void)GET:(NSString *)path
 parameters:(NSDictionary *)parameters
    success:(void (^)(id json))success
    failure:(void (^)(id error))failure
{
    [WRequest requestWithMethod:kGET
                           path:path
                     parameters:parameters
                        success:success
                        failure:failure];
}

+ (void)PUT:(NSString *)path
 parameters:(NSDictionary *)parameters
    success:(void (^)(id json))success
    failure:(void (^)(id error))failure
{
    [WRequest requestWithMethod:kPUT
                           path:path
                     parameters:parameters
                        success:success
                        failure:failure];
}

+ (void)POST:(NSString *)path
  parameters:(NSDictionary *)parameters
     success:(void (^)(id json))success
     failure:(void (^)(id error))failure
{
    [WRequest requestWithMethod:kPOST
                           path:path
                     parameters:parameters
                        success:success
                        failure:failure];
}

+ (void)DELETE:(NSString *)path
    parameters:(NSDictionary *)parameters
       success:(void (^)(id json))success
       failure:(void (^)(id error))failure
{
    [WRequest requestWithMethod:kDELETE
                           path:path
                     parameters:parameters
                        success:success
                        failure:failure];
}

@end

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

+ (AFHTTPClient *)client {
    if (client == nil) {
        client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseURL]];
    }
    return (client);
}

+ (id)displayError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation {
//    NSLog(@"%@", error);
    
    id json = [WRequest JSONFromData:[operation responseData]];
    if ([json isKindOfClass:[NSError class]]) {
        NSLog(@"Error: Json parsing failed");
//        NSLog(@" Info: %@",[operation responseString]);
        return ([(NSError *)json localizedDescription]);
    }
    if (json == nil) {
        NSLog(@"Error: No json available");
        return ([error localizedDescription]);
    }
//    NSLog(@"Error: %@", json);
    return (json);
}

+ (id)JSONFromData:(NSData *)data {
    NSError *error = nil;
    if ((data) && ([data length] > 0)) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            return (error);
        }
        return (json);
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
        } else if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"error"]) {
            failure(json);
        } else {
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
    [[WRequest client] enqueueHTTPRequestOperation:operation];
}

@end

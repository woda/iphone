//
//  WRequest.h
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

//#define kBaseURL    @"https://127.0.0.1:3000"
//#define kBaseURL    @"https://192.168.2.1:3000"
#define kBaseURL    @"https://kobhqlt.fr:3000"
//#define kBaseURL    @"https://ec2-54-242-98-168.compute-1.amazonaws.com:3000"
//#define kBaseURL    @"http://httpbin.org/put"


#define kFileDeletedNotificationName    @"kFileDeletedNotificationName"
#define kFileMarkedNotificationName     @"kFileMarkedNotificationName"

#define kGET                            @"GET"
#define kPUT                            @"PUT"
#define kPOST                           @"POST"
#define kDELETE                         @"DELETE"


static const int ddLogLevel = LOG_LEVEL_INFO;

@interface WRequest : AFHTTPRequestOperation

+ (AFHTTPClient *)setBaseUrl:(NSString *)url;
+ (AFHTTPClient *)client;
+ (id)displayError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation;
+ (id)JSONFromData:(NSData *)data;

+ (void)requestWithMethod:(NSString *)method
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id json))success
                  failure:(void (^)(id error))failure;

+ (void)GET:(NSString *)path
 parameters:(NSDictionary *)parameters
    success:(void (^)(id json))success
    failure:(void (^)(id error))failure;
+ (void)PUT:(NSString *)path
 parameters:(NSDictionary *)parameters
    success:(void (^)(id json))success
    failure:(void (^)(id error))failure;
+ (void)POST:(NSString *)path
  parameters:(NSDictionary *)parameters
     success:(void (^)(id json))success
     failure:(void (^)(id error))failure;
+ (void)DELETE:(NSString *)path
    parameters:(NSDictionary *)parameters
       success:(void (^)(id json))success
       failure:(void (^)(id error))failure;

@end

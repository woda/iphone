//
//  WRequest.h
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "DDTTYLogger.h"

#define kBaseURL    @"https://127.0.0.1:3000"
//#define kBaseURL    @"https://woda-server.com:3000"
//#define kBaseURL    @"https://ec2-54-242-98-168.compute-1.amazonaws.com:3000"
//#define kBaseURL    @"http://httpbin.org/put"


static const int ddLogLevel = LOG_LEVEL_INFO;

@interface WRequest : AFHTTPRequestOperation

+ (AFHTTPClient *)client;
+ (id)displayError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation;
+ (id)JSONFromData:(NSData *)data;

@end

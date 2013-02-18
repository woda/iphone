//
//  WRequest.h
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

#define kBaseURL    @"https://ec2-54-242-98-168.compute-1.amazonaws.com:3000"
//#define kBaseURL    @"http://httpbin.org/put"

@interface WRequest : AFJSONRequestOperation

+ (AFHTTPClient *)client;
+ (void)displayError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation;
+ (id)JSONFromData:(NSData *)data;

@end
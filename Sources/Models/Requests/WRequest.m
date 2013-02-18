//
//  WRequest.m
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"

static AFHTTPClient *client = nil;
#import "AFJSONUtilities.h"

@implementation WRequest

+ (AFHTTPClient *)client {
    if (client == nil) {
        client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseURL]];
    }
    return (client);
}

+ (void)displayError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation {
    NSLog(@"%@", error);
    id json = [WRequest JSONFromData:[operation responseData]];
    if ([json isKindOfClass:[NSError class]]) {
        NSLog(@"Error: No json available");
    } else {
        NSLog(@"Error: %@", json);
    }
}

+ (id)JSONFromData:(NSData *)data {
    NSError *error = nil;
    id json = AFJSONDecode(data, &error);
    if (error) {
        return (error);
    }
    return (json);
}

@end

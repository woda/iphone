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

@end

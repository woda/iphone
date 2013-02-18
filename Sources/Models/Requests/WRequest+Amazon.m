//
//  WRequest+Amazon.m
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest+Amazon.h"

static AFHTTPClient *amazonClient = nil;

@implementation WRequest (Amazon)

+ (AFHTTPClient *)amazonClient {
    if (amazonClient == nil) {
        amazonClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kAmazonURL]];
    }
    return (amazonClient);
}

//You must send a POST request to https://woda-files.s3.amazonaws.com/ with:
//
//key=<file hash>&
//AWSAccessKeyId=AKIAIGXEIP24RN5TWCXQ&
//acl=private&
//success_action_redirect={BASE_URL}/sync/upload_success&
//policy=<base64 encoded json of the policy (without trailing new line)>&
//signature=<s3 signature>&
//Content-Type="application/octet-stream"&
//file=<the contents of the file>

+ (void)uploadFile:(NSData *)data withPolicy:(NSData *)policy {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:data forKey:@"key"];
    [params setValue:kAWSAccessKeyId forKey:@"AWSAccessKeyId"];
    [params setValue:@"private" forKey:@"acl"];
    [params setValue:[kBaseURL stringByAppendingString:@"/sync/upload_success"] forKey:@"success_action_redirect"];
    [params setValue:policy forKey:@"policy"];
    [params setValue:data forKey:@"signature"];
    [params setValue:@"application/octet-stream" forKey:@"Content-Type"];
    [params setValue:data forKey:@"file"];
    
    [[WRequest amazonClient] postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"File uploaded: %@", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}

@end

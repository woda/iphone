//
//  WRequest+Sync.m
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import "WRequest+Sync.h"

@implementation WRequest (Sync)

+ (NSString *)sha256hash:(NSData *)data {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(data.bytes, data.length, digest);
    NSData *sha256 = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    
    NSString *hash = [sha256 description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return (hash);
}

//Adding a file
//
//To add a file use a PUT request on:
//https://{base}:3000/sync/{filename}
//With filename url-encoded and with the following body parameters:
//content_hash={SHA256 hash of content}
//size={size of content (enforced by S3)}
//
//This will either return:
//{"success":true, "need_upload":false, "file": <JSON representation of file>} if the content_hash already exists
//{"success":true, "need_upload": true", "file": <JSON representation of file>, "policy": <S3 Policy>, "signature": <S3 signature>, "key": <AES 256 key>, "iv": <AES256 IV>}
//S3 policy is described in How to use S3. The server doesn't check whether the encryption has been done, so you can ignore it for the moment if you don't want to implement encryption right away (but please implement it eventually).

+ (void)addFile:(NSString *)filename withData:(NSData *)data {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[WRequest sha256hash:data] forKey:@"content_hash"];
    [params setValue:[NSNumber numberWithInteger:[data length]] forKey:@"size"];
    
    [[WRequest client] putPath:[@"/sync/{filename}" stringByReplacingOccurrencesOfString:@"{filename}" withString:filename] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"File created: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}


//Removing a file
//
//To remove a file, use a DELETE request on:
//https://{base}:3000/sync/{filename}
//
//This will return {"success": true}

+ (void)removeFile:(NSString *)filename {
    [[WRequest client] deletePath:[@"/sync/{filename}" stringByReplacingOccurrencesOfString:@"{filename}" withString:filename] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"File deleted: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}


//Changing a file
//
//To modify a file, use a POST request on:
//https://{base}:3000/sync/{filename}
//
//This is just a delete followed by an add, so it will return the same values as add can, but it can also have the same errors delete can.

+ (void)updateFile:(NSString *)filename withData:(NSData *)data {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[WRequest sha256hash:data] forKey:@"content_hash"];
    [params setValue:[NSNumber numberWithInteger:[data length]] forKey:@"size"];
    
    [[WRequest client] postPath:[@"/sync/{filename}" stringByReplacingOccurrencesOfString:@"{filename}" withString:filename] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"File ready for update: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}


//Getting a file
//
//To get a file, use a GET request on:
//https://{base}:3000/sync/{filename}
//
//This will return {"url": <the url of the file>, key: <AES256 key>, iv: <AES256 iv>}.
//You should be able to use the url of the file directly, but note that this url is only valid for 1 hour.
//If you are using crypto, decrypt using the AES256 info (of course this has to be implemented in the end).

+ (void)getFile:(NSString *)filename {
    [[WRequest client] getPath:[@"/sync/{filename}" stringByReplacingOccurrencesOfString:@"{filename}" withString:filename] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"File info: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}

@end

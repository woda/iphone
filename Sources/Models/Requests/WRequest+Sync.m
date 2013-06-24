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
//{"success":true, "need_upload": true", "file": <JSON representation of file>, "part_size": <an integer>}

+ (void)addFile:(NSString *)filename
       withData:(NSData *)data
        success:(void (^)(id json))success
        failure:(void (^)(id json))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[WRequest sha256hash:data] forKey:@"content_hash"];
    [params setValue:[NSNumber numberWithInteger:[data length]] forKey:@"size"];
    
    [[WRequest client] putPath:[@"/sync/{filename}" stringByReplacingOccurrencesOfString:@"{filename}" withString:filename] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else if ([[json objectForKey:@"success"] boolValue]) {
            NSLog(@"File created: %@", json);
            if ([[json objectForKey:@"need_upload"] boolValue]) {
                // Start uploading the file
                NSLog(@"File upload not implemented");
                success(json);
            }
        } else {
            NSLog(@"File not created: %@", json);
            failure(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}


//Uploading a file
//To upload a file you need to send parts of size "part_size" (which is given to you when you ask to add a file). The encryption is done on the server side, so just send it unencrypted. Part_size is typically 5 megs, but it could be less or more in the future so don't hardcode it.
//
//Do a PUT request on:
//https://{base}:3000/partsync/{part_number}/{filename}
//With the following parameter:
//data={the content of the part of the file}
//
//The part number should be a number from 0 to the number of parts needed to store the file.
///!\ There is no checking done on this right now, so do it well.

+ (void)updateFile:(NSString *)filename
          withPart:(NSData *)part
            number:(NSNumber *)number
           success:(void (^)(id json))success
           failure:(void (^)(id error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:part forKey:@"data"];
    
    NSString *path = @"/partsync/{part_number}/{filename}";
    path = [path stringByReplacingOccurrencesOfString:@"{part_number}" withString:[number stringValue]];
    path = [path stringByReplacingOccurrencesOfString:@"{filename}" withString:filename];
    
    [[WRequest client] putPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else {
            NSLog(@"File part.%@ updated: %@", number, json);
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}

+ (void)updateFile:(NSString *)filename
          partSize:(NSInteger)partSize
          withData:(NSData *)data
           success:(void (^)(id json))success
           loading:(void (^)(id json))loading
           failure:(void (^)(id json))failure
{
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    NSOperation *dependency = nil;
    for (int i=0, k=(data.length / partSize); i<k; i++) {
        NSData *d = [data subdataWithRange:NSMakeRange((i * partSize), MIN(partSize, (data.length - (i * partSize))))];
        
        
        NSBlockOperation *o = [NSBlockOperation blockOperationWithBlock:^{
            [WRequest updateFile:filename withPart:d number:@(i) success:^(id json) {
                loading(json);
            } failure:^(id error) {
                [q cancelAllOperations];
                failure(error);
            }];
        }];
        if (dependency) {
            [o addDependency:dependency];
        }
        [q addOperation:o];
    }
    NSBlockOperation *o = [NSBlockOperation blockOperationWithBlock:^{
        [WRequest comfirmUpload:filename success:success failure:failure];
    }];
    if (dependency) {
        [o addDependency:dependency];
    }
    [q addOperation:o];
}


//Confirming upload
//The upload is only confirmed when you do a POST request on
//https://{base}:3000/successsync/{filename}
//With no parameters.

+ (void)comfirmUpload:(NSString *)filename
              success:(void (^)(id json))success
              failure:(void (^)(id json))failure
{
    NSString *path = @"/successsync/{filename}";
    path = [path stringByReplacingOccurrencesOfString:@"{filename}" withString:filename];
    
    [[WRequest client] postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else {
            NSLog(@"File fully updated: %@", json);
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}


//Removing a file
//
//To remove a file, use a DELETE request on:
//https://{base}:3000/sync/{filename}
//
//This will return {"success": true}

+ (void)removeFile:(NSString *)filename
           success:(void (^)(id json))success
           failure:(void (^)(id json))failure
{
    NSString *path = @"/sync/{filename}";
    path = [path stringByReplacingOccurrencesOfString:@"{filename}" withString:filename];
    
    [[WRequest client] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:json forOperation:operation]);
        } else if ([[json objectForKey:@"success"] boolValue]) {
            NSLog(@"File deleted: %@", json);
            success(json);
        } else {
            NSLog(@"File not deleted: %@", json);
            failure(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
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

+ (void)getFile:(NSString *)filename
        success:(void (^)(id json))success
        failure:(void (^)(id json))failure
{
    [[WRequest client] getPath:[@"/sync/{filename}" stringByReplacingOccurrencesOfString:@"{filename}" withString:filename] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else {
            NSLog(@"File info: %@", json);
            success(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}

@end

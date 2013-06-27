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
        loading:(void (^)(double pourcentage))loading
        failure:(void (^)(id error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[WRequest sha256hash:data] forKey:@"content_hash"];
    [params setValue:[NSNumber numberWithInteger:[data length]] forKey:@"size"];
    NSLog(@"params: %@", params);
    
    NSString *path = @"/sync/{filename}";
    path = [path stringByReplacingOccurrencesOfString:@"{filename}" withString:filename];
    
    [[WRequest client] putPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else if ([[json objectForKey:@"success"] boolValue]) {
            DDLogInfo(@"File created");
            if ([[json objectForKey:@"need_upload"] boolValue]) {
                NSNumber *partSize = [json objectForKey:@"part_size"];
                if ([partSize integerValue] <= 0) {
                    DDLogWarn(@"Warning: 'part_size' info is missing in json: %@", json);
                    partSize = @(5*1024*1024); // 5ko
                }
                [WRequest uploadFile:filename partSize:partSize withData:data success:^(id json) {
                    success(json);
                } loading:^(double pourcentage) {
                    loading(pourcentage);
                } failure:^(id error) {
                    failure(error);
                }];
            } else {
                success(json);
            }
        } else {
            DDLogInfo(@"File not created: %@", json);
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

+ (NSOperation *)uploadFile:(NSString *)filename
                   withPart:(NSData *)part
                     number:(NSNumber *)partNumber
                    success:(void (^)(NSNumber *partNumber))success
                    loading:(void (^)(NSNumber *partNumber, double pourcentage))loading
                    failure:(void (^)(id error))failure
{
    NSString *partFormated = [[NSString alloc] initWithBytes:part.bytes length:part.length encoding:NSISOLatin1StringEncoding];
    NSLog(@"partFormated: %@", [partFormated substringWithRange:NSMakeRange(0, 10)]);
//    NSData *d = [partFormated dataUsingEncoding:NSISOLatin1StringEncoding];
//    NSLog(@"        data: %@", [[d description] substringWithRange:NSMakeRange(0, 40)]);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:partFormated forKey:@"data"];
    
    NSString *path = @"/partsync/{part_number}/{filename}";
    path = [path stringByReplacingOccurrencesOfString:@"{part_number}" withString:[partNumber stringValue]];
    path = [path stringByReplacingOccurrencesOfString:@"{filename}" withString:filename];
    
//    NSURLRequest *request = [[WRequest client] multipartFormRequestWithMethod:@"PUT" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:part
//                                    name:[partNumber description]
//                                fileName:[NSString stringWithFormat:@"%@.part", partNumber]
//                                mimeType:@"application/octet-stream"];
//    }];
    
    NSMutableURLRequest *request = [[WRequest client] requestWithMethod:@"PUT" path:path parameters:params];
    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithDictionary:[request allHTTPHeaderFields]];
    [header setValue:@"application/octet-stream" forKey:@"Content-Type"];
    [request setAllHTTPHeaderFields:header];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        loading(partNumber, (double)totalBytesWritten / (double)totalBytesExpectedToWrite);
    }];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else if ([[json objectForKey:@"success"] boolValue]) {
            DDLogInfo(@"File part.%@ updated: %@", partNumber, json);
            success(partNumber);
        } else {
            DDLogError(@"File part.%@ not updated: %@", partNumber, json);
            failure(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
    return (op);
}

+ (void)uploadFile:(NSString *)filename
          partSize:(NSNumber *)partSize
          withData:(NSData *)data
           success:(void (^)(id json))success
           loading:(void (^)(double pourcentage))loading
           failure:(void (^)(id error))failure
{
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    NSOperation *dependency = nil;
    NSInteger parts = 1+(data.length / [partSize integerValue]);
    for (int i=0, k=parts; i<k; i++) {
        NSData *d = [data subdataWithRange:NSMakeRange((i * [partSize integerValue]), MIN([partSize integerValue], (data.length - (i * [partSize integerValue]))))];
        
        NSOperation *o = [WRequest uploadFile:filename withPart:d number:@(i) success:^(NSNumber *partNumber) {
//            loading(([partNumber doubleValue] + 1.0) / (double)parts);
        } loading:^(NSNumber *partNumber, double pourcentage) {
            loading(([partNumber doubleValue] + pourcentage) / (double)parts);
        } failure:^(id error) {
            [q cancelAllOperations];
            failure(error);
        }];
        if (dependency) {
            [o addDependency:dependency];
        }
        if (![dependency isCancelled]) {
            dependency = o;
            [q addOperation:o];
        }
    }
    NSBlockOperation *o = [NSBlockOperation blockOperationWithBlock:^{
        [WRequest comfirmUpload:filename success:success failure:failure];
    }];
    if (dependency) {
        [o addDependency:dependency];
    }
    if (![dependency isCancelled]) {
        [q addOperation:o];
    }
}


//Confirming upload
//The upload is only confirmed when you do a POST request on
//https://{base}:3000/successsync/{filename}
//With no parameters.

+ (void)comfirmUpload:(NSString *)filename
              success:(void (^)(id json))success
              failure:(void (^)(id error))failure
{
    NSString *path = @"/successsync/{filename}";
    path = [path stringByReplacingOccurrencesOfString:@"{filename}" withString:filename];
    
    [[WRequest client] postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else if ([[json objectForKey:@"success"] boolValue]) {
            DDLogInfo(@"File upload complete: %@", json);
            success(json);
        } else {
            DDLogError(@"File upload not complete: %@", json);
            failure(json);
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
           failure:(void (^)(id error))failure
{
    NSString *path = @"/sync/{filename}";
    path = [path stringByReplacingOccurrencesOfString:@"{filename}" withString:filename];
    
    [[WRequest client] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:json forOperation:operation]);
        } else if ([[json objectForKey:@"success"] boolValue]) {
            DDLogInfo(@"File deleted: %@", json);
            success(json);
        } else {
            DDLogError(@"File not deleted: %@", json);
            failure(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}

//Changing a file
//To modify a file, use a POST request on:
//https://{base}:3000/sync/{filename}
//
//This is just a delete followed by an add, so it will return the same values as add can, but it can also have the same errors delete can.

+ (void)updateFile:(NSString *)filename
          withData:(NSData *)data
           success:(void (^)(id json))success
           loading:(void (^)(double pourcentage))loading
           failure:(void (^)(id error))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[WRequest sha256hash:data] forKey:@"content_hash"];
    [params setValue:[NSNumber numberWithInteger:[data length]] forKey:@"size"];
    
    NSString *path = @"/sync/{filename}";
    path = [path stringByReplacingOccurrencesOfString:@"{filename}" withString:filename];
    
    [[WRequest client] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            failure([WRequest displayError:(NSError *)json forOperation:operation]);
        } else if ([[json objectForKey:@"success"] boolValue]) {
            DDLogInfo(@"File created: %@", json);
            if ([[json objectForKey:@"need_upload"] boolValue]) {
                [WRequest uploadFile:filename partSize:[json objectForKey:@"part_size"] withData:data success:^(id json) {
                    success(json);
                } loading:^(double pourcentage) {
                    loading(pourcentage);
                } failure:^(id error) {
                    failure(error);
                }];
            } else {
                success(json);
            }
        } else {
            DDLogError(@"File not created: %@", json);
            failure(json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
}


//Getting a file
//To get a file, use a GET request on:
//https://{base}:3000/partsync/{numero_de_partie}/{filename}
//
//This will return the unencrypted part of the file.

+ (NSOperation *)getFile:(NSString *)filename
              partNumber:(NSNumber *)partNumber
                 success:(void (^)(NSData *data, NSNumber *partNumber))success
                 loading:(void (^)(NSNumber *partNumber, double pourcentage))loading
                 failure:(void (^)(id error))failure
{
    NSString *path = @"/partsync/{numero_de_partie}/{filename}";
    path = [path stringByReplacingOccurrencesOfString:@"{filename}" withString:filename];
    path = [path stringByReplacingOccurrencesOfString:@"{numero_de_partie}" withString:[partNumber stringValue]];
    
    NSURLRequest *request = [[WRequest client] requestWithMethod:@"GET" path:path parameters:nil];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        loading(partNumber, (double)totalBytesWritten / (double)totalBytesExpectedToWrite);
    }];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseData, partNumber);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure([WRequest displayError:error forOperation:operation]);
    }];
    return (op);
}

+ (void)getFile:(NSString *)filename
          parts:(NSNumber *)parts
        success:(void (^)(NSData *file))success
        loading:(void (^)(double pourcentage))loading
        failure:(void (^)(id error))failure
{
    if (parts == nil) {
        DDLogWarn(@"Warning: Number of parts info is missing in json");
        parts = @1;
    }
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    NSOperation *dependency = nil;
    NSMutableData *file = [NSMutableData new];
    for (int i=0; i<[parts integerValue]; i++) {
        NSOperation *o = [WRequest getFile:filename partNumber:@(i) success:^(NSData *data, NSNumber *partNumber) {
            [file appendData:data];
//            DDLogInfo(@"File part n.%d downloaded out of %@ parts", [partNumber integerValue]+1, parts);
//            loading(([partNumber doubleValue] + 1.0) / [parts doubleValue]);
            if ([partNumber integerValue]+1 >= [parts  integerValue]) {
                success(file);
            }
        } loading:^(NSNumber *partNumber, double pourcentage) {
            loading(([partNumber doubleValue] + pourcentage) / [parts doubleValue]);
        } failure:^(id error) {
            [q cancelAllOperations];
            failure(error);
        }];
        if (dependency) {
            [o addDependency:dependency];
        }
        if (![dependency isCancelled]) {
            dependency = o;
            [q addOperation:o];
        }
    }
}

@end

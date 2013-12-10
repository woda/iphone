//
//  WRequest+Sync.m
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import "WRequest+Sync.h"
#import "NSString+Path.h"

@implementation WRequest (Sync)

+ (NSString *)sha256hash:(NSData *)data {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSData *sha256 = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    
    NSString *hash = [sha256 description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return (hash);
}


/* Creating a file Description: method to create a file in database. Call this method to create a file and then upload it.
 
 Method type: PUT
 URL: /sync
 Body parameters:
 filename: path
 content_hash: SHA256 hash of content
 size: content size
 
 Return:
 - If the content_hash already exists:
 {
 "success": true,
 "need_upload": false,
 "file": {
 << file's description >>
 }
 }
 - else
 {
 "success": true,
 "need_upload": true,
 "needed_parts":[0,1,2]
 "part_size": 5242880
 "file": {
 << file's description >>
 },
 
 }
 
 */

+ (void)addFile:(NSString *)filename
       withData:(NSData *)data
        success:(void (^)(id json))success
        loading:(void (^)(double pourcentage))loading
        failure:(void (^)(id error))failure
{
    [WRequest PUT:@"/sync"
       parameters:@{ @"filename": filename,
                     @"content_hash": [WRequest sha256hash:data],
                     @"size": @([data length]) }
          success:^(id json) {
              DDLogInfo(@"File created");
              if ([[json objectForKey:@"need_upload"] boolValue]) {
                  NSNumber *fileId = json[@"file"][@"id"];
                  NSNumber *partSize = json[@"file"][@"part_size"];
                  if ([partSize integerValue] <= 0) {
                      DDLogWarn(@"Warning: 'part_size' info is missing in json: %@", json);
                      partSize = @(5*1024*1024); // 5Mo
                  }
                  [WRequest uploadFile:fileId
                              partSize:partSize
                              withData:data
                               success:success
                               loading:loading
                               failure:failure];
              } else {
                  DDLogInfo(@"File arleady uploaded");
                  success(json);
              }
          } failure:failure];
}


/* Upload a file
 
 Description:
 Method to upload file's parts. You need to send parts of size "part_size" (which is given to you when you ask to add a file). The encryption is done on the server side, so just send it unencrypted. Part_size is typically 5 megs, but it could change don't hardcode it.
 The part number should be a number from 0 to the number of parts needed to store the file.
 Method type: PUT
 URL: /sync/{file id}/{part number}
 Body parameters: body: content of the file's part
 
 Return:
 {
 "needed_parts": [1,2], # empty if the file has been fully uploaded
 "uploaded":false, # value indicating if the FILE and not the part has been completely uploaded
 "success": true
 }
 
 */

+ (NSOperation *)uploadFile:(NSNumber *)fileId
                   withPart:(NSData *)part
                     number:(NSNumber *)partNumber
                    success:(void (^)(NSNumber *partNumber))success
                    loading:(void (^)(NSNumber *partNumber, double pourcentage))loading
                    failure:(void (^)(id error))failure
{
    NSString *path = [@"/sync/{file_id}/{part_number}" pathWithParams:@{ @"part_number": [partNumber stringValue], @"file_id": fileId }];
    
    NSMutableURLRequest *request = [[WRequest client] requestWithMethod:kPUT path:path parameters:nil];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:part];
    
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

+ (void)uploadFile:(NSNumber *)fileId
          partSize:(NSNumber *)partSize
          withData:(NSData *)data
           success:(void (^)(id json))success
           loading:(void (^)(double pourcentage))loading
           failure:(void (^)(id error))failure
{
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    NSOperation *dependency = nil;
    int parts = 1+((int)data.length / [partSize intValue]);
    for (int i=0, k=parts; i<k; i++) {
        NSData *d = [data subdataWithRange:NSMakeRange((i * [partSize integerValue]), MIN([partSize integerValue], (data.length - (i * [partSize integerValue]))))];
        
        NSOperation *o = [WRequest uploadFile:fileId withPart:d number:@(i) success:^(NSNumber *partNumber) {
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
        [WRequest comfirmUpload:fileId success:success failure:failure];
    }];
    if (dependency) {
        [o addDependency:dependency];
    }
    if (![dependency isCancelled]) {
        [q addOperation:o];
    }
}


/* Confirm upload
 
 Description: Method to confirm a file upload. Call it when you after sending all parts of a file. This method will return parts that need to be re-uploaded (if any) or just a { success: true }
 Method type: GET
 URL: /sync/{file id}
 Body parameters: none
 
 Return:
 {
 "needed_parts": [1,2], # empty if the file has been fully uploaded
 "uploaded":false, # value indicating if the FILE and not the part has been completely uploaded
 "success": true
 }
 
 */

+ (void)comfirmUpload:(NSNumber *)fileId
              success:(void (^)(id json))success
              failure:(void (^)(id error))failure
{
    [WRequest GET:[@"/sync/{file_id}" pathWithParams:@{ @"file_id": fileId }]
       parameters:nil
          success:^(id json) {
              DDLogInfo(@"File upload complete: %@", json);
              success(json);
          } failure:failure];
}


/* Create a new folder
 
 Description: method to create a new folder at the given path. you can create a whole path. If you create a whole hierarchy at once the method will just return the last created folder.
 Method type: POST
 URL: /sync_folder
 Body parameters: filename
 
 Call:
 curl -k -b cookies -c cookies -XPOST {BASE_URL}/sync_folder -d "filename=folder1/folder2/folder3"
 Return:
 {
 "folder": {
 "id": 28,
 "name": "folder3",
 "public": false,
 "favorite": false,
 "last_update": "2013-11-10T13:07:51+01:00"
 },
 "success": true
 }
 */

+ (void)createFolder:(NSString *)folder
             success:(void (^)(id json))success
             failure:(void (^)(id error))failure
{
    [WRequest POST:@"/sync_folder"
        parameters:@{ @"filename": folder }
           success:^(id json) {
               DDLogInfo(@"Folder created");
               success(json);
           } failure:failure];
}


/* Delete file/folder
 
 Description: method to delete a file OR a folder.
 Method type: DELETE
 URL: /sync/{id}
 Body parameters: none
 
 Return:
 {
 "success": true
 }
 
 */

+ (void)removeFile:(NSNumber *)fileId
           success:(void (^)(id json))success
           failure:(void (^)(id error))failure
{
    [WRequest DELETE:[@"/sync/{file_id}" pathWithParams:@{ @"file_id": fileId }]
          parameters:nil
             success:^(id json) {
                 DDLogInfo(@"File deleted: %@", json);
                 success(json);
             } failure:failure];
}

/* Change a file
 
 Description: Method to change file's informations. This is just a delete followed by a create, so it will return the same values as add can, but it can also have the same errors delete can.
 Method type: POST
 URL: /sync/({file id}
 Body parameters: none
 
 Return:
 {
 << Same return than the method to create a file into the Database >>
 }
 
 */

+ (void)updateFile:(NSNumber *)fileId
              name:(NSString *)filename
          withData:(NSData *)data
           success:(void (^)(id json))success
           loading:(void (^)(double pourcentage))loading
           failure:(void (^)(id error))failure
{
    [WRequest POST:[@"/sync/{file_id}" pathWithParams:@{ @"file_id": fileId }]
        parameters:@{ @"filename": filename,
                      @"content_hash": [WRequest sha256hash:data],
                      @"size": @([data length]) }
           success:^(id json) {
               DDLogInfo(@"File created: %@", json);
               if ([[json objectForKey:@"need_upload"] boolValue]) {
                   [WRequest uploadFile:fileId
                               partSize:[json objectForKey:@"part_size"]
                               withData:data
                                success:success
                                loading:loading
                                failure:failure];
               } else {
                   success(json);
               }
           } failure:failure];
}


/* Download a file
 
 Description: Method to get a file part after part. Returns only the file's DATA.
 Method type: GET
 URL: /sync/{file id}/{part number}
 Body parameters: none
 
 Return:
 {
 jerghgjYUGRGigedy......63UFCIUhieFR4FOR4G7RGIYERF
 }
 
 */

+ (NSOperation *)getFile:(NSNumber *)fileId
              partNumber:(NSNumber *)partNumber
                 success:(void (^)(NSData *data, NSNumber *partNumber))success
                 loading:(void (^)(NSNumber *partNumber, double pourcentage))loading
                 failure:(void (^)(id error))failure
{
    NSString *path = [@"/sync/{file_id}/{part_number}" pathWithParams:@{ @"part_number": [partNumber stringValue], @"file_id": fileId }];
    
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

+ (void)getFile:(NSNumber *)fileId
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
        NSOperation *o = [WRequest getFile:fileId partNumber:@(i) success:^(NSData *data, NSNumber *partNumber) {
            [file appendData:data];
            DDLogVerbose(@"File part n.%d downloaded out of %@ parts", [partNumber intValue]+1, parts);
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

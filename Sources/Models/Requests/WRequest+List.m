//
//  WRequest+List.m
//  Woda
//
//  Created by Théo LUBERT on 6/30/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest+List.h"
#import "NSString+Path.h"

@implementation WRequest (List)


/* Files and folders list
 
 Description: method to get all files and folders of the current user.
 Request type: GET
 URL: /files(/{file OR folder id})
 Body parameters: none
 
 id:
 - Do NOT give anything if you want to get the hierarchy starting from the root directory.
 - ID can be a folder's id that you want hierarchy to begin from.
 - You can specify a file id which will return to you the file's details.
 
 Return:
 {
 "folder": {
 "id": 40,
 "name": "/",
 "public": false,
 "favorite": false,
 "last_update": "2013-11-02T20:04:32+01:00",
 "folders": [
 {
 "id": 28,
 "name": "folder1",
 "public": false,
 "favorite": false,
 "last_update": "2013-11-02T19:34:35+01:00",
 "folders": [],
 "files": []
 }
 ],
 "files": [
 {
 << file's description >>
 },
 {
 << file's description >>
 }
 ]
 },
 "success": true
 }
 
 */

+ (void)file:(NSNumber *)fileId
     success:(void (^)(id json))success
     failure:(void (^)(id error))failure
{
    NSString *path = @"/files";
    if (fileId) {
        path = [@"/files/{fileId}" pathWithParams:@{ @"fileId": fileId }];
    }
    [WRequest GET:path
       parameters:nil
          success:success
          failure:failure];
}

+ (void)listAllFilesWithSuccess:(void (^)(id json))success
                        failure:(void (^)(id error))failure
{
    [WRequest file:nil success:success failure:failure];
}


/* Recent files list
 
 Description: method to get the user's recent files
 Method type: GET
 URL: /files/recents
 Body parameters: none
 
 Return:
 {
 "files": [
 {
 << file's description >>
 }
 ],
 "success": true
 }
 
 */

+ (void)listRecentFilesWithSuccess:(void (^)(id json))success
                            failure:(void (^)(id error))failure
{
    [WRequest GET:@"/files/recents"
       parameters:nil
          success:success
          failure:failure];
}


/* Favorite files list
 
 Description: method to get the user's favorite files
 Method type: GET
 URL: /files/favorites
 Body parameters: none
 
 {
 "files": [
 {
 << file's description >>
 }
 ],
 "success": true
 }
 
 */

+ (void)listFavoriteFilesWithSuccess:(void (^)(id json))success
                             failure:(void (^)(id error))failure
{
    [WRequest GET:@"/files/favorites"
       parameters:nil
          success:success
          failure:failure];
}


/* Set / Unset a file as favorite
 
 Description: method to set a user's file as favorite
 Method type: POST
 URL: /files/favorites/{file id}
 Body parameters: "favorite={true OR false}"
 
 Return:
 {
 "file": {
 << file's description >>
 },
 "success": true
 }
 
 */

+ (void)markFile:(NSNumber *)fileId
      asFavorite:(Boolean)favorite
         success:(void (^)(id json))success
         failure:(void (^)(id error))failure
{
    [WRequest POST:[@"/files/favorites/{fileId}" pathWithParams:@{ @"fileId": fileId }]
        parameters:@{@"favorite": (favorite) ? @"true" : @"false" }
           success:success
           failure:failure];
}

+ (void)markFileAsFavorite:(NSNumber *)fileId
                   success:(void (^)(id json))success
                   failure:(void (^)(id error))failure
{
    [WRequest markFile:fileId asFavorite:YES success:success failure:failure];
}

+ (void)unmarkFileAsFavorite:(NSNumber *)fileId
                     success:(void (^)(id json))success
                     failure:(void (^)(id error))failure
{
    [WRequest markFile:fileId asFavorite:NO success:success failure:failure];
}


/* Public files list
 
 Description: method to get the user's public files
 Method type: GET
 URL: /files/public
 Body parameters: none
 
 Return:
 {
 "files": [
 {
 <<file's description >>
 }
 ],
 "success": true
 }
 
 */

+ (void)listPublicFilesWithSuccess:(void (^)(id json))success
                           failure:(void (^)(id error))failure
{
    [WRequest GET:@"/files/public"
       parameters:nil
          success:success
          failure:failure];
}


/* Set / Unset a file as public
 
 Description: method to set a user's file as public
 Method type: POST
 URL: /files/public/{file id}
 Body parameters: "public={true OR false}"
 
 Return:
 {
 "file": {
 << file's description >>
 },
 "success": true
 }
 
 */

+ (void)markFile:(NSNumber *)fileId
        asPublic:(Boolean)public
         success:(void (^)(id json))success
         failure:(void (^)(id error))failure
{
    [WRequest POST:[@"/files/public/{fileId}" pathWithParams:@{ @"fileId": fileId }]
        parameters:@{@"public": (public) ? @"true" : @"false" }
           success:success
           failure:failure];
}

+ (void)markFileAsPublic:(NSNumber *)fileId
                 success:(void (^)(id json))success
                 failure:(void (^)(id error))failure
{
    [WRequest markFile:fileId asPublic:YES success:success failure:failure];
}

+ (void)unmarkFileAsPublic:(NSNumber *)fileId
                   success:(void (^)(id json))success
                   failure:(void (^)(id error))failure
{
    [WRequest markFile:fileId asPublic:NO success:success failure:failure];
}


/* Shared files list
 
 Description: method to get the user's shared files. A shared file is file which had its direct download link generated
 Method type: GET
 URL: /files/shared
 Body parameters: none
 
 Return:
 {
 "files": [
 {
 << file's description >>
 }
 ],
 "success": true
 }
 
 */

+ (void)listSharedFilesWithSuccess:(void (^)(id json))success
                           failure:(void (^)(id error))failure
{
    [WRequest GET:@"/files/shared"
       parameters:nil
          success:success
          failure:failure];
}


/* Get DDL link
 
 Description: method to get the direct download link of a file.
 Method type: GET
 URL: /files/link/{file id}
 Body parameters: none
 
 Return:
 {
 "link": "{BASE_URL}/app_dev.php/fs-file/dd8c2d49-1c3c-4622-b099-6b0f219bd818",
 "file": {
 << file's description >>
 },
 "success": true
 }
 
 */

+ (void)directDownloadLinkForFile:(NSNumber *)fileId
                          success:(void (^)(id json))success
                          failure:(void (^)(id error))failure
{
    [WRequest GET:[@"/files/link/{fileId}" pathWithParams:@{ @"fileId": fileId }]
       parameters:nil
          success:success
          failure:failure];
}


/* Downloaded files list
 
 Description: method to get the user's downloaded files
 Method type: GET
 URL: /files/downloaded
 Body parameters: none
 
 Return:
 {
 "files": [
 {
 << file's description >>
 }
 ],
 "success": true
 }
 
 */

+ (void)listDownloadedFilesWithSuccess:(void (^)(id json))success
                               failure:(void (^)(id error))failure
{
    [WRequest GET:@"/files/downloaded"
       parameters:nil
          success:success
          failure:failure];
}

@end

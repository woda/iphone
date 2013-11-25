//
//  WRequest+User.m
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"
#import "NSString+Path.h"

@implementation WRequest (User)


/* Create
 
 Description: method to create and log a new user in.
 Method type: PUT
 URL: /users/{login}
 Body parameters: "password={password}&email={email}"
 
 Return:
 {
 "success": true,
 "user": << User's description >>
 }
 
 */

+ (void)createUser:(NSString *)login
         firstName:(NSString *)first_name
          lastName:(NSString *)last_name
          password:(NSString *)password
             email:(NSString *)email
           success:(void (^)(id json))success
           failure:(void (^)(id json))failure
{
    [WRequest PUT:[@"/users/{login}" pathWithParams:@{ @"login":login }]
       parameters:@{ @"first_name": first_name,
                     @"last_name": last_name,
                     @"password": password,
                     @"email": email }
          success:success
          failure:failure];
}


/* Update
 
 Description: method to update the current user
 Method type: POST
 URL: /users
 Body parameters: "password={new_password}&email={new_email}"
 
 Parameters are optional, you can't just send one of these
 
 Return:
 {
 "success": true,
 "user": << User's description >>
 }
 
 */

+ (void)updateUserWithFirstName:(NSString *)first_name
                       lastName:(NSString *)last_name
                       password:(NSString *)password
                          email:(NSString *)email
                        success:(void (^)(id json))success
                        failure:(void (^)(id json))failure
{
    [WRequest POST:@"/users"
        parameters:@{ @"first_name": first_name,
                      @"last_name": last_name,
                      @"password": password,
                      @"email": email }
           success:success
           failure:failure];
}


/* Read
 
 Description: method to get the information of the current user
 Method type: GET
 URL: /users
 Body parameters: none
 
 Return:
 {
 "success": true,
 "user": << User's description >>
 }
 
 */

+ (void)userSuccess:(void (^)(id json))success
            failure:(void (^)(id json))failure
{
    [WRequest GET:@"/users"
       parameters:nil
          success:success
          failure:failure];
}


/* Delete
 
 Description: method to delete the current user
 Method type: DELETE
 URL: /users
 Body parameters: none
 
 Return:
 {
 "success": true
 }
 
 */

+ (void)deleteUserSuccess:(void (^)(id json))success
                  failure:(void (^)(id json))failure
{
    [WRequest DELETE:@"/users"
          parameters:nil
             success:success
             failure:failure];
}


/* Login
 
 Description: method to log a user in
 Method type: POST
 URL: /users/{user}/login
 Body parameters: "password={password}"
 
 Return:
 {
 "success": true,
 "user": << User's description >>
 }
 
 */

+ (void)login:(NSString *)login
     password:(NSString *)password
      success:(void (^)(id json))success
      failure:(void (^)(id json))failure
{
    [WRequest POST:[@"/users/{login}/login" pathWithParams:@{ @"login": login }]
        parameters:@{ @"password": password }
           success:success
           failure:failure];
}


/* Logout
 
 Description: method to logout the current user
 Method type: GET
 URL: /users/logout
 Body parameters: none
 
 Return:
 {
 "success": true
 }
 
 */

+ (void)logoutSuccess:(void (^)(id json))success
              failure:(void (^)(id json))failure
{
    [WRequest GET:@"/users/logout"
       parameters:nil
          success:success
          failure:failure];
}

@end

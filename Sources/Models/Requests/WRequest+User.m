//
//  WRequest+User.m
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"

@implementation WRequest (User)

//Create
//
//To create a user, use a PUT request to the url:
//https://{base}:3000/users/{login}
//With body parameters:
//first_name={first_name}&
//last_name={last_name}&
//password={password}&
//email={email}
//
//This will return a JSON representation of the user. This has the side effect of logging that user in.

+ (void)createUser:(NSString *)login
         firstName:(NSString *)first_name
          lastName:(NSString *)last_name
          password:(NSString *)password
             email:(NSString *)email
           success:(void (^)(id json))success
           failure:(void (^)(id json))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:first_name forKey:@"first_name"];
    [params setValue:last_name forKey:@"last_name"];
    [params setValue:password forKey:@"password"];
    [params setValue:email forKey:@"email"];
    
    NSString *path = [@"/users/{login}" stringByReplacingOccurrencesOfString:@"{login}" withString:login];
    
    [WRequest requestWithMethod:@"PUT" path:path parameters:params success:success failure:failure];
}

//Update
//
//To update yourself (of course you can only update yourself), use a POST request to the url:
//https://{base}:3000/users
//With any of the body parameters you can use for creation.
//
//This will return a JSON representation of yourself.

+ (void)updateUserWithFirstName:(NSString *)first_name
                       lastName:(NSString *)last_name
                       password:(NSString *)password
                          email:(NSString *)email
                        success:(void (^)(id json))success
                        failure:(void (^)(id json))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:first_name forKey:@"first_name"];
    [params setValue:last_name forKey:@"last_name"];
    [params setValue:password forKey:@"password"];
    [params setValue:email forKey:@"email"];
    
    NSString *path = @"/users";
    
    [WRequest requestWithMethod:@"POST" path:path parameters:params success:success failure:failure];
}


//Read
//
//To get a JSON representation of yourself, use a GET request to the url:
//https://{base}:3000/users
//
//This will return a JSON representation of yourself.

+ (void)userSuccess:(void (^)(id json))success
            failure:(void (^)(id json))failure
{
    NSString *path = @"/users";
    
    [WRequest requestWithMethod:@"GET" path:path parameters:nil success:success failure:failure];
}


//Delete
//
//To delete yourself, use a DELETE request to the url:
//https://{base}:3000/users
//
//This will return {"success": true} if the delete was successful.

+ (void)deleteUserSuccess:(void (^)(id json))success
                  failure:(void (^)(id json))failure
{
    NSString *path = @"/users";
    
    [WRequest requestWithMethod:@"DELETE" path:path parameters:nil success:success failure:failure];
}


//Login
//
//To login, use a POST request:
//https://{base}:3000/users/{login}/login
//With:
//password={password}
//as body parameter.
//
//This will return a JSON representation of yourself.

+ (void)login:(NSString *)login
     password:(NSString *)password
      success:(void (^)(id json))success
      failure:(void (^)(id json))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:password forKey:@"password"];
    
    NSString *path = [@"/users/{login}/login" stringByReplacingOccurrencesOfString:@"{login}" withString:login];
    
    [WRequest requestWithMethod:@"POST" path:path parameters:params success:success failure:failure];
}


//Logout
//
//To logout, use a GET or post request to:
//https://{base}:3000/users/logout
//
//This will return {"success": true}

+ (void)logoutSuccess:(void (^)(id json))success
              failure:(void (^)(id json))failure
{
    NSString *path = @"/users/logout";
    
    [WRequest requestWithMethod:@"GET" path:path parameters:nil success:success failure:failure];
}

@end

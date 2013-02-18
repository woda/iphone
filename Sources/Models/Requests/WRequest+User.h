//
//  WRequest+User.h
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"

@interface WRequest (User)

+ (void)createUser:(NSString *)login
         firstName:(NSString *)first_name
          lastName:(NSString *)last_name
          password:(NSString *)password
             email:(NSString *)email
           success:(void (^)(id json))success
           failure:(void (^)(id json))failure;

+ (void)updateUserWithFirstName:(NSString *)first_name
                       lastName:(NSString *)last_name
                       password:(NSString *)password
                          email:(NSString *)email
                        success:(void (^)(id json))success
                        failure:(void (^)(id json))failure;

+ (void)userSuccess:(void (^)(id json))success failure:(void (^)(id json))failure;
+ (void)deleteUserSuccess:(void (^)(id json))success failure:(void (^)(id json))failure;
+ (void)login:(NSString *)login password:(NSString *)password success:(void (^)(id json))success failure:(void (^)(id json))failure;
+ (void)logoutSuccess:(void (^)(id json))success failure:(void (^)(id json))failure;

@end

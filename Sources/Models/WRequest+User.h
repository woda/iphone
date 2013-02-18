//
//  WRequest+User.h
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequest.h"

@interface WRequest (User)

+ (void)createUser:(NSString *)login firstName:(NSString *)first_name lastName:(NSString *)last_name password:(NSString *)password email:(NSString *)email;
+ (void)updateUserWithFirstName:(NSString *)first_name lastName:(NSString *)last_name password:(NSString *)password email:(NSString *)email;
+ (void)user;
+ (void)deleteUser;
+ (void)login:(NSString *)login password:(NSString *)password;
+ (void)logout;

@end

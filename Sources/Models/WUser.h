//
//  WUser.h
//  Woda
//
//  Created by Théo LUBERT on 2/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserLoginKey       @"kUserLoginKey"
#define kUserPasswordKey    @"kUserPasswordKey"
#define kUserServerKey      @"kUserServerKey"

#define kUserStatusChanged  @"kUserStatusChanged"
#define kUserInfoChanged    @"kUserInfoChanged"

@interface WUser : NSObject

typedef enum {
    NotConnected = 0,
    Connecting,
    Connected
} UserStatus;

@property (nonatomic, assign) UserStatus    status;

@property (nonatomic, retain) NSString      *login;
@property (nonatomic, retain) NSString      *firstName;
@property (nonatomic, retain) NSString      *lastName;
@property (nonatomic, retain) NSString      *email;

+ (void)logout;
+ (WUser *)current;
+ (void)connectWithLogin:(NSString *)login andPassword:(NSString *)password;
+ (void)signup:(NSString *)login
     firstName:(NSString *)first_name
      lastName:(NSString *)last_name
      password:(NSString *)password
         email:(NSString *)email;
+ (void)editWithFirstName:(NSString *)first_name
                 lastName:(NSString *)last_name
                 password:(NSString *)password
                    email:(NSString *)email;

@end

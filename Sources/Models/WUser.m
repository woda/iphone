//
//  WUser.m
//  Woda
//
//  Created by Théo LUBERT on 2/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUser.h"
#import "WRequest+User.h"

static WUser *current = nil;

@implementation WUser


# pragma mark - Shared methods

+ (void)logout {
    [WRequest logoutSuccess:^(id json) {
        NSLog(@"Logout successful: %@", json);
        [[WUser current] setStatus:NotConnected];
    } failure:^(id json) {
        NSLog(@"Logout error: %@", json);
    }];
}

+ (WUser *)current {
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    if ((current == nil) && ([userDefault valueForKey:kUserLoginKey])) {
//        current = [[WUser alloc] initWithLogin:[userDefault valueForKey:kUserLoginKey]
//                                   andPassword:[userDefault valueForKey:kUserPasswordKey]];
//    }
    return (current);
}

+ (void)connectWithLogin:(NSString *)login andPassword:(NSString *)password {
    (void)[[WUser alloc] initWithLogin:login andPassword:password];
}

+ (void)signup:(NSString *)login
     firstName:(NSString *)first_name
      lastName:(NSString *)last_name
      password:(NSString *)password
         email:(NSString *)email
{
    current = [[WUser alloc] init];
    [current setLogin:login];
    [current setStatus:Connecting];
    
    [WRequest createUser:login firstName:first_name lastName:last_name password:password email:email success:^(id json) {
        NSLog(@"Sign up successful: %@", json);
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:login forKey:kUserLoginKey];
        [userDefault setValue:password forKey:kUserPasswordKey];
        
        [current updateUserInfo:json];
        [current setStatus:Connected];
    } failure:^(id json) {
        NSLog(@"Sign up error: %@", json);
        [current setStatus:NotConnected];
    }];
}


#pragma mark - Initialization methods

- (id)initWithLogin:(NSString *)login andPassword:(NSString *)password {
    if ((self = [super init])) {
        current = self;
        [self setLogin:login];
        [self setStatus:Connecting];
        [WRequest login:[self login] password:password success:^(id json) {
            NSLog(@"Login successful: %@", json);
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setValue:_login forKey:kUserLoginKey];
            [userDefault setValue:password forKey:kUserPasswordKey];
            
            [self updateUserInfo:json];
            [self setStatus:Connected];
        } failure:^(id json) {
            NSLog(@"Login error: %@", json);
            [self setStatus:NotConnected];
        }];
    }
    return (self);
}

#pragma mark - Update methods

- (void)setStatus:(UserStatus)status {
    if (_status != status) {
        _status = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserStatusChanged object:nil];
    } else {
        _status = status;
    }
}

- (void)updateUserInfo:(NSDictionary *)json {
    if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"login"]) {
        [self setLogin:[json objectForKey:@"login"]];
        [self setFirstName:[json objectForKey:@"first_name"]];
        [self setLastName:[json objectForKey:@"last_name"]];
        [self setEmail:[json objectForKey:@"email"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserStatusChanged object:nil];
    }
}

@end

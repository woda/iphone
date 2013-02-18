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

+ (void)createUser:(NSString *)login firstName:(NSString *)first_name lastName:(NSString *)last_name password:(NSString *)password email:(NSString *)email {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:first_name forKey:@"first_name"];
    [params setValue:last_name forKey:@"last_name"];
    [params setValue:password forKey:@"password"];
    [params setValue:email forKey:@"email"];
    
    [[WRequest client] putPath:[@"/users/{login}" stringByReplacingOccurrencesOfString:@"{login}" withString:login] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"User created: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}

//Update
//
//To update yourself (of course you can only update yourself), use a POST request to the url:
//https://{base}:3000/users
//With any of the body parameters you can use for creation.
//
//This will return a JSON representation of yourself.

+ (void)updateUserWithFirstName:(NSString *)first_name lastName:(NSString *)last_name password:(NSString *)password email:(NSString *)email {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:first_name forKey:@"first_name"];
    [params setValue:last_name forKey:@"last_name"];
    [params setValue:password forKey:@"password"];
    [params setValue:email forKey:@"email"];
    
    [[WRequest client] postPath:@"/users" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"User updated: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}


//Read
//
//To get a JSON representation of yourself, use a GET request to the url:
//https://{base}:3000/users
//
//This will return a JSON representation of yourself.

+ (void)user {
    [[WRequest client] getPath:@"/users" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"User: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}


//Delete
//
//To delete yourself, use a DELETE request to the url:
//https://{base}:3000/users
//
//This will return {"success": true} if the delete was successful.

+ (void)deleteUser {
    [[WRequest client] deletePath:@"/users" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"User deleted: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
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

+ (void)login:(NSString *)login password:(NSString *)password {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:password forKey:@"password"];
    
    [[WRequest client] postPath:[@"/users/{login}/login" stringByReplacingOccurrencesOfString:@"{login}" withString:login] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"User logged succefully: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}


//Logout
//
//To logout, use a GET or post request to:
//https://{base}:3000/users/logout
//
//This will return {"success": true}

+ (void)logout {
    [[WRequest client] getPath:@"/users/logout" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [WRequest JSONFromData:responseObject];
        if ([json isKindOfClass:[NSError class]]) {
            [WRequest displayError:(NSError *)json forOperation:operation];
        } else {
            NSLog(@"User logged out: %@", json);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WRequest displayError:error forOperation:operation];
    }];
}

@end

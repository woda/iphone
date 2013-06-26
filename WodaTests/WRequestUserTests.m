//
//  WRequestUserTests.m
//  Woda
//
//  Created by Théo LUBERT on 2/18/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequestUserTests.h"
#import "WRequest+User.h"


@implementation WRequestUserTests


- (void)verifyUserData:(NSDictionary *)json {
    STAssertTrue(([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"login"]), @"JSON format invalid: %@", json);
    if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"login"]) {
        STAssertEqualObjects(_login, [json objectForKey:@"login"], @"login does not match");
        STAssertEqualObjects([json objectForKey:@"first_name"], _firstName, @"firstName does not match");
        STAssertEqualObjects([json objectForKey:@"last_name"], _lastName, @"lastName does not match");
        STAssertEqualObjects([json objectForKey:@"email"], _email, @"email does not match");
    }
}

- (void)setUp {
    [super setUp];
//    [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
    _login = @"test"; // Never test1 please (login used for dev)
    _firstName = @"unit";
    _lastName = @"test";
    _password = @"password";
    _email = @"test@woda.com";
}

- (void)tearDown {
    [super tearDown];
}


# pragma mark - Tests

- (void)test01Create {
    kInitWait;
    
    [WRequest createUser:_login firstName:_firstName lastName:_lastName password:_password email:_email success:^(NSDictionary *json) {
        [self verifyUserData:json];
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)test02Login {
    kInitWait;
    
    [WRequest login:_login password:_password success:^(NSDictionary *json) {
        [self verifyUserData:json];
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)test03GetInfo {
    [self test02Login];
    
    kInitWait;
    
    [WRequest userSuccess:^(NSDictionary *json) {
        [self verifyUserData:json];
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

//- (void)test04UpdateFirstName {
//    [self test02Login];
//    
//    kInitWait;
//    
//    _firstName = @"foo";
//    [WRequest updateUserWithFirstName:_firstName lastName:nil password:nil email:nil success:^(NSDictionary *json) {
//        [self verifyUserData:json];
//        kStopWait;
//    } failure:^(id json) {
//        STFail(@"Error: %@", json);
//        kStopWait;
//    }];
//    
//    kWait;
//}
//
//- (void)test05UpdateLastName {
//    [self test02Login];
//    
//    kInitWait;
//    
//    _lastName = @"bar";
//    [WRequest updateUserWithFirstName:nil lastName:_lastName password:nil email:nil success:^(NSDictionary *json) {
//        [self verifyUserData:json];
//        kStopWait;
//    } failure:^(id json) {
//        STFail(@"Error: %@", json);
//        kStopWait;
//    }];
//    
//    kWait;
//}
//
//- (void)test06UpdatePassword {
//    [self test02Login];
//    
//    kInitWait;
//    
//    _password = @"new_password";
//    [WRequest updateUserWithFirstName:nil lastName:nil password:_password email:nil success:^(NSDictionary *json) {
//        [self verifyUserData:json];
//        kStopWait;
//    } failure:^(id json) {
//        STFail(@"Error: %@", json);
//        kStopWait;
//    }];
//    
//    kWait;
//}
//
//- (void)test07UpdateEmail {
//    [self test02Login];
//    
//    // Invalid email
//    kInitWait;
//    
//    _email = @"none";
//    [WRequest updateUserWithFirstName:nil lastName:nil password:nil email:_email success:^(NSDictionary *json) {
//        STAssertTrue(([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"error"]), @"JSON format invalid: %@", json);
//        if ([json isKindOfClass:[NSDictionary class]] && [json objectForKey:@"login"]) {
//            STAssertEqualObjects(kInvalidEmail, [json objectForKey:@"error"], @"email is supposed to be invalid");
//        }
//        kStopWait;
//    } failure:^(id json) {
//        STFail(@"Error: %@", json);
//        kStopWait;
//    }];
//    
//    kWait;
//    
//    // Vaild email
//    kStartWait;
//    
//    _email = @"no-reply@woda.com";
//    [WRequest updateUserWithFirstName:nil lastName:nil password:nil email:_email success:^(NSDictionary *json) {
//        [self verifyUserData:json];
//        kStopWait;
//    } failure:^(id json) {
//        STFail(@"Error: %@", json);
//        kStopWait;
//    }];
//    
//    kWait;
//}

- (void)test08Logout {
    [self test02Login];
    
    kInitWait;
    
    [WRequest logoutSuccess:^(NSDictionary *json) {
        
        STAssertTrue([json isKindOfClass:[NSDictionary class]], @"JSON format invalid: %@", json);
        if ([json isKindOfClass:[NSDictionary class]]) {
            STAssertTrue([[json objectForKey:@"success"] boolValue], @"Log out failure");
        }
        
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)test09Delete {
    [self test02Login];
    
    kInitWait;
    
    [WRequest deleteUserSuccess:^(NSDictionary *json) {
        
        STAssertTrue([json isKindOfClass:[NSDictionary class]], @"JSON format invalid: %@", json);
        if ([json isKindOfClass:[NSDictionary class]]) {
            STAssertTrue([[json objectForKey:@"success"] boolValue], @"Delete failure");
        }
        
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

@end

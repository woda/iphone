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
        STAssertEquals(_login, [json objectForKey:@"login"], @"login does not match");
        STAssertEquals(_firstName, [json objectForKey:@"first_name"], @"firstName does not match");
        STAssertEquals(_lastName, [json objectForKey:@"last_name"], @"lastName does not match");
        STAssertEquals(_email, [json objectForKey:@"email"], @"email does not match");
    }
}

- (void)setUp {
    [super setUp];
    
    _login = @"test1";
    _firstName = @"1";
    _lastName = @"test";
    _password = @"password";
    _email = @"none";
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

- (void)test04UpdateFirstName {
    [self test02Login];
    
    kInitWait;
    
    _firstName = @"foo";
    [WRequest updateUserWithFirstName:_firstName lastName:nil password:nil email:nil success:^(NSDictionary *json) {
        [self verifyUserData:json];
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)test05UpdateLastName {
    [self test02Login];
    
    kInitWait;
    
    _lastName = @"bar";
    [WRequest updateUserWithFirstName:nil lastName:_lastName password:nil email:nil success:^(NSDictionary *json) {
        [self verifyUserData:json];
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)test06UpdatePassword {
    [self test02Login];
    
    kInitWait;
    
    _password = @"new_password";
    [WRequest updateUserWithFirstName:nil lastName:nil password:_password email:nil success:^(NSDictionary *json) {
        [self verifyUserData:json];
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)test07UpdateEmail {
    [self test02Login];
    
    kInitWait;
    
    _email = @"test@woda.com";
    [WRequest updateUserWithFirstName:nil lastName:nil password:nil email:_email success:^(NSDictionary *json) {
        [self verifyUserData:json];
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)test08Logout {
    [self test02Login];
    
    kInitWait;
    
    [WRequest logoutSuccess:^(NSDictionary *json) {
        
        STAssertFalse([json isKindOfClass:[NSDictionary class]], @"JSON format invalid: %@", json);
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
        
        STAssertFalse([json isKindOfClass:[NSDictionary class]], @"JSON format invalid: %@", json);
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

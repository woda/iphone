//
//  WRequestListTests.m
//  Woda
//
//  Created by Théo LUBERT on 6/30/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequestListTests.h"
#import "WRequest+User.h"
#import "WRequest+List.h"


@implementation WRequestListTests

- (void)createUser {
    kInitWait;
    
    _firstName = @"unit";
    _lastName = @"test";
    _email = @"userListTest@woda.com";
    
    [WRequest createUser:_login firstName:_firstName lastName:_lastName password:_password email:_email success:^(NSDictionary *json) {
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)setUp {
    [super setUp];
    
    _filename = @"Default-568h@2x";
    _fileExtension = @"png";
    
    _login = @"userListTest"; // Never test1 please (login used for dev)
    _password = @"password";
    
//    [self createUser];
    
    kInitWait;
    
    [WRequest login:_login password:_password success:^(NSDictionary *json) {
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)test01ListFiles {
    kInitWait;
    
    [WRequest listAllFilesWithSuccess:^(NSDictionary *json) {
        NSLog(@"list: %@", json);
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

//- (void)test02FilesInDirectory {
//    kInitWait;
//    
//    [WRequest listFilesInDir:@"/testDir" success:^(NSDictionary *json) {
//        NSLog(@"list: %@", json);
//        kStopWait;
//    } failure:^(id json) {
//        STFail(@"Error: %@", json);
//        kStopWait;
//    }];
//    
//    kWait;
//}

- (void)test03RecentFiles {
    kInitWait;
    
    [WRequest lastUpdatedFilesWithSuccess:^(NSDictionary *json) {
        NSLog(@"list: %@", json);
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

- (void)test04FavoriteFiles {
    kInitWait;
    
    [WRequest lastFavoriteFilesWithSuccess:^(NSDictionary *json) {
        NSLog(@"list: %@", json);
        kStopWait;
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        kStopWait;
    }];
    
    kWait;
}

//- (void)test05MarkAsFavorite {
//    kInitWait;
//    
//    [WRequest markFileAsFavorite:@42 success:^(NSDictionary *json) {
//        NSLog(@"list: %@", json);
//        kStopWait;
//    } failure:^(id json) {
//        STFail(@"Error: %@", json);
//        kStopWait;
//    }];
//    
//    kWait;
//}
//
//- (void)test06UnmarkAsFavorite {
//    kInitWait;
//    
//    [WRequest unmarkFileAsFavorite:@42 success:^(NSDictionary *json) {
//        NSLog(@"list: %@", json);
//        kStopWait;
//    } failure:^(id json) {
//        STFail(@"Error: %@", json);
//        kStopWait;
//    }];
//    
//    kWait;
//}

@end

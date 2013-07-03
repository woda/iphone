//
//  WRequestListTests.m
//  Woda
//
//  Created by Théo LUBERT on 6/30/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequestListTests.h"
#import "WRequest+User.h"
#import "WRequest+Sync.h"
#import "WRequest+List.h"
#import "NSArray+Shortcuts.h"


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
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
    [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
}

- (void)test01EmptyListFiles {
    kInitWait;
    
    [WRequest listAllFilesWithSuccess:^(NSDictionary *json) {
        STAssertTrue([json isKindOfClass:[NSDictionary class]], @"Should return an dictionary");
        NSLog(@"files: %@", [json objectForKey:@"files"]);
        STAssertTrue([[json objectForKey:@"files"] count] == 0, @"Should be empty");
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)test02EmptyRecentFiles {
    kInitWait;
    
    [WRequest listUpdatedFilesWithSuccess:^(NSArray *list) {
        NSLog(@"list: %@", list);
        STAssertTrue([list isKindOfClass:[NSArray class]], @"Should return an array");
        STAssertTrue([list count] == 0, @"Should be empty");
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)test03EmptyFavoriteFiles {
    kInitWait;
    
    [WRequest listFavoriteFilesWithSuccess:^(NSArray *list) {
        NSLog(@"list: %@", list);
        STAssertTrue([list isKindOfClass:[NSArray class]], @"Should return an array");
        STAssertTrue([list count] == 0, @"Should be empty");
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)addFile {
    kInitWait;
    
    NSString *filename = [_filename stringByAppendingFormat:@".%@", _fileExtension];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:_filename ofType:_fileExtension];
    NSData *file = [NSData dataWithContentsOfFile:filePath];
    
    [WRequest addFile:filename withData:file success:^(id json) {
        kStopWait;
    } loading:^(double pourcentage) {
        NSLog(@"Loading \"%@\": %.0f%%", filename, pourcentage * 100);
    } failure:^(id error) {
        kStopWait;
    }];
    
    kWait;
}

- (void)test04ListFiles {
    [self addFile];
    
    kInitWait;
    
    [WRequest listAllFilesWithSuccess:^(NSDictionary *json) {
        STAssertTrue([json isKindOfClass:[NSDictionary class]], @"Should return an dictionary");
        NSLog(@"files: %@", [json objectForKey:@"files"]);
        STAssertTrue([[json objectForKey:@"files"] count] > 0, @"Should contain a file");
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

//- (void)test05FilesInDirectory {
//    kInitWait;
//    
//    [WRequest listFilesInDir:@"/testDir" success:^(NSDictionary *json) {
//        NSLog(@"list: %@", json);
//        kStopWait;
//    } failure:^(id error) {
//        STFail(@"Error: %@", error);
//        kStopWait;
//    }];
//    
//    kWait;
//}

- (void)test06RecentFiles {
    kInitWait;
    
    [WRequest listUpdatedFilesWithSuccess:^(NSArray *list) {
        NSLog(@"list: %@", list);
        STAssertTrue([list isKindOfClass:[NSArray class]], @"Should return an array");
        STAssertTrue([list count] > 0, @"Should contain a file");
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)test07FavoriteFiles {
    kInitWait;
    
    [WRequest listFavoriteFilesWithSuccess:^(NSArray *list) {
        NSLog(@"list: %@", list);
        STAssertTrue([list isKindOfClass:[NSArray class]], @"Should return an array");
        STAssertTrue([list count] == 0, @"Should be empty");
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)test08MarkAsFavorite {
    kInitWait;
    
    [WRequest listUpdatedFilesWithSuccess:^(NSArray *list) {
        NSNumber *idNumber = [[list lastObject] objectForKey:@"id"];
        [WRequest markFileAsFavorite:idNumber success:^(NSDictionary *json) {
            STAssertTrue([[json objectForKey:@"favorite"] boolValue], @"File should be found in favorites");
            kStopWait;
        } failure:^(id error) {
            STFail(@"Error: %@", error);
            kStopWait;
        }];
    } failure:^(id error) {
        STAssertTrue([error isKindOfClass:[NSDictionary class]], @"Should return an dictionary");
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)test09UnmarkAsFavorite {
    kInitWait;
    
    [WRequest listUpdatedFilesWithSuccess:^(NSArray *list) {
        NSNumber *idNumber = [[list lastObject] objectForKey:@"id"];
        [WRequest unmarkFileAsFavorite:idNumber success:^(NSDictionary *json) {
            STAssertFalse([[json objectForKey:@"favorite"] boolValue], @"File should not be found in favorites");
            kStopWait;
        } failure:^(id error) {
            STFail(@"Error: %@", error);
            kStopWait;
        }];
    } failure:^(id error) {
        STAssertTrue([error isKindOfClass:[NSDictionary class]], @"Should return an dictionary");
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)test10RemoveFile {
    kInitWait;
    
    NSString *filename = [_filename stringByAppendingFormat:@".%@", _fileExtension];
    [WRequest removeFile:filename success:^(id error) {
        kStopWait;
    } failure:^(id error) {
        kStopWait;
    }];
    
    kWait;
}


@end

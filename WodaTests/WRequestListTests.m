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

static NSNumber *fileId = nil;

@implementation WRequestListTests

- (void)createUser {
    kInitWait;
    
    _firstName = @"unit";
    _lastName = @"test";
    _email = @"unit_test@woda.com";
    
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
    
    _login = @"unit_test"; // Never test1 please (login used for dev)
    _password = @"password";
    
    kInitWait;
    
    [WRequest login:_login password:_password success:^(NSDictionary *json) {
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        
//        [self createUser];
        kStopWait;
    }];
    
    kWait;
//    [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
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
    
    [WRequest listRecentFilesWithSuccess:^(NSArray *list) {
        if ([list isKindOfClass:[NSDictionary class]])
            list = [(NSDictionary *)list objectForKey:@"files"];
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
        if ([list isKindOfClass:[NSDictionary class]])
            list = [(NSDictionary *)list objectForKey:@"files"];
        NSLog(@"favoris: %@", list);
        STAssertTrue([list isKindOfClass:[NSArray class]], @"Should return an array");
        STAssertTrue([list count] == 0, @"Should be empty");
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)test04EmptySharedFiles {
//    kInitWait;
//    
//    [WRequest listSharedFilesWithSuccess:^(NSArray *list) {
//        NSLog(@"shared: %@", list);
//        STAssertTrue([list isKindOfClass:[NSArray class]], @"Should return an array");
//        STAssertTrue([list count] == 0, @"Should be empty");
//        kStopWait;
//    } failure:^(id error) {
//        STFail(@"Error: %@", error);
//        kStopWait;
//    }];
//    
//    kWait;
}

- (void)test05EmptyPublicFiles {
    kInitWait;
    
    [WRequest listPublicFilesWithSuccess:^(NSArray *list) {
        if ([list isKindOfClass:[NSDictionary class]])
            list = [(NSDictionary *)list objectForKey:@"files"];
        NSLog(@"public: %@", list);
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
        fileId = json[@"file"][@"id"];
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
        NSLog(@"files: %@", json[@"folder"][@"files"]);
        STAssertTrue([json[@"folder"][@"files"] count] > 0, @"Should contain a file");
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
    
    [WRequest listRecentFilesWithSuccess:^(NSArray *list) {
        if ([list isKindOfClass:[NSDictionary class]])
            list = [(NSDictionary *)list objectForKey:@"files"];
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
        if ([list isKindOfClass:[NSDictionary class]])
            list = [(NSDictionary *)list objectForKey:@"files"];
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
    
    [WRequest listRecentFilesWithSuccess:^(NSArray *list) {
        if ([list isKindOfClass:[NSDictionary class]])
            list = [(NSDictionary *)list objectForKey:@"files"];
        NSNumber *idNumber = [[list lastObject] objectForKey:@"id"];
        [WRequest markFileAsFavorite:idNumber success:^(NSDictionary *json) {
            STAssertTrue([json[@"file"][@"favorite"] boolValue], @"File should be found in favorites");
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
    
    [WRequest listRecentFilesWithSuccess:^(NSArray *list) {
        if ([list isKindOfClass:[NSDictionary class]])
            list = [(NSDictionary *)list objectForKey:@"files"];
        NSNumber *idNumber = [[list lastObject] objectForKey:@"id"];
        [WRequest unmarkFileAsFavorite:idNumber success:^(NSDictionary *json) {
            STAssertFalse([json[@"file"][@"favorite"] boolValue], @"File should not be found in favorites");
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
    
    STAssertNotNil(fileId, @"File id must be set");
    if (fileId) {
        [WRequest removeFile:fileId success:^(id error) {
            kStopWait;
        } failure:^(id error) {
            STAssertNil(error, @"Removing file failure");
            kStopWait;
        }];
        
        kWait;
    }
}


@end

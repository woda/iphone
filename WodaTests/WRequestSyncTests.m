//
//  WRequestSyncTests.m
//  Woda
//
//  Created by Théo LUBERT on 6/24/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequestSyncTests.h"
#import "WRequest+User.h"
#import "WRequest+Sync.h"

@implementation WRequestSyncTests


- (void)createUser {
    kInitWait;
    
    _firstName = @"unit";
    _lastName = @"test";
    _email = @"userSyncTest@woda.com";
    
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
    
    _login = @"userSyncTest"; // Never test1 please (login used for dev)
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

- (void)tearDown {
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
    
    [super tearDown];
}


# pragma mark - Tests

- (void)test01AddFile {
    kInitWait;
    
//    NSString *filename = @"Default-568h@2x.png";
    NSString *filename = [_filename stringByAppendingFormat:@".%@", _fileExtension];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:_filename ofType:_fileExtension];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    NSData *file = UIImagePNGRepresentation(image);
//    NSData *file = [NSData dataWithContentsOfFile:filePath];
    
//    [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
//    [[AFHTTPRequestOperationLogger sharedLogger] stopLogging];
    [WRequest addFile:filename withData:file success:^(id json) {
        STAssertTrue(([json isKindOfClass:[NSDictionary class]]), @"JSON format invalid: %@", json);
        _parts = [(NSDictionary *)json objectForKey:@"parts"];
        kStopWait;
    } loading:^(double pourcentage) {
        NSLog(@"Loading \"%@\": %.0f%%", filename, pourcentage * 100);
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)test02GetFile {
    kInitWait;
    
    NSString *filename = [_filename stringByAppendingFormat:@".%@", _fileExtension];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:_filename ofType:_fileExtension];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    NSData *file = UIImagePNGRepresentation(image);
//    NSData *file = [NSData dataWithContentsOfFile:filePath];
    
//    [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
//    [[AFHTTPRequestOperationLogger sharedLogger] stopLogging];
    [WRequest getFile:filename parts:_parts success:^(NSData *data) {
        
        NSLog(@"+ file (%dBytes): %@...", file.length, [[file description] substringWithRange:NSMakeRange(0, 40)]);
        NSLog(@"  data (%dBytes): %@...", data.length, [[data description] substringWithRange:NSMakeRange(0, 40)]);
//        NSLog(@"+ file: %@", file);
//        NSLog(@"  data: %@", data);
        
        STAssertEqualObjects([WRequest sha256hash:file], [WRequest sha256hash:data], @"Hashes should correspond");
        kStopWait;
    } loading:^(double pourcentage) {
        NSLog(@"Downloading \"%@\": %.0f%%", filename, pourcentage * 100);
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

- (void)test03RemoveFile {
    kInitWait;
    
    NSString *filename = [_filename stringByAppendingFormat:@".%@", _fileExtension];
    [WRequest removeFile:filename success:^(id error) {
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
}

@end

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
#import "WRequest+List.h"

static NSNumber *fileId = nil;

@implementation WRequestSyncTests


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
    } failure:^(id json) {
        STFail(@"Error: %@", json);
        
//        [self createUser];
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
    
    NSString *filename = [_filename stringByAppendingFormat:@".%@", _fileExtension];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:_filename ofType:_fileExtension];
    NSData *file = [NSData dataWithContentsOfFile:filePath];
    
//    [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
//    [[AFHTTPRequestOperationLogger sharedLogger] stopLogging];
    [WRequest addFile:filename withData:file success:^(id json) {
        STAssertTrue(([json isKindOfClass:[NSDictionary class]]), @"JSON format invalid: %@", json);
        fileId = json[@"file"][@"id"];
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
    NSData *file = [NSData dataWithContentsOfFile:filePath];
    
//    [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelDebug];
//    [[AFHTTPRequestOperationLogger sharedLogger] stopLogging];
    
    
    __block NSNumber *parts = nil;
    [WRequest listAllFilesWithSuccess:^(NSDictionary *json) {
        NSDictionary *file = json[@"folder"][@"files"][0];
        parts = @(([file[@"size"] integerValue] / [file[@"part_size"] integerValue]) + 1);
        kStopWait;
    } failure:^(id error) {
        STFail(@"Error: %@", error);
        kStopWait;
    }];
    
    kWait;
    
    kStartWait;
    
    STAssertNotNil(fileId, @"File id must be set");
    if (fileId) {
        [WRequest getFile:fileId parts:parts success:^(NSData *data) {
            
            NSLog(@"+ file (%luBytes): %@...", (unsigned long)file.length, [[file description] substringWithRange:NSMakeRange(0, 40)]);
            NSLog(@"  data (%luBytes): %@...", (unsigned long)data.length, [[data description] substringWithRange:NSMakeRange(0, 40)]);
            
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
}

- (void)test03RemoveFile {
    kInitWait;
    
    STAssertNotNil(fileId, @"File id must be set");
    if (fileId) {
        [WRequest removeFile:fileId success:^(id error) {
            kStopWait;
        } failure:^(id error) {
            STFail(@"Error: %@", error);
            kStopWait;
        }];
        
        kWait;
    }
}

@end

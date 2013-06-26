//
//  WRequestTests.m
//  Woda
//
//  Created by Théo LUBERT on 6/25/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequestTests.h"

@implementation WRequestTests

- (void)setUp {
    [super setUp];
    
    [DDLog removeAllLoggers];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
    [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelInfo];
}

- (void)tearDown {
    [super tearDown];
}

@end

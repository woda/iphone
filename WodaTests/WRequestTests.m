//
//  WRequestTests.m
//  Woda
//
//  Created by Théo LUBERT on 6/25/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WRequestTests.h"
#import "AFHTTPRequestOperationLogger.h"

@implementation WRequestTests

- (void)setUp {
    [super setUp];
    
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
}

- (void)tearDown {
    [super tearDown];
}

@end

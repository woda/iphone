//
//  WRequestSyncTests.h
//  Woda
//
//  Created by Théo LUBERT on 6/24/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "WRequestTests.h"

@interface WRequestSyncTests : WRequestTests

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *fileExtension;

@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;

@property (nonatomic, retain) NSNumber *parts;

@end

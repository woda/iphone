//
//  WRequestListTests.h
//  Woda
//
//  Created by Théo LUBERT on 6/30/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "WRequestTests.h"

@interface WRequestListTests : WRequestTests

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *fileExtension;

@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;

@end

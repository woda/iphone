//
//  WRequestTests.h
//  Woda
//
//  Created by Théo LUBERT on 6/25/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#define kInitWait       dispatch_semaphore_t semaphore = dispatch_semaphore_create(0)
#define kStartWait      semaphore = dispatch_semaphore_create(0)
#define kStopWait       dispatch_semaphore_signal(semaphore)
#define kWait           while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))  [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]]

@interface WRequestTests : SenTestCase

@end

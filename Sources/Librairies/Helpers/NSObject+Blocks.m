//
//  NSObject+Blocks.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "NSObject+Blocks.h"

@implementation NSObject (Blocks)

- (void)performBlock:(void (^)())block {
    block();
}

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay {
    void (^block_)() = [block copy];
    [self performSelector:@selector(performBlock:) withObject:block_ afterDelay:delay];
}

- (void)performBlockInBackground:(void (^)())block {
    void (^block_)() = [block copy];
    [self performSelectorInBackground:@selector(performBlock:) withObject:block_];
}

@end

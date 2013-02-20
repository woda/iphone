//
//  NSArray+Shortcuts.m
//  Woda
//
//  Created by Théo LUBERT on 2/20/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "NSArray+Shortcuts.h"

@implementation NSArray (Shortcuts)

- (id)first {
    if ([self count] > 0) {
        return ([self objectAtIndex:0]);
    }
    return (nil);
}

- (id)last {
    return ([self lastObject]);
}

@end

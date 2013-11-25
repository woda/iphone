//
//  NSString+Path.m
//  Woda
//
//  Created by Théo LUBERT on 11/25/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

- (NSString *)pathWithParams:(NSDictionary *)params {
    NSMutableString *path = self.mutableCopy;
    for (NSString *key in params.allKeys) {
        [path replaceOccurrencesOfString:[NSString stringWithFormat:@"{%@}", key]
                              withString:params[key]
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, [path length])];
    }
    return (path);
}

@end

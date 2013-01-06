//
//  UIViewController+Helpers.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "UIViewController+Helpers.h"

@implementation UIViewController (Helpers)

- (NSString *)xibFullName:(NSString *)name {
    if ([[NSBundle mainBundle] pathForResource:name ofType:@"nib"] != nil) {
        return (name);
    }
    return ([NSString stringWithFormat:@"%@_%@", name, (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? @"iPhone" : @"iPad")]);
}

@end

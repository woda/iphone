//
//  WFolderViewController.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WFolderViewController.h"

@interface WFolderViewController ()

@end

@implementation WFolderViewController


#pragma mark -
#pragma mark Initialization methods

- (id)initWithPath:(NSString *)path {
    self = [super initWithNibName:[self xibFullName:@"WFolderView"] bundle:nil];
    if (self) {
        _path = path;
    }
    return self;
}

- (id)initWithData:(NSDictionary *)data {
    self = [super initWithNibName:[self xibFullName:@"WFolderView"] bundle:nil];
    if (self) {
        _data = data;
    }
    return self;
}

@end

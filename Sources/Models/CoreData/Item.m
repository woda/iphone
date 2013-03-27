//
//  Item.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "Item.h"
#import <QuickLook/QuickLook.h>


@implementation Item

@dynamic name;
@dynamic url;
@dynamic openedAt;
@dynamic isDirectory;
@dynamic starred;
@dynamic files;
@dynamic directory;

- (Boolean)quickLookAvailable {
    return ([QLPreviewController canPreviewItem:[NSURL URLWithString:self.url]]);
}

@end

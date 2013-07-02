//
//  WDirectoryViewController.h
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WMenuPageViewController.h"

@interface WDirectoryViewController : WMenuPageViewController {
    Item        *_item;
}

- (id)initWithItem:(Item *)item;

@end

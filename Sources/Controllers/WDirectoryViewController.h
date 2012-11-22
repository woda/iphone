//
//  WDirectoryViewController.h
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WFolderViewController.h"

@interface WDirectoryViewController : WFolderViewController {
    Item        *_item;
}

- (id)initWithItem:(Item *)item;

@end

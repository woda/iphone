//
//  WFolderViewController.h
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WListViewController.h"

@interface WFolderViewController : WListViewController

@property (nonatomic, retain) NSString    *path;

- (id)initWithPath:(NSString *)path andData:(NSDictionary *)data;

@end
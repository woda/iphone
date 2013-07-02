//
//  WFolderViewController.h
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WListViewController.h"

@interface WFolderViewController : WListViewController {
    NSString        *_path;
}

- (id)initWithPath:(NSString *)path andData:(NSDictionary *)data;

@end

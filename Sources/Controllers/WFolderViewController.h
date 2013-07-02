//
//  WFolderViewController.h
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WMenuPageViewController.h"

@interface WFolderViewController : WMenuPageViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString        *_path;
    NSDictionary    *_data;
}

@property (nonatomic, retain) IBOutlet UITableView      *tableView;

- (id)initWithPath:(NSString *)path;
- (id)initWithData:(NSDictionary *)data;

@end

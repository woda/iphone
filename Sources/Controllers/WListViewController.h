//
//  WListViewController.h
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WMenuPageViewController.h"
#import "WRequest+List.h"

@interface WListViewController : WMenuPageViewController <UITableViewDataSource, UITableViewDelegate> {
    NSDictionary    *_data;
}

@property (nonatomic, retain) IBOutlet UITableView  *tableView;

@end

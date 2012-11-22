//
//  WFolderViewController.h
//  Woda
//
//  Created by Théo LUBERT on 10/18/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDetailViewController;

#import <CoreData/CoreData.h>

@interface WFolderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    UILabel    *noDataLabel;
}

@property (strong, nonatomic) WDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) IBOutlet UITableView      *tableView;

@end

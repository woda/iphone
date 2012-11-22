//
//  WFolderViewController.h
//  Woda
//
//  Created by Théo LUBERT on 10/18/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Item.h"

@class WDetailViewController;


@interface WFolderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    UILabel     *noDataLabel;
    
    Item        *_item;
}

@property (strong, nonatomic) WDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) IBOutlet UITableView      *tableView;
@property (nonatomic, retain) IBOutlet UILabel          *countLabel;

- (id)initWithItem:(Item *)item;

@end

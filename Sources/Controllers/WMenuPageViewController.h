//
//  WFolderViewController.h
//  Woda
//
//  Created by Théo LUBERT on 10/18/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuickLook/QuickLook.h>
#import "Item.h"

@class WDetailViewController;


@interface WMenuPageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate> {
    UILabel     *noDataLabel;
}

@property (strong, nonatomic) WDetailViewController *detailViewController;
@property (strong, nonatomic) QLPreviewController   *previewController;
@property (strong, nonatomic) NSString              *fileUrl;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSPredicate               *predicate;

@property (nonatomic, retain) NSMutableDictionary       *files;

@property (nonatomic, retain) IBOutlet UITableView      *tableView;
@property (nonatomic, retain) IBOutlet UILabel          *countLabel;

@end

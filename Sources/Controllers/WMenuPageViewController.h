//
//  WMenuPageViewController.h
//  Woda
//
//  Created by Théo LUBERT on 10/18/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuickLook/QuickLook.h>
#import "WHomeViewController.h"

@class WDetailViewController;


@interface WMenuPageViewController : UIViewController {// <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate> {
}

@property (assign) HomeCellIndex    homeCellIndex;

//@property (strong, nonatomic) WDetailViewController *detailViewController;
//@property (strong, nonatomic) QLPreviewController   *previewController;
//@property (strong, nonatomic) NSString              *fileUrl;

@end

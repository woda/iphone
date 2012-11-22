//
//  WFolderViewController.m
//  Woda
//
//  Created by Théo LUBERT on 10/18/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSManagedObjectContext-EasyFetch.h"
#import "WDirectoryViewController.h"
#import "WDetailViewController.h"
#import "WCell.h"

@interface WFolderViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation WFolderViewController


#pragma mark -
#pragma mark Initialization methods

- (id)init {
    self = [super initWithNibName:[self xibFullName:@"WFolderView"] bundle:nil];
    if (self) {
        self.title = @"Woda";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.navigationController action:@selector(swipe)];
    self.navigationItem.leftBarButtonItem = listButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [self initOverlay];
    [self updateOverlay];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    CGFloat w = noDataLabel.frame.size.width;
    [noDataLabel setFrame:(CGRect) {
        .origin = (CGPoint) {
            .x = (_tableView.frame.size.width - w) / 2,
            .y = (_tableView.frame.size.height - 18) / 2
        },
        .size = (CGSize) {
            .width = w,
            .height = 18
        }
    }];
}


#pragma mark -
#pragma mark Overlay methods

- (void)addVisualConstraints:(NSString*)constraintString forViews:(NSDictionary*)views {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                                      options:0
                                                                      metrics:0
                                                                        views:views]];
}

- (void)initOverlay {
    if (noDataLabel == nil) {
        NSString *text = NSLocal(@"NoDataLabel");
        UIFont *font = [UIFont systemFontOfSize:10];
        CGFloat w = [text sizeWithFont:font constrainedToSize:(CGSize) {
            .width = _tableView.frame.size.width,
            .height = 18
        }].width + 16;
        noDataLabel = [[UILabel alloc] initWithFrame:(CGRect) {
            .origin = (CGPoint) {
                .x = (_tableView.frame.size.width - w) / 2,
                .y = (_tableView.frame.size.height - 18) / 2
            },
            .size = (CGSize) {
                .width = w,
                .height = 18
            }
        }];
        [_tableView addSubview:noDataLabel];
        
        [noDataLabel setText:text];
        [noDataLabel setFont:font];
        [noDataLabel.layer setCornerRadius:4];
        [noDataLabel setTextColor:[UIColor whiteColor]];
        [noDataLabel setTextAlignment:NSTextAlignmentCenter];
        [noDataLabel setBackgroundColor:[UIColor colorWithRed:(138.0/255.0)
                                                        green:(186.0/255.0)
                                                         blue:(225.0/255.0)
                                                        alpha:0.7]];
        
        int n = [self tableView:self.tableView numberOfRowsInSection:0];
        [noDataLabel setAlpha:((n > 0) ? 0.0 : 1.0)];
    }
}

- (void)updateOverlay {
    int n = [self tableView:self.tableView numberOfRowsInSection:0];
    [UIView animateWithDuration:0.2 animations:^{
        [noDataLabel setAlpha:((n > 0) ? 0.0 : 1.0)];
        [_countLabel setAlpha:((n <= 0) ? 0.0 : 1.0)];
    }];
    
    if (n <= 0) {
        [_countLabel setText:NSLocal(@"NoDataLabel")];
    } else if (n == 1) {
        [_countLabel setText:[NSString stringWithFormat:@"%d %@", n, NSLocal(@"File")]];
    } else {
        [_countLabel setText:[NSString stringWithFormat:@"%d %@", n, NSLocal(@"Files")]];
    }
}



#pragma mark -
#pragma mark TableView methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat h = _tableView.frame.size.height / 4.0;
    if ([self tableView:self.tableView numberOfRowsInSection:0] <= 0) {
        [noDataLabel setAlpha:MAX(0.3, ((h - ABS(scrollView.contentOffset.y)) / h))];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell setBackgroundColor:[UIColor clearColor]];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    Item *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    return ([object.isDirectory boolValue] == NO);
    return (YES);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kFileUpdated object:nil];
    }
    [self updateOverlay];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Item *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    if ([[object isDirectory] boolValue]) {
        WDirectoryViewController *c = [[WDirectoryViewController alloc] initWithItem:object];
        [self.navigationController pushViewController:c animated:YES];
    } else {
        [object setOpenedAt:[NSDate date]];
        [[self fetchedResultsController].managedObjectContext save:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFileUpdated object:nil];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            if (!self.detailViewController) {
                self.detailViewController = [[WDetailViewController alloc] initWithNibName:@"WDetailViewController_iPhone" bundle:nil];
            }
            self.detailViewController.detailItem = object;
            [self.navigationController pushViewController:self.detailViewController animated:YES];
        } else {
            self.detailViewController.detailItem = object;
        }
    }
}


#pragma mark -
#pragma mark Fetched results controller methods

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:[NSManagedObjectContext shared:nil]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:_predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext shared:nil] sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self updateOverlay];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Item *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([object.isDirectory boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [[object valueForKey:@"name"] description];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor colorWithRed:(138.0/255.0)
                                               green:(186.0/255.0)
                                                blue:(225.0/255.0)
                                               alpha:1.0];
}

@end

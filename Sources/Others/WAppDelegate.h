//
//  WAppDelegate.h
//  Woda
//
//  Created by Théo LUBERT on 10/18/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSManagedObjectContext-EasyFetch.h"
#import "WNavigationController.h"

#define TESTING 1
#define kTestFlightToken    @"80c36e4e359a9bc89cb2365e0b2a808f_MTU5NjM5MjAxMi0xMS0yNiAxODo1NjoyNC43MTU2NDA"

@interface WAppDelegate : UIResponder <CoreDataApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) WNavigationController   *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@end

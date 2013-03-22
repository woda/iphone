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
#import "WHomeViewController.h"

/*! \mainpage Project documentation index page
 *
 * \section intro_sec Introduction
 *
 * The project is an XCode project, coded in Objective-C.
 * It use WebServices provided by the Woda server, as described at: http://woda-redmine.heroku.com/projects/woda/wiki/Using_the_server
 *
 * \section install_sec Installation
 *
 * Be sure to have XCode installed (or download it from the AppleStore.
 *
 * \subsection step1 Step 1: Set up Git
 *
 * Follow instructions at: https://help.github.com/articles/set-up-git
 *
 * \subsection step2 Step 2: Clone the git project
 *
 * sh> git clone git@github.com:woda/iphone.git
 *
 * \subsection step3 Step 3: Librairies
 *
 * Nothing to install here. Basically the project use 3 external well famous librairies:
 * * AFNetworking: https://github.com/AFNetworking/AFNetworking
 * * TestFlight: https://testflightapp.com/
 * * Coredata-easyfetch: https://github.com/halostatue/coredata-easyfetch
 *
 */

#define TESTING 1
#define kTestFlightToken    @"80c36e4e359a9bc89cb2365e0b2a808f_MTU5NjM5MjAxMi0xMS0yNiAxODo1NjoyNC43MTU2NDA"

@interface WAppDelegate : UIResponder <CoreDataApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) WHomeViewController       *homeController;
@property (strong, nonatomic) WNavigationController     *navigationController;

@property (strong, nonatomic) UISplitViewController     *splitViewController;

@end

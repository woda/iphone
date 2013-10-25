//
//  WAppDelegate.m
//  Woda
//
//  Created by Théo LUBERT on 10/18/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WAppDelegate.h"
#import "WHomeViewController.h"
//#import "WDirectoryViewController.h"
//#import "WDetailViewController.h"
#import "WUserLoginViewController.h"
#import "AFHTTPRequestOperationLogger.h"
#import "WOfflineManager.h"

@implementation WAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIColor *tintColor = [UIColor colorWithRed:(142.0/255.0) green:(180.0/255.0) blue:(252.0/255.0) alpha:1.0];
    [self.window setBackgroundColor:tintColor];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [NSManagedObjectContext shared:self.managedObjectContext];
    
    WUserLoginViewController *loginViewController = [[WUserLoginViewController alloc] init];
    self.navigationController = [[WNavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    self.homeController = [[WHomeViewController alloc] init];
    self.homeController.navController = self.navigationController;
    [self.homeController viewWillAppear:NO];
    [self.navigationController setHomeController:self.homeController];
    
//#ifdef TESTING
//    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
//#endif
    [TestFlight takeOff:kTestFlightToken];
    
    [DDLog removeAllLoggers];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillTerminate:)
     name:UIApplicationWillTerminateNotification object:app];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [WOfflineManager clearTemporaryFiles];
}

@end

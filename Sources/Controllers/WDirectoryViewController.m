//
//  WDirectoryViewController.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WDirectoryViewController.h"

@interface WDirectoryViewController ()

@end

@implementation WDirectoryViewController


#pragma mark -
#pragma mark Initialization methods

- (id)initWithItem:(Item *)item {
    self = [super init];
    if (self) {
        _item = item;
        self.predicate = [NSPredicate predicateWithFormat:@"directory == %@", _item];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}


#pragma mark -
#pragma mark Test methods

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    
    int n = arc4random_uniform(74) % 3;
    if (n == 0) {
        [newManagedObject setValue:@"Woda.png" forKey:@"name"];
        [newManagedObject setValue:@"http://f.cl.ly/items/1F3K2X3J320V2U1u2q3s/logo.png" forKey:@"url"];
    } else if (n == 1) {
        [newManagedObject setValue:@"Logo-old.png" forKey:@"name"];
        [newManagedObject setValue:@"http://f.cl.ly/items/2W0M143O030I432H3V3E/WodaGoutteFleche.png" forKey:@"url"];
    } else {
        [newManagedObject setValue:@"Secret directory" forKey:@"name"];
        [newManagedObject setValue:[NSNumber numberWithBool:YES] forKey:@"isDirectory"];
    }
    [newManagedObject setValue:_item forKey:@"directory"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end

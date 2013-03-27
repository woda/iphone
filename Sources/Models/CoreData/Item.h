//
//  Item.h
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * openedAt;
@property (nonatomic, retain) NSNumber * isDirectory;
@property (nonatomic, retain) NSNumber * starred;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) Item *directory;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addFilesObject:(Item *)value;
- (void)removeFilesObject:(Item *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;
- (Boolean)quickLookAvailable;

@end

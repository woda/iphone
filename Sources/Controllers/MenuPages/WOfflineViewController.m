//
//  WOfflineViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WOfflineViewController.h"
#import "WOfflineManager.h"
#import "WOfflineFileCell.h"

@interface WOfflineViewController ()

@end

@implementation WOfflineViewController


#pragma mark -
#pragma mark Initialization methods

- (void)reload {
    self.data = [[WOfflineManager shared] offlineFiles];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"OfflinePageTitle");
    self.homeCellIndex = kHomeOfflineCellIndex;
}

- (UITableViewCell *)fileCellForIndex:(NSInteger)idx {
    if (idx) {
        idx--;
        if ([[self.data objectForKey:@"files"] count]) {
            NSString *reuseIdentifier = [WOfflineFileCell reuseIdentifier];
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (cell == nil) {
                cell = [UIViewController cellOfClass:[WOfflineFileCell class]];
            }
            [(WOfflineFileCell *)cell setFile:[[self.data objectForKey:@"files"] objectAtIndex:idx]];
            [(WOfflineFileCell *)cell displaySeparator:(idx < ([[self.data objectForKey:@"files"] count] - 1))];
            return (cell);
        } else {
            return (self.noFileCell);
        }
    }
    return (self.filesHeaderCell);
}

@end

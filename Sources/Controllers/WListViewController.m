//
//  WListViewController.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WListViewController.h"
#import "WFolderCell.h"
#import "WFileCell.h"

@interface WListViewController ()

@end

@implementation WListViewController


#pragma mark -
#pragma mark Initialization methods

- (id)init {
    self = [super initWithNibName:[self xibFullName:@"WListView"] bundle:nil];
    if (self) {
        _data = nil;
    }
    return self;
}

- (void)updateFooter {
    [self.countLabel setText:[NSString stringWithFormat:@"%d files, %d folders", [[_data objectForKey:@"files"] count], [[_data objectForKey:@"folders"] count]]];
    if ([self.data objectForKey:@"last_update"]) {
        [self.updatedLabel setText:[NSString stringWithFormat:@"Last updated: %@", [NSDate date:[self.data objectForKey:@"last_update"] fromFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZZ" toFormat:@"MM/dd/YYYY' at 'HH:mm"]]];
    } else {
        [self.updatedLabel setText:@""];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView setTableFooterView:self.footerView];
    [self updateFooter];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    [self updateFooter];
    
    DDLogWarn(@"data: %@", _data);
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if ([[_data objectForKey:@"folders"] count]) {
        rows += 1 + [[_data objectForKey:@"folders"] count];
    }
    rows += 1 + MAX(1, [[_data objectForKey:@"files"] count]);
    return (rows);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = indexPath.row;
    if ([[_data objectForKey:@"folders"] count]) {
        if (idx == 0) {
            return (_foldersHeaderCell.frame.size.height);
        }
        idx -= 1 + [[_data objectForKey:@"folders"] count];
    }
    if (idx == 0) {
        return (_filesHeaderCell.frame.size.height);
    }
    return (44);
}

- (UITableViewCell *)folderCellForIndex:(NSInteger)idx {
    if (idx) {
        idx--;
        NSString *reuseIdentifier = [WFolderCell reuseIdentifier];
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [UIViewController cellOfClass:[WFolderCell class]];
        }
        [(WFolderCell *)cell setFolder:[[_data objectForKey:@"folders"] objectAtIndex:idx]];
        [(WFolderCell *)cell displaySeparator:(idx < ([[_data objectForKey:@"folders"] count] - 1))];
        return (cell);
    }
    return (_foldersHeaderCell);
}

- (UITableViewCell *)fileCellForIndex:(NSInteger)idx {
    if (idx) {
        idx--;
        if ([[_data objectForKey:@"files"] count]) {
            NSString *reuseIdentifier = [WFileCell reuseIdentifier];
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (cell == nil) {
                cell = [UIViewController cellOfClass:[WFileCell class]];
            }
            if ([[_data objectForKey:@"files"] count]) {
                [(WFileCell *)cell setFile:[[_data objectForKey:@"files"] objectAtIndex:idx]];
                [(WFileCell *)cell displaySeparator:(idx < ([[_data objectForKey:@"files"] count] - 1))];
                return (cell);
            }
        } else {
            return (_noFileCell);
        }
    }
    return (_filesHeaderCell);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = indexPath.row;
    if ([[_data objectForKey:@"folders"] count]) {
        if (idx <= [[_data objectForKey:@"folders"] count]) {
            return ([self folderCellForIndex:idx]);
        }
        idx -= 1 + [[_data objectForKey:@"folders"] count];
    }
    return ([self fileCellForIndex:idx]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

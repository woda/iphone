//
//  WListViewController.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WListViewController.h"
#import "WDownloadingViewController.h"
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
    NSInteger folders = [[self.data objectForKey:@"folders"] count];
    NSInteger files = [[self.data objectForKey:@"files"] count];
    [self.countLabel setText:[NSString stringWithFormat:@"%d files, %d folders", files, folders]];
    
    if ([self.data objectForKey:@"last_update"]) {
        [self.updatedLabel setText:[NSString stringWithFormat:@"Last updated: %@", [NSDate date:[self.data objectForKey:@"last_update"] fromFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ" toFormat:@"MM/dd/yyyy' at 'hh:mm a"]]];
    } else {
        [self.updatedLabel setText:@""];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView setTableFooterView:self.footerView];
    [self updateFooter];
    
    if (self.data == nil) {
        [self.tableView setAlpha:0.0];
        [self.loading startAnimating];
    }
}

- (void)setData:(NSDictionary *)data {
    if ([data isKindOfClass:[NSArray class]]) {
        data = [NSDictionary dictionaryWithObject:data forKey:@"files"];
    }
    _data = data;
    
    [self updateFooter];
    
    if (self.data) {
        [self.loading stopAnimating];
    }
    
//    DDLogWarn(@"data: %@", _data);
    [self.tableView reloadData];
    
    if (self.tableView.alpha == 0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView setAlpha:1.0];
        }];
    }
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
            [(WFileCell *)cell setFile:[[_data objectForKey:@"files"] objectAtIndex:idx]];
            [(WFileCell *)cell displaySeparator:(idx < ([[_data objectForKey:@"files"] count] - 1))];
            return (cell);
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
    
    NSInteger idx = indexPath.row;
    if ([[_data objectForKey:@"folders"] count]) {
        if (idx <= [[_data objectForKey:@"folders"] count]) {
            return ;
        }
        idx -= 1 + [[_data objectForKey:@"folders"] count];
    }
    if (idx) {
        idx--;
        if ([[_data objectForKey:@"files"] count]) {
            NSDictionary *file = [[_data objectForKey:@"files"] objectAtIndex:idx];
            WDownloadingViewController *c = [[WDownloadingViewController alloc] initWithFile:file];
            [self.navigationController pushViewController:c animated:YES];
        }
    }
}

@end

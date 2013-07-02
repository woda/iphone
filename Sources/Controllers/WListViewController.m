//
//  WListViewController.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WListViewController.h"

@interface WListViewController ()

@end

@implementation WListViewController


#pragma mark -
#pragma mark Initialization methods

- (id)init {
    self = [super initWithNibName:[self xibFullName:@"WFolderView"] bundle:nil];
    if (self) {
        _data = nil;
    }
    return self;
}


#pragma mark -
#pragma mark TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (MAX(1, [[_data objectForKey:@"folders"] count]));
    }
    return (MAX(1, [[_data objectForKey:@"files"] count]));
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return (@"Folders");
    }
    return (@"Files");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"fileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSDictionary *file = nil;
    if (indexPath.section == 0) {
        if ([[_data objectForKey:@"folders"] count]) {
            file = [[_data objectForKey:@"folders"] objectAtIndex:indexPath.row];
            [cell.textLabel setText:[file objectForKey:@"name"]];
        } else {
            [cell.textLabel setText:@"No folders"];
        }
    } else {
        if ([[_data objectForKey:@"files"] count]) {
            file = [[_data objectForKey:@"files"] objectAtIndex:indexPath.row];
            [cell.textLabel setText:[file objectForKey:@"name"]];
        } else {
            [cell.textLabel setText:@"No files"];
        }
    }
    return (cell);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

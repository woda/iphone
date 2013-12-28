//
//  WListViewController.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WListViewController.h"
#import "WDownloadingViewController.h"
#import "WOfflineManager.h"
#import "WRequest.h"
#import "WFolderCell.h"
#import "WFileCell.h"
#import "WFolderViewController.h"
#import "WFileItem.h"

@interface WListViewController ()

@property (nonatomic, retain) NSDate    *refreshDate;

@end

@implementation WListViewController


#pragma mark -
#pragma mark Initialization methods

- (void)reload {
    [self doesNotRecognizeSelector:@selector(reload)];
}

- (void)beginRefreshing {
    if (!self.refreshControl.refreshing) {
        self.refreshDate = [NSDate date];
        [self.refreshControl beginRefreshing];
    }
}

- (void)endRefreshing {
    if (self.refreshControl.refreshing) {
        [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil
                                  afterDelay:MAX(0.0, (0.5 - abs([self.refreshDate timeIntervalSinceNow])))];
//        [self.refreshControl endRefreshing];
    }
}

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
        [self.updatedLabel setText:[NSString stringWithFormat:@"%@: %@", NSLocal(@"LastUpdate"), [NSDate date:[self.data objectForKey:@"last_update"] fromFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ" toFormat:@"MM/dd/yyyy' at 'hh:mm a"]]];
    } else {
        [self.updatedLabel setText:@""];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshDate = [NSDate date];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload)
                  forControlEvents:UIControlEventValueChanged];
    
    if (self.data == nil || self.data[@"files"] == nil || self.data[@"folders"] == nil) {
        [self beginRefreshing];
        [self reload];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Woda";
    self.view.alpha = 1.0;
    self.view.backgroundColor = [UIColor colorWithWhite:(240.0/255.0) alpha:1.0];
    
    if (self.navigationController.viewControllers.count <= 2) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"navbar_white_menu.png"] forState:UIControlStateNormal];
        [button setBounds:CGRectMake(0, 0, 35, 18)];
        [button setImageEdgeInsets:(UIEdgeInsets) {
            .top = 0,
            .left = 10,
            .bottom = 0,
            .right = 0
        }];
        [button addTarget:self.navigationController action:@selector(swipe) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = listButton;
    } else {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"navbar_left_white_arrow.png"] forState:UIControlStateNormal];
        [button setBounds:CGRectMake(0, 0, 21, 18)];
        [button setImageEdgeInsets:(UIEdgeInsets) {
            .top = 0,
            .left = 10,
            .bottom = 0,
            .right = 0
        }];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = listButton;
    }
    
    [self.noFileLabel setText:NSLocal(@"NoDataLabel")];
    
    [self.tableView setTableFooterView:self.footerView];
    [self updateFooter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:kFileMarkedNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:kFileDeletedNotificationName object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [((WNavigationController *)self.navigationController).homeController setSelected:self.homeCellIndex];
}

- (void)setData:(NSDictionary *)data {
    if ([data isKindOfClass:[NSArray class]]) {
        data = [NSDictionary dictionaryWithObject:data forKey:@"files"];
    }
    
    NSMutableDictionary *d = data.mutableCopy;
    if ([d[@"folder"] isKindOfClass:[NSDictionary class]])
        d = d[@"folder"];
    if (d == nil)
        d = data.mutableCopy;
    
    NSMutableArray *files = [NSMutableArray array];
    NSMutableArray *folders = [NSMutableArray array];
    if ([d[@"folders"] isKindOfClass:[NSArray class]]) {
        folders = ((NSArray *)d[@"folders"]).mutableCopy;
    }
    if ([d[@"files"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *f in d[@"files"]) {
            if ([f[@"folder"] boolValue]) {
                [folders addObject:f];
            } else {
                [files addObject:f];
            }
        }
        d[@"folders"] = folders;
        d[@"files"] = files;
    }
    _data = d.mutableCopy;
    
    [self updateFooter];
    
//    DDLogWarn(@"data: %@", _data);
    [self.tableView reloadData];
    
    if (self.tableView.alpha == 0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView setAlpha:1.0];
        }];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark TableView methods

- (NSInteger)countFolderCells {
    if ([[_data objectForKey:@"folders"] count]) {
        return (1 + [[_data objectForKey:@"folders"] count]);
    }
    return (0);
}

- (NSInteger)countFileCells {
    return (1 + MAX(1, [[_data objectForKey:@"files"] count]));
}

- (Boolean)isThereAnyFolder {
    return ([self countFolderCells] > 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self countFolderCells] + [self countFileCells]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = indexPath.row;
    if ([self isThereAnyFolder]) {
        if (idx == 0) {
            return (_foldersHeaderCell.frame.size.height);
        }
        idx -= [self countFolderCells];
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
        [(WFolderCell *)cell setFile:[[_data objectForKey:@"folders"] objectAtIndex:idx]];
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
    if ([self isThereAnyFolder]) {
        if (idx < [self countFolderCells]) {
            return ([self folderCellForIndex:idx]);
        }
        idx -= [self countFolderCells];
    }
    return ([self fileCellForIndex:idx]);
}

- (void)openFolder:(NSDictionary *)folder {
    // Do nothing
}

- (void)openFile:(NSDictionary *)file {
    if (file[@"size"] && file[@"part_size"]) {
//        NSData *data = [WOfflineManager fileForId:file[@"id"]];
        //        if (data) {
        self.item = [WFileItem fileWithInfo:file];
        if (self.item) {
//            NSString *type = file[@"type"];
            if ([WImagePreviewViewController canPreviewItem:self.item]) {
                DDLogWarn(@"self.item: %@", [self.item description]);
                WImagePreviewViewController *c = [[WImagePreviewViewController alloc] init];
                c.dataSource = self;
                c.delegate = self;
                [self.navigationController pushViewController:c animated:YES];
            }
//            if ([WFileCell isFileAnImage:type]) {
//                WImagePreviewViewController *c = [[WImagePreviewViewController alloc] initWithImage:[UIImage imageWithData:data]];
//                [self.navigationController pushViewController:c animated:YES];
//            }
        } else {
            WDownloadingViewController *c = [[WDownloadingViewController alloc] initWithFile:file inFolder:nil];
            [self.navigationController pushViewController:c animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger idx = indexPath.row;
    if (idx && [self isThereAnyFolder]) {
        if (idx < [self countFolderCells]) {
            NSDictionary *folder = [_data objectForKey:@"folders"][idx - 1];
            [self openFolder:folder];
            return ;
        }
        idx -= [self countFolderCells];
    }
    if (idx) {
        idx--;
        if ([[_data objectForKey:@"files"] count]) {
            NSDictionary *file = [[_data objectForKey:@"files"] objectAtIndex:idx];
            [self openFile:file];
        }
    }
}


#pragma mark -

- (NSInteger) numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return (1);
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return (self.item);
}

@end

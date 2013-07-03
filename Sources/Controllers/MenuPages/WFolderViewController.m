//
//  WFolderViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WFolderViewController.h"
#import "WRequest+Sync.h"

@interface WFolderViewController ()

@end

@implementation WFolderViewController


#pragma mark -
#pragma mark Initialization methods

- (id)initWithPath:(NSString *)path andData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.path = path;
        self.data = data;
        
        void (^success)(NSDictionary *) = ^(NSDictionary *json) {
            self.data = json;
        };
        void (^failure)(id) = ^(NSDictionary *error) {
            DDLogError(@"Failure while listing files: %@", error);
        };
        if (_path == nil) {
            [WRequest listAllFilesWithSuccess:success failure:failure];
        } else if (self.data == nil) {
            [WRequest listFilesInDir:_path success:success failure:failure];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"RootPageTitle");
    self.homeCellIndex = kHomeFoldersCellIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"navbar_plus.png"] forState:UIControlStateNormal];
    [button setBounds:CGRectMake(0, 0, 30, 20)];
    [button setImageEdgeInsets:(UIEdgeInsets) {
        .top = 0,
        .left = 0,
        .bottom = 0,
        .right = 10
    }];
    [button addTarget:self action:@selector(addFile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = addButton;
}


#pragma mark -
#pragma mark Upload methods

- (void)addFile:(id)sender {
    // do nothing
    
    NSString *_filename = @"Icon-72";
    NSString *_fileExtension = @"png";
    NSString *filename = [_filename stringByAppendingFormat:@".%@", _fileExtension];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:_filename ofType:_fileExtension];
    NSData *file = [NSData dataWithContentsOfFile:filePath];
    
    [WRequest addFile:filename withData:file success:^(id json) {
        DDLogWarn(@"json: %@", json);
    } loading:^(double pourcentage) {
        NSLog(@"Loading \"%@\": %.0f%%", filename, pourcentage * 100);
    } failure:^(id error) {
        DDLogWarn(@"error: %@", error);
    }];
}

@end

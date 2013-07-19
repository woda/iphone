//
//  WDownloadingViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WDownloadingViewController.h"
#import "WImagePreviewViewController.h"
#import "WOfflineManager.h"
#import "WRequest+Sync.h"

@interface WDownloadingViewController ()

@property (nonatomic, retain) NSDictionary  *info;

@end

@implementation WDownloadingViewController


#pragma mark -
#pragma mark Initialization methods

- (id)initWithFile:(NSDictionary *)info {
    self = [super initWithNibName:[self xibFullName:@"WDownloadingView"] bundle:nil];
    if (self) {
        self.info = info;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = NSLocal(@"Loading");
    
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
    
    [self.progressView setFrame:(CGRect) {
        .origin = CGPointZero,
        .size = (CGSize) {
            .width = 0,
            .height = self.progressBarView.frame.size.height
        }
    }];
    [self.loadingLabel setText:[NSString stringWithFormat:@"%@ '%@'", NSLocal(@"LoadingOf"), self.info[@"name"]]];
    
    NSNumber *parts = @(([self.info[@"size"] integerValue] / [self.info[@"part_size"] integerValue]) + 1);
    [WRequest getFile:self.info[@"name"] parts:parts success:^(NSData *file) {
        if ([self.navigationController viewControllers].last == self) {
            NSMutableArray *stack = [[self.navigationController viewControllers] mutableCopy];
            [stack removeLastObject];
            WImagePreviewViewController *c = [[WImagePreviewViewController alloc] initWithImage:[UIImage imageWithData:file]];
            [stack addObject:c];
            [self.navigationController setViewControllers:stack animated:YES];
        }
        [[WOfflineManager shared] saveFile:file withType:self.info[@"type"] forId:self.info[@"id"]];
    } loading:^(double pourcentage) {
        [self.progressView setFrame:(CGRect) {
            .origin = CGPointZero,
            .size = (CGSize) {
                .width = self.progressBarView.frame.size.width * pourcentage,
                .height = self.progressBarView.frame.size.height
            }
        }];
    } failure:^(id error) {
        if ([self.navigationController viewControllers].last == self) {
            [self.loadingLabel setText:[NSString stringWithFormat:@"%@ '%@'", NSLocal(@"UnableToLoading"), self.info[@"name"]]];
            [self.progressView setBackgroundColor:[UIColor redColor]];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.0];
        }
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

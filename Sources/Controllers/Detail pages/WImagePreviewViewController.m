//
//  WImagePreviewViewController.m
//  Woda
//
//  Created by Théo LUBERT on 7/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WImagePreviewViewController.h"

@interface WImagePreviewViewController ()

@property (nonatomic, retain) UIImage   *image;

@end

@implementation WImagePreviewViewController

- (id)initWithImage:(UIImage *)image {
    self = [super initWithNibName:[UIViewController xibFullName:@"WImagePreviewView"] bundle:nil];
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"navbar_left_white_arrow.png"] forState:UIControlStateNormal];
    [button setBounds:CGRectMake(0, 0, 21, 18)];
    [button setImageEdgeInsets:(UIEdgeInsets) {
        .top = 0,
        .left = 10,
        .bottom = 0,
        .right = 0
    }];
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = listButton;
    
    CGFloat r = self.image.size.width / self.image.size.height;
    CGFloat minScale = MIN((self.scrollView.frame.size.width / self.image.size.width), (self.scrollView.frame.size.height / self.image.size.height));
    CGSize s = (CGSize) {
        .width = (r > 1) ? self.image.size.width : self.scrollView.frame.size.width / minScale,
        .height = (r < 1) ? self.image.size.height : self.scrollView.frame.size.height / minScale,
    };
    [self.scrollView setContentSize:s];
    [self.imageView setImage:self.image];
    [self.imageView setFrame:(CGRect) {
        .origin = CGPointZero,
        .size = s
    }];
    [self.scrollView setMaximumZoomScale:2.0];
    [self.scrollView setMinimumZoomScale:minScale];
    [self.scrollView setZoomScale:minScale];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


#pragma mark - Scroll view related methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return (self.imageView);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.controlsView.alpha == 1.0) {
            self.backButton.alpha = 0.0;
            self.controlsView.alpha = 0.0;
        }
    }];
}

#pragma mark - Action methods

- (IBAction)toggleControls {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.controlsView.alpha == 0.0) {
            self.backButton.alpha = 1.0;
            self.controlsView.alpha = 1.0;
        } else if (self.controlsView.alpha == 1.0) {
            self.backButton.alpha = 0.0;
            self.controlsView.alpha = 0.0;
        }
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

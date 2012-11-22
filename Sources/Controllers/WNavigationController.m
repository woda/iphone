//
//  WNavigationController.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WNavigationController.h"

@interface WNavigationController ()

@end

@implementation WNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setOrigin:(CGPoint)origin {
    _origin = origin;
    [self.view setFrame:(CGRect) {
        .origin = _origin,
        .size = self.view.frame.size
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOffset:CGSizeMake(-1, 0)];
    [self.view.layer setShadowOpacity:0.5];
    [self.view.layer setShadowRadius:1];
    
    [self.navigationBar setTintColor:[UIColor colorWithRed:(138.0/255.0)
                                                     green:(186.0/255.0)
                                                      blue:(225.0/255.0)
                                                     alpha:1.0]];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipe];
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipe];
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:(CGRect) {
            .origin = (CGPoint) {
                .x = 0,
                .y = _origin.y
            },
            .size = self.view.frame.size
        }];
    }];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:(CGRect) {
            .origin = _origin,
            .size = self.view.frame.size
        }];
    }];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    
    [self swipeLeft:nil];
}

@end

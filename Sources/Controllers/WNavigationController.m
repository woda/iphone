//
//  WNavigationController.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WUserLoginViewController.h"
#import "WNavigationController.h"
#import "WHomeViewController.h"
#import "NSArray+Shortcuts.h"

@interface WNavigationController ()

- (void)swipeLeftWithDuration:(NSTimeInterval)duration;
- (void)swipeRightWithDuration:(NSTimeInterval)duration;

@end

@implementation WNavigationController


#pragma mark -
#pragma mark Update methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *shadow = [[UIImageView alloc] initWithFrame:(CGRect) {
        .origin = (CGPoint) {
            .x = -3,
            .y = 20
        },
        .size = (CGSize) {
            .width = 5,
            .height = self.view.frame.size.height - 20
        }
    }];
    [shadow setImage:[[UIImage imageNamed:@"shadow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:5]];
    [self.view addSubview:shadow];
    
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    UIView *v = [self.view.subviews objectAtIndex:1];
    if (v.frame.origin.x > 0) {
        [self swipeLeftWithDuration:duration];
    } else {
        [self.homeController.view setHidden:YES];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.homeController.view setHidden:NO];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    
    [self swipeLeftWithDuration:0.3];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
}

- (void)setHomeController:(WHomeViewController *)homeController {
    _homeController = homeController;
    
    [self.view insertSubview:self.homeController.view atIndex:0];
}


#pragma mark -
#pragma mark Swipe methods

- (void)swipeLeftWithDuration:(NSTimeInterval)duration {
    UIViewController *lastController = [[self viewControllers] last];
    if (![lastController isKindOfClass:[WUserLoginViewController class]]) {
        [UIView animateWithDuration:duration animations:^{
            for (int i=1, k=self.view.subviews.count; i<k; i++) {
                UIView *v = [self.view.subviews objectAtIndex:i];
                [v setFrame:(CGRect) {
                    .origin = (CGPoint) {
                        .x = v.frame.origin.x - ((v.frame.origin.x > 0) ? 240 : 0),
                        .y = v.frame.origin.y
                    },
                    .size = v.frame.size
                }];
            }
        }];
    }
}

- (void)swipeRightWithDuration:(NSTimeInterval)duration {
    UIViewController *lastController = [[self viewControllers] last];
    if (![lastController isKindOfClass:[WUserLoginViewController class]]) {
        [UIView animateWithDuration:duration animations:^{
            for (int i=1, k=self.view.subviews.count; i<k; i++) {
                UIView *v = [self.view.subviews objectAtIndex:i];
                [v setFrame:(CGRect) {
                    .origin = (CGPoint) {
                        .x = v.frame.origin.x + ((v.frame.origin.x <= 0) ? 240 : 0),
                        .y = v.frame.origin.y
                    },
                    .size = v.frame.size
                }];
            }
        }];
    }
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture {
    [self swipeLeftWithDuration:0.3];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture {
    [self swipeRightWithDuration:0.3];
}

- (void)swipe {
    UIView *v = [self.view.subviews objectAtIndex:1];
    if (v.frame.origin.x > 0) {
        [self swipeLeftWithDuration:0.3];
    } else {
        [self swipeRightWithDuration:0.3];
    }
}

- (void)swipeLeft {
    UIView *v = [self.view.subviews objectAtIndex:1];
    if (v.frame.origin.x > 0) {
        [self swipeLeftWithDuration:0.3];
    }
}

@end

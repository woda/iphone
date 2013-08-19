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
#import "WMenuPageViewController.h"
#import "WHomeViewController.h"
#import "NSArray+Shortcuts.h"

@interface WNavigationController ()

- (void)swipeLeftAnimated:(Boolean)animated;
- (void)swipeRightAnimated:(Boolean)animated;

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
    
    UIColor *tintColor = [UIColor colorWithRed:(71.0/255.0) green:(134.0/255.0) blue:(255.0/255.0) alpha:1.0];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:tintColor];
    
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
        [self swipeLeftAnimated:YES];
    } else {
        [self.homeController.view setHidden:YES];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.homeController.view setHidden:NO];
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [self swipeLeftAnimated:YES];
    
    [super setViewControllers:viewControllers animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self swipeLeftAnimated:YES];
    
    [super pushViewController:viewController animated:animated];
}

- (void)updateHomePosition {
    [_homeController.view setFrame:(CGRect) {
        .origin = (CGPoint) {
            .x = 0,
            .y = 20
        },
        .size = (CGSize) {
            .width = self.view.frame.size.width,
            .height = self.view.frame.size.height - 20
        }
    }];
    [self.view insertSubview:_homeController.view atIndex:0];
    
    NSLog(@"view.frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"tableView.frame: %@", NSStringFromCGRect(_homeController.tableView.frame));
}

- (void)setHomeController:(WHomeViewController *)homeController {
    _homeController = homeController;
    
    [self updateHomePosition];
}


#pragma mark -
#pragma mark Swipe methods

- (void)swipeLeftWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        for (int i=1, k=self.view.subviews.count; i<k; i++) {
            UIView *v = self.view.subviews[i];
//            [v setUserInteractionEnabled:YES];
            [v setFrame:(CGRect) {
                .origin = (CGPoint) {
                    .x = v.frame.origin.x - ((v.frame.origin.x > 0) ? self.homeController.tableView.frame.size.width : 0),
                    .y = v.frame.origin.y
                },
                .size = v.frame.size
            }];
        }
    }];
}

- (void)swipeRightWithDuration:(NSTimeInterval)duration {
    [self updateHomePosition];
    [UIView animateWithDuration:duration animations:^{
        for (int i=1, k=self.view.subviews.count; i<k; i++) {
            UIView *v = self.view.subviews[i];
//            [v setUserInteractionEnabled:NO];
            [v setFrame:(CGRect) {
                .origin = (CGPoint) {
                    .x = v.frame.origin.x + ((v.frame.origin.x <= 0) ? self.homeController.tableView.frame.size.width : 0),
                    .y = v.frame.origin.y
                },
                .size = v.frame.size
            }];
        }
    }];
}

- (void)swipeLeftAnimated:(Boolean)animated {
    UIViewController *lastController = [[self viewControllers] last];
    if (![lastController isKindOfClass:[WUserLoginViewController class]]
        && [lastController isKindOfClass:[WMenuPageViewController class]]) {
        [self swipeLeftWithDuration:(animated ? 0.3 : 0.0)];
    }
}

- (void)swipeRightAnimated:(Boolean)animated {
    UIViewController *lastController = [[self viewControllers] last];
    if (![lastController isKindOfClass:[WUserLoginViewController class]]
        && [lastController isKindOfClass:[WMenuPageViewController class]]) {
        [self swipeRightWithDuration:(animated ? 0.3 : 0.0)];
    }
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture {
    [self swipeLeftAnimated:YES];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture {
    [self swipeRightAnimated:YES];
}

- (void)swipe {
    UIView *v = [self.view.subviews objectAtIndex:1];
    if (v.frame.origin.x > 0) {
        [self swipeLeftAnimated:YES];
    } else {
        [self swipeRightAnimated:YES];
    }
}

- (void)swipeLeft {
    UIView *v = [self.view.subviews objectAtIndex:1];
    if (v.frame.origin.x > 0) {
        [self swipeLeftAnimated:YES];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

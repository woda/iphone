//
//  WNavigationController.h
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHomeViewController;

@interface WNavigationController : UINavigationController

@property (nonatomic, retain) WHomeViewController   *homeController;

- (void)swipe;
- (void)swipeLeft;

@end

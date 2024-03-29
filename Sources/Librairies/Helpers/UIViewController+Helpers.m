//
//  UIViewController+Helpers.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "UIViewController+Helpers.h"

@implementation UIViewController (Helpers)

+ (NSString *)xibFullName:(NSString *)name {
    if ([[NSBundle mainBundle] pathForResource:name ofType:@"nib"] != nil) {
        return (name);
    }
    return ([NSString stringWithFormat:@"%@_%@", name, (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? @"iPhone" : @"iPad")]);
}

+ (UITableViewCell *)cellOfClass:(Class<XibViewDelegate>)className {
    UIViewController *controller = [[UIViewController alloc] initWithNibName:[UIViewController xibFullName:[className xibName]] bundle:nil];
    [controller loadView];
    UITableViewCell *cell = (UITableViewCell *)controller.view;
    [cell prepareForReuse];
    return (cell);
}

+ (UICollectionViewCell *)collectionCellOfClass:(Class<XibViewDelegate>)className {
    UIViewController *controller = [[UIViewController alloc] initWithNibName:[UIViewController xibFullName:[className xibName]] bundle:nil];
    [controller loadView];
    UICollectionViewCell *cell = (UICollectionViewCell *)controller.view;
    [cell prepareForReuse];
    return (cell);
}

+ (UICollectionReusableView *)collectionReusableOfClass:(Class<XibViewDelegate>)className {
    UIViewController *controller = [[UIViewController alloc] initWithNibName:[UIViewController xibFullName:[className xibName]] bundle:nil];
    [controller loadView];
    UICollectionReusableView *reusable = (UICollectionReusableView *)controller.view;
    [reusable prepareForReuse];
    return (reusable);
}

- (NSString *)xibFullName:(NSString *)name {
    return ([UIViewController xibFullName:name]);
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // Do nothing
}

- (void)keyboardDidShow:(NSNotification *)notification {
    // Do nothing
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // Do nothing
}

- (void)keyboardDidHide:(NSNotification *)notification {
    // Do nothing
}

@end

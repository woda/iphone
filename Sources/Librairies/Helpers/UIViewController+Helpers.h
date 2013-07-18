//
//  UIViewController+Helpers.h
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XibViewDelegate <NSObject>

+ (NSString *)xibName;
+ (NSString *)reuseIdentifier;

@end

@interface UIViewController (Helpers)

+ (NSString *)xibFullName:(NSString *)name;
+ (UITableViewCell *)cellOfClass:(Class<XibViewDelegate>)className;
+ (UICollectionViewCell *)collectionCellOfClass:(Class<XibViewDelegate>)className;
+ (UICollectionReusableView *)collectionReusableOfClass:(Class<XibViewDelegate>)className;

- (NSString *)xibFullName:(NSString *)name;

- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;

@end

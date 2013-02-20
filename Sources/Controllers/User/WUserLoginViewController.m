//
//  WUserLoginViewController.m
//  Woda
//
//  Created by Théo LUBERT on 2/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUserLoginViewController.h"
#import "WUserSignUpViewController.h"
#import "WDirectoryViewController.h"
#import "WUser.h"

@interface WUserLoginViewController ()

@end

@implementation WUserLoginViewController


#pragma mark - View lifecycle methods

- (void)updateLabels {
    [_connectingLabel setText:NSLocal(@"ConnectingText")];
    
//    [_usernameField setText:nil];
    [_usernameField setPlaceholder:NSLocal(@"UsernameFieldPlaceholder")];
//    [_passwordField setText:nil];
    [_passwordField setPlaceholder:NSLocal(@"PasswordFieldPlaceholder")];
    
    [_submitButton setTitle:NSLocal(@"LoginButtonTitle") forState:UIControlStateNormal];
    [_signupButton setTitle:NSLocal(@"SignUpButtonTitle") forState:UIControlStateNormal];
}

- (void)showConnectingView:(Boolean)show animated:(Boolean)animated {
    [UIView animateWithDuration:((animated) ? 0.3 : 0.0) animations:^{
        if (show) {
            [_connectingView setAlpha:1.0];
            [_loginView setAlpha:0.0];
        } else {
            [_connectingView setAlpha:0.0];
            [_loginView setAlpha:1.0];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self registerForKeyboardNotifications];
    
    [self updateLabels];
    [self showConnectingView:([[WUser current] status] == Connecting) animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:kUserStatusChanged object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserStatusChanged object:nil];
    [self unregisterForKeyboardNotifications];
}

- (void)userStatusChanged:(NSNotification *)notification {
    switch ([[WUser current] status]) {
        case Connected: {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            WDirectoryViewController *folderViewController = [[WDirectoryViewController alloc] initWithItem:nil];
            [self.navigationController pushViewController:folderViewController animated:YES];
            break;
        }
        case Connecting:
            [self showConnectingView:YES animated:YES];
            break;
        case NotConnected:
            [self showConnectingView:NO animated:YES];
            break;
            
        default:
            [self showConnectingView:NO animated:YES];
            break;
    }
}


#pragma mark - Keyboard related methods

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    
    NSDictionary* info = [notification userInfo];
//    CGSize size = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [_loginView setFrame:(CGRect) {
            .origin.x = 0,
            .origin.y = -50, // -(size.height / 2),
            .size = _loginView.frame.size
        }];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    
    NSDictionary* info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [_loginView setFrame:(CGRect) {
            .origin.x = 0,
            .origin.y = 0,
            .size = _loginView.frame.size
        }];
    }];
}


#pragma mark - TextField delegates methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self submit:textField];
    }
    return (YES);
}


#pragma mark - Action methods

- (IBAction)signup:(id)sender {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
    WUserSignUpViewController *signupViewController = [[WUserSignUpViewController alloc] init];
    [self.navigationController pushViewController:signupViewController animated:YES];
}

- (IBAction)submit:(id)sender {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
    [self showConnectingView:YES animated:YES];
    [WUser connectWithLogin:[_usernameField text] andPassword:[_passwordField text]];
}

@end

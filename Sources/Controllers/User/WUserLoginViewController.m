//
//  WUserLoginViewController.m
//  Woda
//
//  Created by Théo LUBERT on 2/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WUserLoginViewController.h"
#import "WFolderViewController.h"
#import "WHomeViewController.h"
#import "WRequest.h"
#import "WUser.h"

@interface WUserLoginViewController ()

@end

@implementation WUserLoginViewController


#pragma mark - View lifecycle methods

- (void)updateLabels {
//    [_serverField setText:kBaseURL];
    [_serverField setPlaceholder:NSLocal(@"ServerFieldPlaceholder")];
    [_usernameField setPlaceholder:NSLocal(@"UsernameFieldPlaceholder")];
    [_passwordField setPlaceholder:NSLocal(@"PasswordFieldPlaceholder")];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault valueForKey:kUserServerKey]) {
        [_serverField setText:[userDefault valueForKey:kUserServerKey]];
    }
    if ([userDefault valueForKey:kUserLoginKey]) {
        [_usernameField setText:[userDefault valueForKey:kUserLoginKey]];
        [_passwordField setText:[userDefault valueForKey:kUserPasswordKey]];
    } else {
        [_usernameField setText:nil];
        [_passwordField setText:nil];
    }
    
    [_forgotPasswordButton setTitle:NSLocal(@"ForgotPasswordButtonTitle") forState:UIControlStateNormal];
    [_submitButton setTitle:NSLocal(@"LoginButtonTitle") forState:UIControlStateNormal];
}

- (void)showConnectingView:(Boolean)show animated:(Boolean)animated {
    if (show) {
        [_connectingIndicator startAnimating];
        [_submitButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        [_connectingIndicator stopAnimating];
        [_submitButton setTitle:NSLocal(@"LoginButtonTitle") forState:UIControlStateNormal];
    }
    [_formView setUserInteractionEnabled:!show];
}

- (void)animateLaunch {
    static Boolean firstLaunch = YES;
    if (firstLaunch) {
        NSInteger offset = ((self.view.frame.size.height - _logoView.frame.size.height) / 2) - _logoView.frame.origin.y;
        _logoView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, offset);
        _formView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, _formView.frame.size.height);
        _formView.alpha = 0;
        
        [UIView animateWithDuration:0.7 animations:^{
            _formView.transform = CGAffineTransformIdentity;
            _formView.alpha = 1;
            _logoView.transform = CGAffineTransformIdentity;
        }];
        firstLaunch = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self registerForKeyboardNotifications];
    
    [self updateLabels];
    [self showConnectingView:([[WUser current] status] == Connecting) animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:kUserStatusChanged object:nil];
    
    [self animateLaunch];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserStatusChanged object:nil];
    [self unregisterForKeyboardNotifications];
}

- (void)userStatusChanged:(NSNotification *)notification {
    switch ([[WUser current] status]) {
        case Connected: {
            WListViewController *folderViewController = [[WFolderViewController alloc] initWithId:nil andData:nil];
            [self.navigationController pushViewController:folderViewController animated:YES];
            [((WNavigationController *)self.navigationController).homeController setSelected:kHomeFoldersCellIndex];
            break;
        }
        case Connecting:
            [self showConnectingView:YES animated:YES];
            break;
        case NotConnected:
            [self updateLabels];
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
    CGSize size = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        [self.view setFrame:(CGRect) {
            .origin.x = 0,
            .origin.y = -size.height,
            .size = self.view.frame.size
        }];
    } completion:^(BOOL finished) {
        // do nothing
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    
    NSDictionary* info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        [self.view setFrame:(CGRect) {
            .origin.x = 0,
            .origin.y = 0,
            .size = self.view.frame.size
        }];
    } completion:^(BOOL finished) {
        // do nothing
    }];
}


#pragma mark - TextField delegates methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _serverField) {
        [_usernameField becomeFirstResponder];
    } else if (textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self submit:textField];
    }
    return (YES);
}


#pragma mark - Action methods

- (IBAction)submit:(id)sender {
    [_serverField resignFirstResponder];
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
    NSString *url = [_serverField text];
    if ([url rangeOfString:@"http"].location == NSNotFound) {
        url = [@"https://" stringByAppendingString:url];
    }
    [WRequest setBaseUrl:url];
    [self showConnectingView:YES animated:YES];
    [WUser connectWithLogin:[_usernameField text] andPassword:[_passwordField text]];
}

- (IBAction)forgotPassword:(id)sender {
    // do nothing
}

@end

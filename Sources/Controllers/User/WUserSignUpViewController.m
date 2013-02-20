//
//  WUserSignUpViewController.m
//  Woda
//
//  Created by Théo LUBERT on 2/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUserSignUpViewController.h"
#import "WDirectoryViewController.h"
#import "WUser.h"

@interface WUserSignUpViewController ()

@end

@implementation WUserSignUpViewController


#pragma mark - View lifecycle methods

- (void)updateLabels {
    [_usernameField setText:nil];
    [_usernameField setPlaceholder:NSLocal(@"UsernameFieldPlaceholder")];
    [_firstNameField setText:nil];
    [_firstNameField setPlaceholder:NSLocal(@"FirstNameFieldPlaceholder")];
    [_lastNameField setText:nil];
    [_lastNameField setPlaceholder:NSLocal(@"LastNameFieldPlaceholder")];
    [_emailField setText:nil];
    [_emailField setPlaceholder:NSLocal(@"EmailFieldPlaceholder")];
    [_passwordField setText:nil];
    [_passwordField setPlaceholder:NSLocal(@"PasswordFieldPlaceholder")];
    [_passwordVerificationField setText:nil];
    [_passwordVerificationField setPlaceholder:NSLocal(@"PasswordFieldPlaceholder")];
    
    [_submitButton setTitle:NSLocal(@"CreateUserButtonTitle") forState:UIControlStateNormal];
}

- (void)disable:(Boolean)disabled field:(UITextField *)field {
    [field setUserInteractionEnabled:disabled];
    [_usernameField setAlpha:((disabled) ? 0.7 : 1.0)];
}

- (void)showProcessingView:(Boolean)show animated:(Boolean)animated {
    [UIView animateWithDuration:((animated) ? 0.3 : 0.0) animations:^{
        [self disable:show field:_usernameField];
        [self disable:show field:_usernameField];
        [self disable:show field:_lastNameField];
        [self disable:show field:_emailField];
        [self disable:show field:_passwordField];
        [self disable:show field:_passwordVerificationField];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateLabels];
    [self showProcessingView:NO animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:kUserStatusChanged object:nil];
}

- (void)userStatusChanged:(NSNotification *)notification {
    if ([[WUser current] status] == Connected) {
        WDirectoryViewController *folderViewController = [[WDirectoryViewController alloc] initWithItem:nil];
        [self.navigationController pushViewController:folderViewController animated:YES];
    } else if ([[WUser current] status] == Connecting) {
        [self showProcessingView:YES animated:YES];
    } else if ([[WUser current] status] == NotConnected) {
        [self showProcessingView:NO animated:YES];
    }
}


#pragma mark - Action methods

- (IBAction)submit:(id)sender {
    [WUser connectWithLogin:[_usernameField text] andPassword:[_passwordField text]];
}

@end

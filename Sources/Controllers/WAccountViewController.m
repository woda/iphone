//
//  WAccountViewController.m
//  Woda
//
//  Created by Théo LUBERT on 3/27/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WAccountViewController.h"
#import "WUser.h"

@interface WAccountViewController ()

@end

@implementation WAccountViewController


#pragma mark - View lifecycle methods

- (void)updateLabels {
    [super updateLabels];
    
    [self.usernameField setText:[[WUser current] login]];
    [self.firstNameField setText:[[WUser current] firstName]];
    [self.lastNameField setText:[[WUser current] lastName]];
    [self.emailField setText:[[WUser current] email]];
    
    [self.submitButton setTitle:NSLocal(@"EditUserButtonTitle") forState:UIControlStateNormal];
    [self.submitButton setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count <= 2) {
        UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.navigationController action:@selector(swipe)];
        self.navigationItem.leftBarButtonItem = listButton;
    }
}

- (IBAction)submit:(id)sender {
    self.focusedTextField = nil;
    [self.usernameField resignFirstResponder];
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.passwordVerificationField resignFirstResponder];
    
    if (([[self.usernameField text] length] > 0)
        && ([[self.firstNameField text] length] > 0)
        && ([[self.lastNameField text] length] > 0)
        && ([[self.emailField text] length] > 0)
        && ([[self.passwordField text] length] > 0)
        && ([[self.passwordVerificationField text] length] > 0)
        && ([self validEmail:[self.emailField text]])
        && ([[self.passwordField text] isEqualToString:[self.passwordVerificationField text]])) {
        [self showProcessingView:YES animated:YES];
        [WUser editWithFirstName:[self.firstNameField text]
                        lastName:[self.lastNameField text]
                        password:[self.passwordField text]
                           email:[self.emailField text]];
    }
}

@end

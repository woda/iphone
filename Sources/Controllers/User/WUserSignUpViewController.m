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
    
    [_cancelButton setTitle:NSLocal(@"CancelButtonTitle") forState:UIControlStateNormal];
    [_submitButton setTitle:NSLocal(@"CreateUserButtonTitle") forState:UIControlStateNormal];
    [_submitButton setEnabled:NO];
}

- (void)updateScrollView {
    if (_tableView.contentSize.height > _tableView.frame.size.height) {
        [_tableView setScrollEnabled:YES];
    } else {
        [_tableView setScrollEnabled:NO];
    }
}

- (void)disable:(Boolean)disabled field:(UITextField *)field {
    [field setUserInteractionEnabled:!disabled];
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
    
    [self registerForKeyboardNotifications];
    
    [self updateLabels];
    [self updateScrollView];
    [self showProcessingView:NO animated:NO];
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
            [self showProcessingView:YES animated:YES];
            break;
        case NotConnected:
            [self showProcessingView:NO animated:YES];
            break;
            
        default:
            [self showProcessingView:NO animated:YES];
            break;
    }
}


#pragma mark - Keyboard related methods

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    
    NSDictionary* info = [notification userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [_tableView setFrame:(CGRect) {
            .origin = _tableView.frame.origin,
            .size = (CGSize) {
                .width = _tableView.frame.size.width,
                .height = _tableView.superview.frame.size.height - size.height
            }
        }];
    } completion:^(BOOL finished) {
        [self focusOn:_focusedTextField];
        [self updateScrollView];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    
    NSDictionary* info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [_tableView setFrame:(CGRect) {
            .origin = _tableView.frame.origin,
            .size = (CGSize) {
                .width = _tableView.frame.size.width,
                .height = _tableView.superview.frame.size.height
            }
        }];
    } completion:^(BOOL finished) {
        [self focusOn:_focusedTextField];
        [self updateScrollView];
    }];
}


#pragma mark -
#pragma mark TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (kSignUpCellCount);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kSignUpUsernameCellIndex:
            return (_usernameCell);
        case kSignUpFirstNameCellIndex:
            return (_firstNameCell);
        case kSignUpLastNameCellIndex:
            return (_lastNameCell);
        case kSignUpEmailCellIndex:
            return (_emailCell);
        case kSignUpPasswordCellIndex:
            return (_passwordCell);
        case kSignUpPasswordVerificationCellIndex:
            return (_passwordVerificationCell);
        case kSignUpButtonsCellIndex:
            return (_buttonsCell);
        default:
            return nil;
    }
}


#pragma mark - TextField delegates methods

- (void)focusOn:(UITextField *)field {
    _focusedTextField = field;
    if (field == _usernameField) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else if (field == _firstNameField) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else if (field == _lastNameField) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else if (field == _emailField) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]  atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else if (field == _passwordField) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else if (field == _passwordVerificationField) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        _focusedTextField = nil;
    }
    if (([_focusedTextField isKindOfClass:[UITextField class]]) && (![_focusedTextField isFirstResponder])) {
        [_focusedTextField becomeFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self focusOn:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    [textField setText:text];
    
    if (([[_usernameField text] length] > 0)
        && ([[_firstNameField text] length] > 0)
        && ([[_lastNameField text] length] > 0)
        && ([[_emailField text] length] > 0)
        && ([[_passwordField text] length] > 0)
        && ([[_passwordVerificationField text] length] > 0)) {
        [_submitButton setEnabled:YES];
    } else {
        [_submitButton setEnabled:NO];
    }
    return (NO);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameField) {
        [self focusOn:_firstNameField];
    } else if (textField == _firstNameField) {
        [self focusOn:_lastNameField];
    } else if (textField == _lastNameField) {
        [self focusOn:_emailField];
    } else if (textField == _emailField) {
        [self focusOn:_passwordField];
    } else if (textField == _passwordField) {
        [self focusOn:_passwordVerificationField];
    } else {
        [self focusOn:_firstNameField];
        [textField resignFirstResponder];
        [self submit:textField];
    }
    return (YES);
}


#pragma mark - Action methods

- (IBAction)cancel:(id)sender {
    _focusedTextField = nil;
    [_usernameField resignFirstResponder];
    [_firstNameField resignFirstResponder];
    [_lastNameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_passwordVerificationField resignFirstResponder];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)validEmail:(NSString *)emailString {
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
//    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    }
    return YES;
}

- (IBAction)submit:(id)sender {
    _focusedTextField = nil;
    [_usernameField resignFirstResponder];
    [_firstNameField resignFirstResponder];
    [_lastNameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_passwordVerificationField resignFirstResponder];
    
    if (([[_usernameField text] length] > 0)
        && ([[_firstNameField text] length] > 0)
        && ([[_lastNameField text] length] > 0)
        && ([[_emailField text] length] > 0)
        && ([[_passwordField text] length] > 0)
        && ([[_passwordVerificationField text] length] > 0)
        && ([self validEmail:[_emailField text]])
        && ([[_passwordField text] isEqualToString:[_passwordVerificationField text]])) {
        [self showProcessingView:YES animated:YES];
        [WUser signup:[_usernameField text]
            firstName:[_firstNameField text]
             lastName:[_lastNameField text]
             password:[_passwordField text]
                email:[_emailField text]];
    }
}

@end

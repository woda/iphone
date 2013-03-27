//
//  WUserSignUpViewController.h
//  Woda
//
//  Created by Théo LUBERT on 2/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

enum kSignUpCellIndexes {
    kSignUpUsernameCellIndex = 0,
    kSignUpFirstNameCellIndex,
    kSignUpLastNameCellIndex,
    kSignUpEmailCellIndex,
    kSignUpPasswordCellIndex,
    kSignUpPasswordVerificationCellIndex,
    kSignUpButtonsCellIndex,
    kSignUpCellCount
};

@interface WUserSignUpViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView  *tableView;

@property (nonatomic, retain) IBOutlet UITableViewCell  *usernameCell;
@property (nonatomic, retain) IBOutlet UITextField      *usernameField;

@property (nonatomic, retain) IBOutlet UITableViewCell  *firstNameCell;
@property (nonatomic, retain) IBOutlet UITextField      *firstNameField;

@property (nonatomic, retain) IBOutlet UITableViewCell  *lastNameCell;
@property (nonatomic, retain) IBOutlet UITextField      *lastNameField;

@property (nonatomic, retain) IBOutlet UITableViewCell  *emailCell;
@property (nonatomic, retain) IBOutlet UITextField      *emailField;

@property (nonatomic, retain) IBOutlet UITableViewCell  *passwordCell;
@property (nonatomic, retain) IBOutlet UITextField      *passwordField;

@property (nonatomic, retain) IBOutlet UITableViewCell  *passwordVerificationCell;
@property (nonatomic, retain) IBOutlet UITextField      *passwordVerificationField;

@property (nonatomic, retain) IBOutlet UITableViewCell  *buttonsCell;
@property (nonatomic, retain) IBOutlet UIButton         *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton         *submitButton;

@property (nonatomic, retain) UITextField               *focusedTextField;

- (void)updateLabels;
- (BOOL)validEmail:(NSString *)emailString;
- (void)showProcessingView:(Boolean)show animated:(Boolean)animated;

- (IBAction)cancel:(id)sender;
- (IBAction)submit:(id)sender;

@end

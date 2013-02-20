//
//  WUserSignUpViewController.h
//  Woda
//
//  Created by Théo LUBERT on 2/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUserSignUpViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField  *usernameField;
@property (nonatomic, retain) IBOutlet UITextField  *firstNameField;
@property (nonatomic, retain) IBOutlet UITextField  *lastNameField;
@property (nonatomic, retain) IBOutlet UITextField  *emailField;
@property (nonatomic, retain) IBOutlet UITextField  *passwordField;
@property (nonatomic, retain) IBOutlet UITextField  *passwordVerificationField;
@property (nonatomic, retain) IBOutlet UIButton     *submitButton;

@end

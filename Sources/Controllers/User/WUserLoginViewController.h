//
//  WUserLoginViewController.h
//  Woda
//
//  Created by Théo LUBERT on 2/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUserLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIView       *connectingView;
@property (nonatomic, retain) IBOutlet UILabel      *connectingLabel;

@property (nonatomic, retain) IBOutlet UIView       *loginView;
@property (nonatomic, retain) IBOutlet UITextField  *usernameField;
@property (nonatomic, retain) IBOutlet UITextField  *passwordField;

@property (nonatomic, retain) IBOutlet UIButton     *signupButton;
@property (nonatomic, retain) IBOutlet UIButton     *submitButton;

- (IBAction)signup:(id)sender;
- (IBAction)submit:(id)sender;

@end

//
//  WUserLoginViewController.h
//  Woda
//
//  Created by Théo LUBERT on 2/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUserLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIImageView  *logoView;

@property (nonatomic, retain) IBOutlet UIView       *formView;
@property (nonatomic, retain) IBOutlet UILabel      *titleLabel;
@property (nonatomic, retain) IBOutlet UITextField  *serverField;
@property (nonatomic, retain) IBOutlet UITextField  *usernameField;
@property (nonatomic, retain) IBOutlet UITextField  *passwordField;

@property (nonatomic, retain) IBOutlet UIButton     *forgotPasswordButton;
@property (nonatomic, retain) IBOutlet UIButton     *submitButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *connectingIndicator;

- (IBAction)submit:(id)sender;
- (IBAction)forgotPassword:(id)sender;

@end

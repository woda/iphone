//
//  WImagePreviewViewController.h
//  Woda
//
//  Created by Théo LUBERT on 7/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WImagePreviewViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView  *imageView;
@property (nonatomic, retain) IBOutlet UIView       *controlsView;

- (id)initWithImage:(UIImage *)image;


- (IBAction)toggleControls;
- (IBAction)back:(id)sender;

@end

//
//  WDetailViewController.h
//  Woda
//
//  Created by Théo LUBERT on 10/18/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIImageView    *previewImage;
@end

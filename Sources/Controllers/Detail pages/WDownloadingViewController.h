//
//  WDownloadingViewController.h
//  Woda
//
//  Created by Théo LUBERT on 7/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDownloadingViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel  *loadingLabel;
@property (nonatomic, retain) IBOutlet UIView   *progressBarView;
@property (nonatomic, retain) IBOutlet UIView   *progressView;

- (id)initWithFile:(NSDictionary *)info inFolder:(NSString *)path;

@end

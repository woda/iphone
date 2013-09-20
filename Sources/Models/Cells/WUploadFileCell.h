//
//  WUploadFileCell.h
//  Woda
//
//  Created by Théo LUBERT on 7/14/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUploadFileCell : UICollectionViewCell <XibViewDelegate>

@property (nonatomic, retain) IBOutlet UIImageView  *thumbnailView;
@property (nonatomic, retain) IBOutlet UIImageView  *checkView;

@property (nonatomic, retain) IBOutlet UIView       *overlayView;
@property (nonatomic, retain) IBOutlet UIView       *progressBarView;
@property (nonatomic, retain) IBOutlet UIView       *progressView;

@property (nonatomic, retain) NSString *notifName;
@property (nonatomic, retain) NSString *thumbnailPath;

- (void)setInfo:(NSDictionary *)info;

@end

//
//  WFileCell.h
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFileCell : UITableViewCell <XibCellDelegate>

@property (nonatomic, retain) IBOutlet UIView       *background;
@property (nonatomic, retain) IBOutlet UIView       *separator;
@property (nonatomic, retain) IBOutlet UIImageView  *icon;
@property (nonatomic, retain) IBOutlet UILabel      *title;

- (void)setFile:(NSDictionary *)file;
- (void)displaySeparator:(Boolean)display;

@end

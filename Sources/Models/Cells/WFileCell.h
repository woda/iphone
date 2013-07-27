//
//  WFileCell.h
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFileCell : UITableViewCell <XibViewDelegate>

@property (nonatomic, retain) NSString              *path;
@property (nonatomic, retain) NSNumber              *idNumber;

@property (nonatomic, retain) IBOutlet UIView       *background;
@property (nonatomic, retain) IBOutlet UIView       *separator;
@property (nonatomic, retain) IBOutlet UIImageView  *icon;
@property (nonatomic, retain) IBOutlet UIImageView  *star;
@property (nonatomic, retain) IBOutlet UILabel      *title;
@property (nonatomic, retain) IBOutlet UIButton     *favoriteButton;
@property (nonatomic, retain) IBOutlet UIButton     *deleteButton;

- (void)setFile:(NSDictionary *)file;
- (void)displaySeparator:(Boolean)display;

- (IBAction)showOptions:(id)sender;
- (IBAction)putFileInFavorites:(id)sender;
- (IBAction)deleteFile:(id)sender;

@end

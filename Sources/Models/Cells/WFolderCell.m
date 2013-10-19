//
//  WFolderCell.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WFolderCell.h"

@implementation WFolderCell

+ (NSString *)xibName {
    return (@"WFolderCell");
}

+ (NSString *)reuseIdentifier {
    return (@"WFolderCell");
}

- (void)setFolder:(NSDictionary *)folder {
    [self.title setText:[folder objectForKey:@"name"]];
}

- (void)displaySeparator:(Boolean)display {
    [self.separator setHidden:!display];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.folderIcon setImage:[UIImage imageNamed:@"list_icon_folder_white.png"]];
        [self.nextIcon setImage:[UIImage imageNamed:@"list_button_right_arrow_white.png"]];
        [self.background setBackgroundColor:[UIColor colorWithRed:(71.0/255.0) green:(134.0/255.0) blue:(255.0/255.0) alpha:1.0]];
    } else {
        [self.folderIcon setImage:[UIImage imageNamed:@"list_icon_folder.png"]];
        [self.nextIcon setImage:[UIImage imageNamed:@"list_button_right_arrow.png"]];
        [self.background setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setSelected:highlighted animated:animated];
    
    if (highlighted) {
        [self.folderIcon setImage:[UIImage imageNamed:@"list_icon_folder_white.png"]];
        [self.nextIcon setImage:[UIImage imageNamed:@"list_button_right_arrow_white.png"]];
        [self.background setBackgroundColor:[UIColor colorWithRed:(71.0/255.0) green:(134.0/255.0) blue:(255.0/255.0) alpha:1.0]];
        [self.title setTextColor:[UIColor whiteColor]];
    } else {
        [self.folderIcon setImage:[UIImage imageNamed:@"list_icon_folder.png"]];
        [self.nextIcon setImage:[UIImage imageNamed:@"list_button_right_arrow.png"]];
        [self.background setBackgroundColor:[UIColor whiteColor]];
        [self.title setTextColor:[UIColor blackColor]];
    }
}

@end

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

- (NSString *)iconForType:(NSString *)type {
    return (@"list_icon_folder");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.nextIcon setImage:[UIImage imageNamed:@"list_button_right_arrow_white.png"]];
    } else {
        [self.nextIcon setImage:[UIImage imageNamed:@"list_button_right_arrow.png"]];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setSelected:highlighted animated:animated];
    
    if (highlighted) {
        [self.nextIcon setImage:[UIImage imageNamed:@"list_button_right_arrow_white.png"]];
    } else {
        [self.nextIcon setImage:[UIImage imageNamed:@"list_button_right_arrow.png"]];
    }
}

@end

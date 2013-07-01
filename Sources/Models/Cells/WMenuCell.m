//
//  WMenuCell.m
//  Woda
//
//  Created by Théo LUBERT on 6/30/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WMenuCell.h"

@implementation WMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [UIView animateWithDuration:((animated) ? 0.3 : 0.0) animations:^{
        for (UIView *v in self.contentView.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [(UIImageView *)v setHighlighted:selected];
            }
        }
    }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [UIView animateWithDuration:((animated) ? 0.3 : 0.0) animations:^{
        for (UIView *v in self.contentView.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [(UIImageView *)v setHighlighted:highlighted];
            }
        }
    }];
}

@end

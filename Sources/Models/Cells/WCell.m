//
//  WCell.m
//  Woda
//
//  Created by Théo LUBERT on 11/22/12.
//  Copyright (c) 2012 Woda. All rights reserved.
//

#import "WCell.h"

@implementation WCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [UIView animateWithDuration:((animated) ? 0.3 : 0.0) animations:^{
        for (UIView *v in ((UIView *)[self.subviews lastObject]).subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                [(UILabel *)v setHighlighted:selected];
            }
        }
        if (selected) {
            self.backgroundColor = [UIColor colorWithRed:(138.0/255.0)
                                                   green:(186.0/255.0)
                                                    blue:(225.0/255.0)
                                                   alpha:1];
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }
    }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [UIView animateWithDuration:((animated) ? 0.3 : 0.0) animations:^{
        for (UIView *v in ((UIView *)[self.subviews lastObject]).subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                [(UILabel *)v setHighlighted:highlighted ];
            }
        }
        if (highlighted) {
            self.backgroundColor = [UIColor colorWithRed:(138.0/255.0)
                                                   green:(186.0/255.0)
                                                    blue:(225.0/255.0)
                                                   alpha:1];
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }
    }];
}

@end

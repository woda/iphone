//
//  WAssetViewColumn.m
//  Woda
//
//  Created by Théo LUBERT on 7/26/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WAssetViewColumn.h"

@implementation WAssetViewColumn

@synthesize selectedView = _selectedView;

#pragma mark - Setters/Getters

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectedView.hidden = NO;
    
    if (selected) {
        [_selectedView setImage:[UIImage imageNamed:@"list_button_checkbox_ckecked.png"]];
        _selectedView.alpha = 1.0;
    } else {
        [_selectedView setImage:[UIImage imageNamed:@"list_button_checkbox_unckecked.png"]];
        _selectedView.alpha = 0.5;
    }
}

- (UIImageView *)selectedView
{
    if (!_selectedView) {
        
        // Lazily create the selectedView.
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_button_checkbox_unckecked.png"]];
        imageView.alpha = 0.5;
        imageView.hidden = NO;
        [self addSubview:imageView];
        [imageView setFrame:(CGRect) {
            .origin = (CGPoint) {
                .x = imageView.superview.frame.size.width - 20,
                .y = 2
            },
            .size = (CGSize) {
                .width = 18,
                .height = 18
            }
        }];
        
        _selectedView = imageView;
    }
    return _selectedView;
}

@end

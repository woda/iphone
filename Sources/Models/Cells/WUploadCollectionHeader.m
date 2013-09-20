//
//  WUploadCollectionHeader.m
//  Woda
//
//  Created by Théo LUBERT on 9/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUploadCollectionHeader.h"
#import "WUploadSectionHeader.h"

@implementation WUploadCollectionHeader

+ (NSString *)xibName {
    return (@"WUploadCollectionHeader");
}

+ (NSString *)reuseIdentifier {
    return (@"WUploadCollectionHeader");
}

+ (CGSize)sizeForStatus:(NSInteger)status {
    return (CGSize) {
        .width = 320,
        .height = ((status) ? 47 : 60)
    };
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.progressBarView.layer setCornerRadius:1];
    [self.progressView.layer setCornerRadius:1];
}

- (NSInteger)updateStateView:(NSInteger)status ofCollectionView:(UICollectionView *)collectionView {
    if ((status == -1) || (status ^ self.progressBarView.hidden)) {
        CGSize textSize = [self.stateLabel.text sizeWithFont:self.stateLabel.font constrainedToSize:CGSizeMake(200, 20)];
        [self.stateLabel setFrame:(CGRect) {
            .origin = (CGPoint) {
                .x = (self.stateLabel.superview.frame.size.width - textSize.width) / 2,
                .y = (self.stateLabel.superview.frame.size.height - textSize.height - 2) / 2
            },
            .size = textSize
        }];
        
        [self.stateImageView setFrame:(CGRect) {
            .origin = (CGPoint) {
                .x = self.stateLabel.frame.origin.x - textSize.height - 7,
                .y = self.stateLabel.frame.origin.y
            },
            .size = (CGSize) {
                .width = textSize.height,
                .height = textSize.height
            }
        }];
        
        [self.progressBarView setFrame:(CGRect) {
            .origin = (CGPoint) {
                .x = (self.progressBarView.superview.frame.size.width - self.progressBarView.frame.size.width) / 2,
                .y = self.stateLabel.frame.origin.y + self.stateLabel.frame.size.height + 4
            },
            .size = self.progressBarView.frame.size
        }];
        
        NSInteger h = self.frame.size.height;
//        [self setFrame:(CGRect) {
//            .origin = self.frame.origin,
//            .size = (CGSize) {
//                .width = self.frame.size.width,
//                .height = ((self.progressBarView.hidden) ? 47 : 60)
//            }
//        }];
        if (h != self.frame.size.height) {
            [collectionView reloadData];
        }
        
        return self.progressBarView.hidden;
    }
    return status;
}

- (void)upToDate {
    [self.stateLabel setText:NSLocal(@"UpToDate")];
    [self.stateLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:14]];
    [self.stateImageView setImage:[UIImage imageNamed:@"upload_grey_check.png"]];
    [self.stateImageView.layer removeAnimationForKey:@"rotationAnimation"];
    [self.progressBarView setHidden:YES];
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat; {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    if ([view.layer animationForKey:@"rotationAnimation"] == nil) {
        [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)uploading:(NSInteger)count completed:(NSInteger)completed progress:(NSInteger)progress {
    [self.stateLabel setText:[NSString stringWithFormat:@"%d / %d", completed, count]];
    [self.stateLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18]];
    [self.stateImageView setImage:[UIImage imageNamed:@"upload_green_refresh.png"]];
    [self runSpinAnimationOnView:self.stateImageView duration:1 rotations:1 repeat:10000000000];
    [self.progressBarView setHidden:NO];
    
    [self.progressView setFrame:(CGRect) {
        .origin = (CGPoint) {
            .x = 0,
            .y = 0
        },
        .size = (CGSize) {
            .width = self.progressBarView.frame.size.width * progress / 100,
            .height = self.progressBarView.frame.size.height
        }
    }];
}

@end

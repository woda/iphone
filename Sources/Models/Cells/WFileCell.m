//
//  WFileCell.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WFileCell.h"
#import "WRequest+List.h"
#import "WRequest+Sync.h"

@interface WFileCell ()

@property (nonatomic, retain) NSDictionary  *info;

@end

@implementation WFileCell

+ (NSString *)xibName {
    return (@"WFileCell");
}

+ (NSString *)reuseIdentifier {
    return (@"WFileCell");
}

- (Boolean)isFileAnImage:(NSString *)type {
    NSArray *types = [@".png,.jpg,.jpeg" componentsSeparatedByString:@","];
    return ([types indexOfObject:[type lowercaseString]] != NSNotFound);
}

- (Boolean)isFileADocument:(NSString *)type {
    NSArray *types = [@".txt,.doc,.pdf" componentsSeparatedByString:@","];
    return ([types indexOfObject:[type lowercaseString]] != NSNotFound);
}

- (Boolean)isFileAMusic:(NSString *)type {
    NSArray *types = [@".mp3" componentsSeparatedByString:@","];
    return ([types indexOfObject:[type lowercaseString]] != NSNotFound);
}

- (Boolean)isFileAVideo:(NSString *)type {
    NSArray *types = [@".mpeg" componentsSeparatedByString:@","];
    return ([types indexOfObject:[type lowercaseString]] != NSNotFound);
}

- (void)setFile:(NSDictionary *)file {
    self.info = file;
    
    self.favoriteButton.alpha = 0.0;
    self.deleteButton.alpha = 0.0;
    
    self.path = file[@"name"];
    self.idNumber = file[@"id"];
    [self.title setText:file[@"name"]];
    [self.star setHidden:![file[@"favorite"] boolValue]];
    
    NSString *type = file[@"type"];
    if ([self isFileAnImage:type]) {
        [self.icon setImage:[UIImage imageNamed:@"list_icon_picture.png"]];
    } else if ([self isFileADocument:type]) {
        [self.icon setImage:[UIImage imageNamed:@"list_icon_document.png"]];
    } else if ([self isFileAMusic:type]) {
        [self.icon setImage:[UIImage imageNamed:@"list_icon_music.png"]];
    } else if ([self isFileAVideo:type]) {
        [self.icon setImage:[UIImage imageNamed:@"list_icon_movie.png"]];
    } else {
        [self.icon setImage:[UIImage imageNamed:@"list_icon_document.png"]];
    }
    
    [self.deleteButton setTitle:NSLocal(@"Delete") forState:UIControlStateNormal];
    [self.favoriteButton setTitle:NSLocal(@"MarkAsFavorite") forState:UIControlStateNormal];
}

- (void)displaySeparator:(Boolean)display {
    [self.separator setHidden:!display];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.background setBackgroundColor:[UIColor colorWithRed:(71/255.0) green:(134.0/255.0) blue:(244.0/255.0) alpha:1.0]];
    } else {
        [self.background setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setSelected:highlighted animated:animated];
    
    if (highlighted) {
        [self.background setBackgroundColor:[UIColor colorWithRed:(71/255.0) green:(134.0/255.0) blue:(244.0/255.0) alpha:1.0]];
    } else {
        [self.background setBackgroundColor:[UIColor whiteColor]];
    }
}


#pragma mark - Actions methods

- (IBAction)showOptions:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [UIView animateWithDuration:0.3 animations:^{
            self.favoriteButton.alpha = 1.0;
            self.deleteButton.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.favoriteButton.alpha = 0.0;
            self.deleteButton.alpha = 0.0;
        }];
    }
}

- (IBAction)putFileInFavorites:(id)sender {
    if ([self.info[@"favorite"] boolValue]) {
        [WRequest unmarkFileAsFavorite:self.info[@"id"] success:^(id json) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFileMarkedNotificationName object:nil];
        } failure:^(id error) {
            DDLogError(@"Failure while marking '%@'", self.path);
        }];
    } else {
        [WRequest markFileAsFavorite:self.info[@"id"] success:^(id json) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFileMarkedNotificationName object:nil];
        } failure:^(id error) {
            DDLogError(@"Failure while marking '%@'", self.path);
        }];
    }
}

- (IBAction)deleteFile:(id)sender {
    [WRequest removeFile:self.path success:^(id json) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFileDeletedNotificationName object:nil];
    } failure:^(id error) {
        DDLogError(@"Failure while removing '%@'", self.path);
    }];
}

@end

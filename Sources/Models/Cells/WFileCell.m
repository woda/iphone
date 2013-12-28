//
//  WFileCell.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WFileCell.h"
#import "UIImage+ImageEffects.h"
#import "WRequest+List.h"
#import "WRequest+Sync.h"

@interface WFileCell ()

@property (nonatomic, retain) NSDictionary  *info;
@property (nonatomic, retain) NSString      *type;

@end

@implementation WFileCell

+ (NSString *)xibName {
    return (@"WFileCell");
}

+ (NSString *)reuseIdentifier {
    return (@"WFileCell");
}

+ (Boolean)isFileAnImage:(NSString *)type {
    if ([type hasPrefix:@"."])
        type = [type substringFromIndex:1];
    NSArray *types = [@"png,jpg,jpeg" componentsSeparatedByString:@","];
    return ([types indexOfObject:[type lowercaseString]] != NSNotFound);
}

+ (Boolean)isFileADocument:(NSString *)type {
    if ([type hasPrefix:@"."])
        type = [type substringFromIndex:1];
    NSArray *types = [@"txt,doc,pdf" componentsSeparatedByString:@","];
    return ([types indexOfObject:[type lowercaseString]] != NSNotFound);
}

+ (Boolean)isFileAMusic:(NSString *)type {
    if ([type hasPrefix:@"."])
        type = [type substringFromIndex:1];
    NSArray *types = [@"mp3" componentsSeparatedByString:@","];
    return ([types indexOfObject:[type lowercaseString]] != NSNotFound);
}

+ (Boolean)isFileAVideo:(NSString *)type {
    if ([type hasPrefix:@"."])
        type = [type substringFromIndex:1];
    NSArray *types = [@"mpeg,mov,avi,mkv" componentsSeparatedByString:@","];
    return ([types indexOfObject:[type lowercaseString]] != NSNotFound);
}

- (NSString *)iconForType:(NSString *)type {
    if ([WFileCell isFileAnImage:type]) {
        return (@"list_icon_picture");
    } else if ([WFileCell isFileADocument:type]) {
        return (@"list_icon_document");
    } else if ([WFileCell isFileAMusic:type]) {
        return (@"list_icon_music");
    } else if ([WFileCell isFileAVideo:type]) {
        return (@"list_icon_movie");
    }
    return (@"list_icon_document");
}

- (void)orientationChanged:(NSNotification *)notification {
    if (self.blurOverlay.alpha > 0.0) {
        self.blurOverlay.image = [self blurImage:self.background];
    }
}

- (void)setFile:(NSDictionary *)file {
    if (self.info == nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
    }
    
    self.info = file;
    
    self.blurOverlay.alpha = 0.0;
    self.publicButton.alpha = 0.0;
    self.favoriteButton.alpha = 0.0;
    self.deleteButton.alpha = 0.0;
    
    self.path = file[@"name"];
    self.idNumber = file[@"id"];
    [self.title setText:file[@"name"]];
    [self.publicIcon setHidden:![file[@"public"] boolValue]];
    [self.star setHidden:![file[@"favorite"] boolValue]];
    
    self.type = file[@"type"];
    [self.icon setImage:[UIImage imageNamed:[self iconForType:self.type]]];
    
//    [self.deleteButton setTitle:NSLocal(@"Delete") forState:UIControlStateNormal];
    //    [self.favoriteButton setTitle:NSLocal(@"MarkAsFavorite") forState:UIControlStateNormal];
    
    if ([file[@"favorite"] boolValue]) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"btn_no_fav_normal.png"] forState:UIControlStateNormal];
        [self.favoriteButton setImage:[UIImage imageNamed:@"btn_no_fav_highlight.png"] forState:UIControlStateHighlighted];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"btn_fav_normal.png"] forState:UIControlStateNormal];
        [self.favoriteButton setImage:[UIImage imageNamed:@"btn_fav_highlight.png"] forState:UIControlStateHighlighted];
    }
    
    if ([file[@"public"] boolValue]) {
        [self.publicButton setImage:[UIImage imageNamed:@"btn_not_public_normal.png"] forState:UIControlStateNormal];
        [self.publicButton setImage:[UIImage imageNamed:@"btn_not_public_highlight.png"] forState:UIControlStateHighlighted];
    } else {
        [self.publicButton setImage:[UIImage imageNamed:@"btn_public_normal.png"] forState:UIControlStateNormal];
        [self.publicButton setImage:[UIImage imageNamed:@"btn_publi_highlight.png"] forState:UIControlStateHighlighted];
    }
}

- (void)displaySeparator:(Boolean)display {
    [self.separator setHidden:!display];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.icon setImage:[UIImage imageNamed:[[self iconForType:self.type] stringByAppendingString:@"_white"]]];
        [self.background setBackgroundColor:[UIColor colorWithRed:(71.0/255.0) green:(134.0/255.0) blue:(255.0/255.0) alpha:1.0]];
        [self.title setTextColor:[UIColor whiteColor]];
    } else {
        [self.icon setImage:[UIImage imageNamed:[self iconForType:self.type]]];
        [self.background setBackgroundColor:[UIColor whiteColor]];
        [self.title setTextColor:[UIColor blackColor]];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setSelected:highlighted animated:animated];
    
    if (highlighted) {
        [self.icon setImage:[UIImage imageNamed:[[self iconForType:self.type] stringByAppendingString:@"_white"]]];
        [self.background setBackgroundColor:[UIColor colorWithRed:(71.0/255.0) green:(134.0/255.0) blue:(255.0/255.0) alpha:1.0]];
        [self.title setTextColor:[UIColor whiteColor]];
    } else {
        [self.icon setImage:[UIImage imageNamed:[self iconForType:self.type]]];
        [self.background setBackgroundColor:[UIColor whiteColor]];
        [self.title setTextColor:[UIColor blackColor]];
    }
}


#pragma mark - Actions methods

- (UIImage *)blurImage:(UIView *)v {
    UIGraphicsBeginImageContext(v.bounds.size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [viewImage applyBlurWithRadius:2 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (IBAction)showOptions:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.selected = NO;
        self.blurOverlay.image = [self blurImage:self.background];
        [UIView animateWithDuration:0.3 animations:^{
            self.blurOverlay.alpha = 1.0;
            self.publicButton.alpha = 1.0;
            self.favoriteButton.alpha = 1.0;
            self.deleteButton.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.blurOverlay.alpha = 0.0;
            self.publicButton.alpha = 0.0;
            self.favoriteButton.alpha = 0.0;
            self.deleteButton.alpha = 0.0;
        }];
    }
}

- (IBAction)putInPublicFiles:(id)sender {
    if ([self.info[@"public"] boolValue]) {
        [WRequest unmarkFileAsPublic:self.info[@"id"] success:^(id json) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFileMarkedNotificationName object:nil];
        } failure:^(id error) {
            DDLogError(@"Failure while making '%@' private", self.path);
        }];
    } else {
        [WRequest markFileAsPublic:self.info[@"id"] success:^(id json) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFileMarkedNotificationName object:nil];
        } failure:^(id error) {
            DDLogError(@"Failure while making '%@' public", self.path);
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
    [WRequest removeFile:self.info[@"id"] success:^(id json) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFileDeletedNotificationName object:nil];
    } failure:^(id error) {
        DDLogError(@"Failure while removing '%@'", self.path);
    }];
}

@end

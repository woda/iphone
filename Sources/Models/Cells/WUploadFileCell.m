//
//  WUploadFileCell.m
//  Woda
//
//  Created by Théo LUBERT on 7/14/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WUploadFileCell.h"
#import "WUploadManager.h"

static const int ddLogLevel = LOG_LEVEL_INFO;


@implementation WUploadFileCell

+ (NSString *)xibName {
    return (@"WUploadFileCell");
}

+ (NSString *)reuseIdentifier {
    return (@"WUploadFileCell");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.thumbnailView setContentMode:UIViewContentModeCenter];
    [self.thumbnailView setImage:[UIImage imageNamed:@"list_icon_picture.png"]];
    
    [self.overlayView setHidden:YES];
    
    [self.checkView setImage:[UIImage imageNamed:@"upload_grey_dot.png"]];
    [self.checkView setHidden:NO];
    
    [self.progressView setFrame:(CGRect) {
        .origin = CGPointZero,
        .size = (CGSize) {
            .width = 0,
            .height = self.progressBarView.frame.size.height
        }
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    [self.progressBarView.layer setCornerRadius:1];
    [self.progressView.layer setCornerRadius:1];
    
    [self.thumbnailView.layer setCornerRadius:3];
    [self.thumbnailView.layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:0.2].CGColor];
    [self.thumbnailView.layer setBorderWidth:1];
}


#pragma mark - Data related methods

- (Boolean)isFileAnImage:(NSString *)type {
    NSArray *types = [@"public.image,.png,.jpg,.jpeg" componentsSeparatedByString:@","];
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

- (void)setIcon:(NSString *)type {
    if ([self isFileAnImage:type]) {
        [self.thumbnailView setImage:[UIImage imageNamed:@"list_icon_picture.png"]];
    } else if ([self isFileADocument:type]) {
        [self.thumbnailView setImage:[UIImage imageNamed:@"list_icon_document.png"]];
    } else if ([self isFileAMusic:type]) {
        [self.thumbnailView setImage:[UIImage imageNamed:@"list_icon_music.png"]];
    } else if ([self isFileAVideo:type]) {
        [self.thumbnailView setImage:[UIImage imageNamed:@"list_icon_movie.png"]];
    } else {
        [self.thumbnailView setImage:[UIImage imageNamed:@"list_icon_document.png"]];
    }
}

//Data: {
//    kUploadAssetURL = "assets-library://asset/asset.JPG?id=1C99FAAD-42E7-4CD7-9ABE-12FB7C296C34&ext=JPG";
//    kUploadDate = "2013-07-17 17:55:31 +0000";
//    kUploadFileName = "IMG_0001.JPG";
//    kUploadMediaType = "public.image";
//    kUploadNeedsUpload = 0;
//    kUploadProgress = 0; // 0-100
//    kUploadThumbnail = "/Users/teos/Library/.../Thumbails/3AD2416F-3B5E-4E1D-88A9-05D3A36733ED-3454-00007524A80E10DF.png";
//}

- (void)setInfo:(NSDictionary *)info {
    [self prepareForReuse];
    
    DDLogInfo(@"info: %@", info);
    
    Boolean uploaded = ![info[kUploadNeedsUpload] boolValue];
    NSInteger progress = [info[kUploadProgress] integerValue];
    NSString *thumbnailPath = info[kUploadThumbnail];
    NSString *notifName = info[kUploadNotificationName];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (notifName) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoChanged:) name:notifName object:nil];
    }
    
    if (thumbnailPath) {
        NSData *data = [NSData dataWithContentsOfFile:thumbnailPath];
        UIImage *thumbnail = [UIImage imageWithData:data];
        [self.thumbnailView setContentMode:UIViewContentModeScaleAspectFill];
        [self.thumbnailView setImage:thumbnail];
    } else {
        [self setIcon:info[kUploadMediaType]];
    }
    if (uploaded) {
        [self.checkView setImage:[UIImage imageNamed:@"upload_green_check.png"]];
    } else if (progress > 0) {
        [self.progressView setFrame:(CGRect) {
            .origin = CGPointZero,
            .size = (CGSize) {
                .width = self.progressBarView.frame.size.width * progress / 100,
                .height = self.progressBarView.frame.size.height
            }
        }];
        [self.overlayView setHidden:NO];
        [self.checkView setHidden:YES];
    }
}

- (void)infoChanged:(NSNotification *)notif {
    [self prepareForReuse];
    [self setInfo:notif.userInfo];
}

@end

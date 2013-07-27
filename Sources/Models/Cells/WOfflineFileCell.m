//
//  WOfflineFileCell.m
//  Woda
//
//  Created by Théo LUBERT on 7/26/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WOfflineFileCell.h"
#import "WOfflineManager.h"
#import "WRequest.h"

@implementation WOfflineFileCell

+ (NSString *)xibName {
    return (@"WOfflineFileCell");
}

+ (NSString *)reuseIdentifier {
    return (@"WOfflineFileCell");
}

- (void)setFile:(NSDictionary *)file {
    [super setFile:file];
    
    [self.favoriteButton setHidden:YES];
    [self.star setHidden:YES];
    
    [self.deleteButton setTitle:NSLocal(@"OnlineOnly") forState:UIControlStateNormal];
    [self.deleteButton setBackgroundColor:[UIColor colorWithRed:(71/255.0) green:(134.0/255.0) blue:(244.0/255.0) alpha:1.0]];
}


#pragma mark - Actions methods

- (IBAction)deleteFile:(id)sender {
    [[WOfflineManager shared] removeFileForId:self.idNumber];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFileDeletedNotificationName object:nil];
}

@end

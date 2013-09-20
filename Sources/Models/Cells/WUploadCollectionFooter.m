//
//  WUploadCollectionFooter.m
//  Woda
//
//  Created by Théo LUBERT on 9/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUploadCollectionFooter.h"
#import "WUploadManager.h"

@implementation WUploadCollectionFooter

+ (NSString *)xibName {
    return (@"WUploadCollectionFooter");
}

+ (NSString *)reuseIdentifier {
    return (@"WUploadCollectionFooter");
}

+ (CGSize)size {
    return (CGSize) {
        .width = 320,
        .height = 44
    };
}

- (void)update:(NSArray *)data {
    NSInteger count = 0;
    for (NSDictionary *period in data) {
        count += [period[@"info"] count];
    }
    [self.countLabel setText:[NSString stringWithFormat:@"%d files", count]];
    if (count > 0) {
        [self.updatedLabel setText:[NSString stringWithFormat:@"Last updated: %@", [data[0][@"info"][0][kUploadDate] toFormat:@"MM/dd/yyyy' at 'hh:mm a"]]];
    } else {
        [self.updatedLabel setText:@""];
    }
}

@end

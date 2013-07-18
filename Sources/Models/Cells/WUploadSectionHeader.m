//
//  WUploadSectionHeader.m
//  Woda
//
//  Created by Théo LUBERT on 7/17/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "WUploadSectionHeader.h"

@implementation WUploadSectionHeader

+ (NSString *)xibName {
    return (@"WUploadSectionHeader");
}

+ (NSString *)reuseIdentifier {
    return (@"WUploadSectionHeader");
}

+ (NSString *)sectionTitleForPeriod:(NSString *)period {
    if ([period isEqualToString:[[NSDate date] toFormat:@"yyyy-MM-dd"]]) {
        period = NSLocal(@"Today");
    } else if ([period isEqualToString:[[NSDate dateWithTimeInterval:-(24*3600) sinceDate:[NSDate date]] toFormat:@"yyyy-MM-dd"]]) {
        period = NSLocal(@"Yesterday");
    } else {
        period = [NSDate date:period fromFormat:@"yyyy-MM" toFormat:@"MMMM yyyy"];
    }
    return ([period uppercaseString]);
}

- (void)setPeriod:(NSString *)period {
    [self prepareForReuse];
    [self.titleLabel setText:[WUploadSectionHeader sectionTitleForPeriod:period]];
}

@end

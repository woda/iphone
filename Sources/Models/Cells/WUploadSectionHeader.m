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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        self.titleLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
}

- (void)setPeriod:(NSString *)period {
    self.titleLabel.text = [WUploadSectionHeader sectionTitleForPeriod:period];
}

@end

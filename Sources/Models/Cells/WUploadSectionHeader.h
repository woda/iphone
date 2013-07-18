//
//  WUploadSectionHeader.h
//  Woda
//
//  Created by Théo LUBERT on 7/17/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUploadSectionHeader : UICollectionReusableView <XibViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel     *titleLabel;

+ (NSString *)sectionTitleForPeriod:(NSString *)period;

- (void)setPeriod:(NSString *)period;

@end

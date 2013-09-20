//
//  WUploadCollectionFooter.h
//  Woda
//
//  Created by Théo LUBERT on 9/19/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WUploadCollectionFooter : UICollectionReusableView <XibViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel          *countLabel;
@property (nonatomic, retain) IBOutlet UILabel          *updatedLabel;

+ (CGSize)size;

- (void)update:(NSArray *)files;

@end

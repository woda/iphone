//
//  WFileItem.h
//  Woda
//
//  Created by Théo LUBERT on 10/25/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface WFileItem : NSObject <QLPreviewItem>

@property (nonatomic, retain) NSURL         *url;
@property (nonatomic, retain) NSDictionary  *info;

+ (WFileItem *)fileWithInfo:(NSDictionary *)info;

@end

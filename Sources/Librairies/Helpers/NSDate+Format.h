//
//  NSDate+Format.h
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Format)

+ (NSString *)date:(NSString *)input fromFormat:(NSString *)inputFormat toFormat:(NSString *)outputFormat;

- (NSString *)toFormat:(NSString *)outputFormat;

@end

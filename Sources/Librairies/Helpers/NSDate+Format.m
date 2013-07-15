//
//  NSDate+Format.m
//  Woda
//
//  Created by Théo LUBERT on 7/2/13.
//  Copyright (c) 2013 Woda. All rights reserved.
//

#import "NSDate+Format.h"

@implementation NSDate (Format)

+ (NSString *)date:(NSString *)input fromFormat:(NSString *)inputFormat toFormat:(NSString *)outputFormat {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:inputFormat];
    NSDate *date = [df dateFromString:input];
    
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:outputFormat];
    [df setAMSymbol:@"AM"];
    [df setPMSymbol:@"PM"];
    NSString *dateString = [df stringFromDate:date];
    
    return (dateString);
}

@end

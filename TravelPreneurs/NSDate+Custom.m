//
//  NSDate+Dubb.m
//  Dubb
//
//  Created by Stanislas Chevallier on 07/06/14.
//  Copyright (c) 2014 Dubb. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

+ (BOOL)date:(NSDate*)date1 isEqualToDate:(NSDate*)date2 {
    if(date1 == nil && date2 == nil)
        return YES;
    if(date1 == nil || date2 == nil)
        return NO;
    return [date1 isEqualToDate:date2];
}

+ (BOOL)isValid:(NSDate*)date mustHavePositiveTimestamp:(BOOL)positiveTimestamp {
    return date && ![date isEqual:[NSNull null]] && (positiveTimestamp ? [date timeIntervalSince1970] > 0 : YES);
}

+ (instancetype)now {
    return [self date];
}

- (BOOL)isNewerThan:(NSDate*)date {
    return [self timeIntervalSinceDate:date] > 0;
}

- (NSDate *)dateFromGMTDate {
    return [self dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMT]];
}

- (NSDate *)dateToGMTDate {
    return [self dateByAddingTimeInterval:(-[[NSTimeZone localTimeZone] secondsFromGMT])];
}



+ (NSDate *)mostRecentDate:(NSArray *)dates {
    if(![dates count])
        return nil;
    
    NSDate *maxDate = [dates firstObject];
    
    for(NSDate *date in dates)
        if([date timeIntervalSince1970] > [maxDate timeIntervalSince1970])
            maxDate = date;
    
    return maxDate;
}

+ (NSString *) getCurrentTime {
    
    NSDate *nowUTC = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    /*NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:tz];*/
    return [dateFormatter stringFromDate:nowUTC];
    
}

+ (NSString *) getCommonTimeStr:(NSDate*) date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    /*NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:tz];*/
    return [dateFormatter stringFromDate:date];
    
}

+ (NSString *) getLocaleTimeStr:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:tz];
    NSDate *utcDate = [dateFormatter dateFromString:time];
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    return [dateFormatter stringFromDate:utcDate];
    
}

+ (NSString *) get7DaysAgoCurrentTime {
    NSDate *now = [NSDate date];
    int daysToAdd = -7;
    NSDate *newDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:tz];
    return [dateFormatter stringFromDate:newDate];
    
}



+ (NSString *) getFormattedCurrentTime {
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:locale];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df setTimeZone:tz];
    
    NSString *timeStr = [df stringFromDate:date];
    return timeStr;
}


@end

//
//  NSDate+Dubb.h
//  Dubb
//
//  Created by Stanislas Chevallier on 07/06/14.
//  Copyright (c) 2014 Dubb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Custom)

+ (BOOL)date:(NSDate*)date1 isEqualToDate:(NSDate*)date2;
+ (BOOL)isValid:(NSDate*)date mustHavePositiveTimestamp:(BOOL)positiveTimestamp;
+ (instancetype)now;

- (BOOL)isNewerThan:(NSDate*)date;

- (NSDate *)dateToGMTDate;
- (NSDate *)dateFromGMTDate;

+ (NSDate *)mostRecentDate:(NSArray *)dates;

+ (NSString *) getCurrentTime;
+ (NSString *) getCommonTimeStr:(NSDate*) date;
+ (NSString *) getLocaleTimeStr:(NSString *)time;
+ (NSString *) get7DaysAgoCurrentTime;
+ (NSString *) getFormattedCurrentTime;
@end

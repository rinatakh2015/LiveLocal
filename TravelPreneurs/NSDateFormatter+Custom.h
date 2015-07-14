//
//  NSDateFormatter+Dubb.h
//  Dubb
//
//  Created by Stanislas Chevallier on 30/05/14.
//  Copyright (c) 2014 Dubb. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSDateFormatter (Custom)

+ (NSDateFormatter *)jsonDateFormatter;
+ (NSDateFormatter *)rfc822DateFormatter;
+ (NSDateFormatter *)commonDateFormatter;
+ (BOOL)is24hFormat;

@end

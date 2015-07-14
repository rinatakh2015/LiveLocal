#import "NSObject+Parsing.h"


@implementation NSObject (Parsing)

- (int)parseInteger {
    if ([self isEqual:[NSNull null]]) {
        return 0;
    }

    return [(NSNumber *) self intValue];
}

- (double)parseDouble {
    if ([self isEqual:[NSNull null]]) {
        return 0;
    }
    
    return [(NSNumber *) self doubleValue];
}

- (NSString*)parseString {
    if ([self isEqual:[NSNull null]]) {
        return nil;
    }
    
    if ([self isKindOfClass:[NSNumber class]])
        return [(NSNumber *)self stringValue];

    return [self description];
}

- (BOOL)parseBool {
    if ([self isEqual:[NSNull null]]) {
        return false;
    }

    return [(NSNumber *) self boolValue];
}

- (NSDate *)parseDateWithFormatter:(NSDateFormatter *)dateFormatter {

    if ([self isEqual:[NSNull null]]) {
        return nil;
    }

    NSLocale *locale = [[NSLocale alloc]
            initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];

    NSDate *date = [dateFormatter dateFromString:(NSString*)self];

    return date;
}

@end
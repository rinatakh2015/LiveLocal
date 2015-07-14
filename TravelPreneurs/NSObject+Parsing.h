#import <Foundation/Foundation.h>

@interface NSObject (Parsing)
- (int)parseInteger;

- (double)parseDouble;

- (NSString *)parseString;

- (BOOL)parseBool;

- (NSDate*)parseDateWithFormatter:(NSDateFormatter*)dateFormatter;
@end
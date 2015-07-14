#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Custom)

// Generic string methods
- (BOOL)isEmpty;
- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString;

+ (BOOL)isEmpty:(NSString*)string;
+ (BOOL)string:(NSString*)str1 isEqualToString:(NSString*)str2;
+ (BOOL)string:(NSString *)string1 isEqualToStringCaseInsensitive:(NSString *)string2;

+ (NSString*)string:(NSString*)str1 fallback:(NSString*)str2;

- (NSString*)replaceLineBreaksWith:(NSString*)separator;
- (NSString *)stringByRemovingWhiteSpacesPrefixAndSuffix;

// Phone and email related methods
- (BOOL)isValidEmail;

// Country code related methods
- (NSString*)countryFromCountryCode;

// URL related methods
- (NSDictionary*)urlParametersAsDictionary;

- (CGSize)sizeForMaxWidth:(CGFloat)width withFont:(UIFont *)font;

+ (NSString *) getUnicodeStrFrom:(NSString *) str;
@end

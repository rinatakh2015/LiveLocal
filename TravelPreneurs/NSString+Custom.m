#import "NSString+Custom.h"
#import "NSArray+Custom.h"
#import "NSArray+Linq.h"
@implementation NSString (Custom)

#pragma mark - Generic string methods

- (BOOL)isEmpty {
    return !self.length || [self isEqual:[NSNull null]];
}

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString {
    return ([self compare:aString options:NSCaseInsensitiveSearch] == NSOrderedSame);
}

+ (BOOL)isEmpty:(NSString*)string {
    return !string || [string isEmpty];
}

+ (BOOL)string:(NSString*)str1 isEqualToString:(NSString*)str2 {
    if(str1 == nil && str2 == nil)
        return YES;
    if(str1 == nil || str2 == nil)
        return NO;
    return [str1 isEqualToString:str2];
}

+ (BOOL)string:(NSString *)string1 isEqualToStringCaseInsensitive:(NSString *)string2 {
    if([NSString isEmpty:string1]) {
        if([NSString isEmpty:string2])
            return YES;
        return [string2 isEqualToStringCaseInsensitive:string1];
    }
    return [string1 isEqualToStringCaseInsensitive:string2];
}

// returns str1 if valid (!nil, !NSNull, !@""), othrwise str2
+ (NSString*)string:(NSString*)str1 fallback:(NSString*)str2 {
    if(![NSString isEmpty:str1])
        return str1;
    return str2;
}

- (NSString*)replaceLineBreaksWith:(NSString*)separator {
    return [[[self stringByReplacingOccurrencesOfString:@"\r\n" withString:separator]
             stringByReplacingOccurrencesOfString:@"\r"   withString:separator]
            stringByReplacingOccurrencesOfString:@"\r"   withString:separator];
}

- (NSString *)stringByRemovingWhiteSpacesPrefixAndSuffix {
    NSString *result = self;
    
    while([result hasPrefix:@" "] || [result hasPrefix:@"\n"] || [result hasPrefix:@"\t"]) {
        result = [result substringFromIndex:1];
    }
    
    while([result hasSuffix:@" "] || [result hasSuffix:@"\n"] || [result hasSuffix:@"\t"]) {
        result = [result substringToIndex:([result length] - 2)];
    }
    
    return result;
}

#pragma mark - Phone and email related methods

- (BOOL)isValidEmail {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @"[^@]+@[^.@]+(\\.[^.@]+)+";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

#pragma mark - Country code related methods

- (NSString *)countryFromCountryCode {
    return [[[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"] displayNameForKey:NSLocaleCountryCode value:self];
}

#pragma mark - URL related methods

- (NSDictionary *)urlParametersAsDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSString *parametersString = [[self componentsSeparatedByString:@"?"] lastOrNil];
    if(!parametersString)
        return @{};
    
    NSArray *parameters = [parametersString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters)
    {
        NSArray *parts = [parameter componentsSeparatedByString:@"="];
        NSString *key = [[parts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([parts count] > 1)
        {
            id value = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [result setObject:value forKey:key];
        }
    }
    return result;
}

+ (CGSize)sizeForText:(id)text withMaxWidth:(CGFloat)width withFont:(UIFont *)font
{
    NSTextStorage *textStorage = nil;
    
    if([text isKindOfClass:[NSAttributedString class]])
        textStorage = [[NSTextStorage alloc] initWithAttributedString:(NSAttributedString *)text];
    else
        textStorage = [[NSTextStorage alloc] initWithString:(NSString *)text];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: CGSizeMake(width, MAXFLOAT)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:font
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    
    [layoutManager glyphRangeForTextContainer:textContainer];
    CGRect frame = [layoutManager usedRectForTextContainer:textContainer];
    return CGSizeMake(ceilf(frame.size.width),ceilf(frame.size.height));
}

- (CGSize)sizeForMaxWidth:(CGFloat)width withFont:(UIFont *)font
{
    return [[self class] sizeForText:self withMaxWidth:width withFont:font];
}

+ (NSString *) getUnicodeStrFrom:(NSString *) str {
    NSData *data = [str dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *unicodeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return unicodeStr;
}

@end

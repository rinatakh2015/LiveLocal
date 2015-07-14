//
//  MySingleton.m
//  LeaderBoard
//
//  Created by cgh on 9/4/13.
//  Copyright (c) 2013 shinan. All rights reserved.
//

#import "MyUtils.h"
#import "NSObject+SBJson.h"
#import "QuartzCore/QuartzCore.h"
#import "defs.h"
#import "MyEnums.h"
#import "NSString+Translate.h"

@implementation MyUtils

- (id) initSingleton
{
    if ((self = [super init]))
    {
        _user = [[User alloc] init];
        _tempUser = [[User alloc] init];
        _currentLocation = nil;
        _searchRadius = 5;
        _chatMessages = [[NSMutableDictionary alloc] init];
        _chatRedFlagDic = [[NSMutableDictionary alloc] init];
        _translationDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (MyUtils *) shared
{
    // Persistent instance.
    static MyUtils *_default = nil;
    
    // Small optimization to avoid wasting time after the
    // singleton being initialized.
    if (_default != nil)
    {
        return _default;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    // Allocates once with Grand Central Dispatch (GCD) routine.
    // It's thread safe.
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void)
                  {
                      _default = [[MyUtils alloc] initSingleton];
                  });
#else
    // Allocates once using the old approach, it's slower.
    // It's thread safe.
    @synchronized([MySingleton class])
    {
        // The synchronized instruction will make sure,
        // that only one thread will access this point at a time.
        if (_default == nil)
        {
            _default = [[MyUtils alloc] initSingleton];
        }
    }
#endif
    
    return _default;
}


-(void) makeCircleView:(UIView *)view{
    CGRect bound = view.bounds;
    view.layer.cornerRadius = bound.size.width / 2;
    //view.clipsToBounds = YES;
    view.layer.masksToBounds = YES;
}

-(void) makeCircleViewWithBorder:(UIView *)view BorderWidth:(int) borderWidth BorderColor:(UIColor*) borderColor{
    CGRect bound = view.bounds;
    view.layer.cornerRadius = bound.size.width / 2;
    view.clipsToBounds = YES;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = [borderColor CGColor];

}

-(void) makeRectOutlineOfView:(UIView *)view{
    //CGRect bound = view.bounds;
    //view.layer.cornerRadius = bound.size.width / 2;
    //view.clipsToBounds = YES;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 2.0;
    view.layer.borderColor = [[UIColor colorWithRed:111/255.f green:185/255.f blue:236/255.f alpha:1] CGColor];
}


-(void)applyDefaultFonts:(UIView*)parentView{
    NSArray *subViews = [parentView subviews];
    for (UIView* view in subViews) {
        if ([view class] == [UITextView class]) {
            UITextView* textView = (UITextView*)view;
            UIFont* oldFont = [textView font];
            if([textView tag] == 1001)
            {
                UIFont *font = [UIFont fontWithName:@"segoeui-semibold" size:[oldFont pointSize]];
                [textView setFont:font];
            }
            else{
                UIFont *font = [UIFont fontWithName:@"segoeui-light" size:[oldFont pointSize]];
                [textView setFont:font];
            }
        }
        else if([view class] == [UILabel class])
        {
            UILabel* labelView = (UILabel*)view;
            UIFont* oldFont = [labelView font];
            if([labelView tag] == 1001)
            {
                UIFont *font = [UIFont fontWithName:@"segoeui-semibold" size:[oldFont pointSize]];
                [labelView setFont:font];
            }
            else{
                UIFont *font = [UIFont fontWithName:@"segoeui-light" size:[oldFont pointSize]];
                [labelView setFont:font];
            }
        }
        else if([view class] == [UIButton class])
        {
            UIButton* buttonView = (UIButton*)view;
            UIFont* oldFont = buttonView.titleLabel.font;
            if([buttonView tag] == 1001)
            {
                UIFont *font = [UIFont fontWithName:@"segoeui-semibold" size:[oldFont pointSize]];
                buttonView.titleLabel.font = font;
            }
            else{
                UIFont *font = [UIFont fontWithName:@"segoeui-light" size:[oldFont pointSize]];
                buttonView.titleLabel.font = font;
            }
        }
        else{
            [[MyUtils shared]applyDefaultFonts:view];
        }
    }
}

-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}


-(NSString*) convertMainCategoryToString: (TPMainCategory) category
{
    NSString* string;
    switch (category) {
        case TPMainCategory_DINING:
            string = [@"Dining" translate];
            break;
        case TPMainCategory_ACTIVITIES :
            string = [@"Activities" translate];
            break;
        case TPMainCategory_HEALTH:
            string = [@"Health" translate];
            break;
        case TPMainCategory_SERVICES:
            string = [@"Services" translate];
            break;
        case TPMainCategory_NIGHTLIFE:
            string = [@"Nightlife" translate];
            break;
        case TPMainCategory_SHOPPING:
            string = [@"Shopping" translate];
            break;
        case TPMainCategory_TRANSPORT:
            string = [@"Transport" translate];
            break;
        case TPMainCategory_TOURISM:
            string = [@"Tourism" translate];
            break;
        case TPMainCategory_EVENTS:
            string = [@"Events" translate];
            break;
    }
    
    return string;
}

-(NSString*) getChattingRoomIdentifierWith:(long)userIdentifier
{
    if(self.user.identifier > userIdentifier)
        return [NSString stringWithFormat:@"%ld-%ld", userIdentifier, self.user.identifier];
    else
        return [NSString stringWithFormat:@"%ld-%ld", self.user.identifier, userIdentifier];
}

-(void)setTranslationLanguage:(NSString *)language
{
    NSString* translation;
    NSMutableDictionary* translatationDic = [[NSMutableDictionary alloc] init];
    if([[NSBundle mainBundle] pathForResource:[language lowercaseString] ofType:@"tr"])
    {
        NSString* fName = [[NSBundle mainBundle] pathForResource:[language lowercaseString] ofType:@"tr"];
        translation = [NSString stringWithContentsOfFile:fName encoding:NSUTF8StringEncoding error:nil];
    }
    else{
        NSString* fName = [[NSBundle mainBundle] pathForResource:@"english" ofType:@"tr"];
        translation = [NSString stringWithContentsOfFile:fName encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSArray* translationArray = [translation componentsSeparatedByString:@"\n"];
    for (NSString* line in translationArray) {
        NSArray* keyvalues = [line componentsSeparatedByString:@"="];
        if(keyvalues.count == 2)
            [translatationDic setObject:[keyvalues objectAtIndex:1] forKey:[[keyvalues objectAtIndex:0] lowercaseString]];
    }
    self.translationDic = translatationDic;
}

-(NSString*)translateWith:(NSString*)key
{
    if (!key) {
        return nil;
    }
    NSString* words = [self.translationDic objectForKey:[key lowercaseString]];
    return words ?: key;
}

-(void)applyTranslation:(UIView*)parentView{
    NSArray *subViews = [parentView subviews];
    for (UIView* view in subViews) {
        if ([view class] == [UITextView class]) {
            UITextView* textView = (UITextView*)view;
            NSString* t = [self translateWith:textView.text];
            if (t) {
                textView.text =t;
            }
        }
        else if ([view class] == [UITextField class]) {
            UITextField* textField = (UITextField*)view;
            NSString* t = [self translateWith:textField.placeholder];
            if (t) {
                textField.placeholder =t;
            }
        }
        else if([view class] == [UILabel class])
        {
            UILabel* labelView = (UILabel*)view;
            NSString* t = [self translateWith:labelView.text];
            if (t) {
                labelView.text = t;
            }
        }
        else if([view class] == [UIButton class])
        {
            UIButton* buttonView = (UIButton*)view;
            NSString* t = [self translateWith:buttonView.titleLabel.text];
            if (t) {
                buttonView.titleLabel.text = t;
            }
        }
        else{
            [[MyUtils shared]applyTranslation:view];
        }
    }
}

@end

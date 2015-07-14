//
//  TPLanguagePickerView.m
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "LanguagePickerView.h"
#import "defs.h"

#define PLACEHOLDER @"---"

@interface LanguagePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation LanguagePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)setDataSource:(__unused id<UIPickerViewDataSource>)dataSource
{
    //does nothing
}

- (void)setUp
{
    super.dataSource = self;
    super.delegate = self;


    _mLanguageStandards =@[
                           @"English",
                           @"French",
                           @"German",
                           @"Italian",
                           @"Spanish",
                           @"Portuguese",
                           @"Arabic",
                           @"Mandarin",
                           @"Japanese",
                           @"Korean",
                           @"Turkish",
                           @"Hindi",
                           @"Thai",
                           @"Russian",
                           @"Greek",
                           @"Hebrew",
                           /*@"Filipino",*/
                           @"Vietnamese",
                           @"Bulgarian",
                           @"Lao",
                           @"Indonesian",
                           @"Malaysian",
                           @"Khmer",
                           @"Romanian",
                           @"Hungarian",
                           @"Czech"];
    
    if (self.isShort) {
        _mLanguagesNatives=@[
                             @"English",
                             @"Français",
                             @"Deutsch",
                             @"Italiano",
                             @"Español",
                             @"Português", @"العربية",
                             @"中文",
                             @"日本語",
                             @"한국어",
                             @"Türkçe",
                             @"हिंदी",
                             @"ภาษาไทย",
                             @"русский",
                             @"ελληνικά",@"עברית",
                             /*@"Tagalog",*/
                             @"Tiếng Việt",
                             @"български",
                             @"ລາວ",
                             @"B. Indonesia",
                             @"B. Malaysia",
                             @"ខ្មែរ",
                             @"Român",
                             @"Maghiară",
                             @"Cehă"];
    }
    else{
    _mLanguagesNatives=@[
                         @"English",
                         @"Français",
                         @"Deutsch",
                         @"Italiano",
                         @"Español",
                         @"Português",@"العربية",
                         @"中文",
                         @"日本語",
                         @"한국어",
                         @"Türkçe",
                         @"हिंदी",
                         @"ภาษาไทย",
                         @"русский",
                         @"ελληνικά",@"עברית",
                         /*@"Tagalog",*/
                         @"Tiếng Việt",
                         @"български",
                         @"ລາວ",
                         @"Bahasa Indonesia",
                         @"Bahasa Malaysia",
                         @"ខ្មែរ",
                         @"Român",
                         @"Maghiară",
                         @"Cehă"];
    }
    
}

-(BOOL) selectLanguage:(NSString*) language
{
    if (!language || language.length == 0) {
        language = @"English";
    }
    
    if ([language isEqualToString:PLACEHOLDER]) {
        [self selectRow:0 inComponent:0 animated:NO];
        return YES;
    }
    int index = [_mLanguageStandards indexOfObject:language];
    
    if(self.hasPlaceHolder) index++;
    
    if (index < 0 || index >= (!_hasPlaceHolder ? _mLanguageStandards.count : _mLanguageStandards.count + 1)) {
        return NO;
    }
    [self selectRow:index inComponent:0 animated:NO];
    return YES;
}

-(NSString*) standardLangaugeOfSelectedRow{
    if (!self.hasPlaceHolder) {
        return [_mLanguageStandards objectAtIndex:[self selectedRowInComponent:0]];
    }
    else{
        int i = [self selectedRowInComponent:0];
        if (i == 0) {
            return PLACEHOLDER;
        }
        else
        {
            return [_mLanguageStandards objectAtIndex:[self selectedRowInComponent:0] - 1];
        }
    }
    
    return nil;
}
#pragma mark -
#pragma mark UIPicker

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView numberOfRowsInComponent:(__unused NSInteger)component
{
    return !self.hasPlaceHolder ? (NSInteger)[_mLanguageStandards count] : (NSInteger)[_mLanguageStandards count] + 1;
}

- (UIView *)pickerView:(__unused UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(__unused NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, self.frame.size.width , 24)];
        label.font = [UIFont systemFontOfSize: LABEL_FONTSIZE];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        [view addSubview:label];
    }
    if (!self.hasPlaceHolder) {
        ((UILabel *)[view viewWithTag:1]).text = (NSString*)[_mLanguagesNatives objectAtIndex:row];
    }
    else{
        if (row == 0) {
            ((UILabel *)[view viewWithTag:1]).text = PLACEHOLDER;
        }
        else{
            ((UILabel *)[view viewWithTag:1]).text = (NSString*)[_mLanguagesNatives objectAtIndex:row  - 1];
        }
    }
    
    return view;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 37;
}

- (void)pickerView:(__unused UIPickerView *)pickerView
      didSelectRow:(__unused NSInteger)row
       inComponent:(__unused NSInteger)component
{
    if (!self.hasPlaceHolder) {
        [self.languagePickerDelegate languagePicker:self didSelectLanguageWithName:(NSString*)[_mLanguageStandards objectAtIndex:row] Index:row];
    }
    else{
        if (row == 0) {
            [self.languagePickerDelegate languagePicker:self didSelectLanguageWithName:PLACEHOLDER Index:row];
        }
        else{
            [self.languagePickerDelegate languagePicker:self didSelectLanguageWithName:(NSString*)[_mLanguageStandards objectAtIndex:row - 1] Index:row];
        }
    }
    
}


@end

//
//  TPLanguagePickerView.h
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LanguagePickerView;


@protocol LanguagePickerDelegate <UIPickerViewDelegate>

- (void)languagePicker:(LanguagePickerView *)picker didSelectLanguageWithName:(NSString *)name Index:(int)index;

@end

@interface LanguagePickerView : UIPickerView

@property (nonatomic, strong) id<LanguagePickerDelegate> languagePickerDelegate;
@property (strong, nonatomic) NSArray* mLanguageStandards;
@property (strong, nonatomic) NSArray* mLanguagesNatives;
@property BOOL hasPlaceHolder;
@property bool isShort;
-(BOOL) selectLanguage:(NSString*) language;
-(NSString*) standardLangaugeOfSelectedRow;
- (void)setUp;

@end

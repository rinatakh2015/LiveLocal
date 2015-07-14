//
//  TPSpokenLanguageViewController.h
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguagePickerView.h"

@interface TPSpokenLanguageViewController : UIViewController <LanguagePickerDelegate>
@property (strong, nonatomic) IBOutlet UIView *mNavigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *mNavigationbarBg_imageView;
@property (strong, nonatomic) IBOutlet LanguagePickerView *mSpokenLanguagePicker1;
@property (strong, nonatomic) IBOutlet LanguagePickerView *mSpokenLanguagePicker2;
@property (strong, nonatomic) IBOutlet LanguagePickerView *mSpokenLanguagePicker3;


@end

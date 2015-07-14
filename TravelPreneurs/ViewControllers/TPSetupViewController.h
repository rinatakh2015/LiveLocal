//
//  TPSetupViewController.h
//  TravelPreneurs
//
//  Created by CGH on 12/14/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguagePickerView.h"

@interface TPSetupViewController : UIViewController<LanguagePickerDelegate>
@property (strong, nonatomic) IBOutlet UIView *mNavigationBar;
@property (strong, nonatomic) IBOutlet UIImageView *mNavigationbarBg_imageView;
@property (strong, nonatomic) IBOutlet LanguagePickerView *mNativeLanguagePicker;
@end

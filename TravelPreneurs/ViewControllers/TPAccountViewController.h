//
//  TPAccountViewController.h
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountTypePicker.h"
@interface TPAccountViewController : UIViewController<AccountPickerDelegate>
@property (strong, nonatomic) IBOutlet AccountTypePicker *mAccountTypePicker;

@end

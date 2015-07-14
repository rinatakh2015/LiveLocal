//
//  TPCountryViewController.h
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryPicker.h"
@interface TPCountryViewController : UIViewController <CountryPickerDelegate>
@property (strong, nonatomic) IBOutlet CountryPicker *mCountryPicker;

@end

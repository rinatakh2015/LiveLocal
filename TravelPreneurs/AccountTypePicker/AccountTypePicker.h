//
//  AccountTypePicker.h
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountTypePicker;

@protocol AccountPickerDelegate <UIPickerViewDelegate>

- (void)accountPicker:(AccountTypePicker *)picker Type:(int)type;
@end

@interface AccountTypePicker : UIPickerView
@property (nonatomic, strong) id<AccountPickerDelegate> accountPickerDelegate;
@end

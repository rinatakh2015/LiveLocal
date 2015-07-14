//
//  AccountTypePicker.m
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "AccountTypePicker.h"
#import "defs.h"
#import "NSString+Translate.h"

@interface AccountTypePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation AccountTypePicker

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
    
    
}

#pragma mark -
#pragma mark UIPicker

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView numberOfRowsInComponent:(__unused NSInteger)component
{
    return 3;
}

- (UIView *)pickerView:(__unused UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(__unused NSInteger)component reusingView:(UIView *)view
{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(85, 3, 180, 24)];
        label.font = [UIFont systemFontOfSize: LABEL_FONTSIZE];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        [view addSubview:label];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(28, 3, 64, 24)];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.tag = 2;
        [view addSubview:iconView];

    }
    
    NSString* name;
    NSString* icon;
    if (row == 0 ) {
        name = [@"Traveler" translate];
        icon = @"icon_traveler.png";
    }
    else if(row == 1)
    {
        name = [@"Registered Business" translate];
        icon = @"icon_registered_business";
    }
    else if(row == 2)
    {
        name = [@"Mobile Business" translate];
        icon = @"icon_mobile_business";
    }
    ((UILabel *)[view viewWithTag:1]).text = name;
    ((UIImageView *)[view viewWithTag:2]).image = [UIImage imageNamed:icon];
    
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
    [self.accountPickerDelegate accountPicker:self Type:row];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

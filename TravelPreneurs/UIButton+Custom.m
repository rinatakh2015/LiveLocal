//
//  UIButton+Custom.m
//  TravelPreneurs
//
//  Created by CGH on 1/17/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)
+ (instancetype)tableCellDeleteButton
{
    UIButton *button = [[self class] buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.showsTouchWhenHighlighted = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.imageView.contentMode = UIViewContentModeCenter;
    [button setImage:[UIImage imageNamed:@"icon_trash.png"] forState:UIControlStateNormal];
    
    return button;
}
@end

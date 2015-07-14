//
//  NSString+Translate.m
//  TravelPreneurs
//
//  Created by CGH on 12/17/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "NSString+Translate.h"
#import "MyUtils.h"

@implementation NSString (Translate)
-(NSString*)translate
{
    return [[MyUtils shared] translateWith:self];
}
@end

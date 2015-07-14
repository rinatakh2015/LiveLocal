//
//  MyEnums.h
//  TravelPreneurs
//
//  Created by CGH on 12/17/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef TravelPreneurs_MyEnums_h
#define TravelPreneurs_MyEnums_h

typedef enum : NSInteger {
    TPMainCategory_NONE        = -1,
    TPMainCategory_DINING     = 0,
    TPMainCategory_ACTIVITIES  = 1,
    TPMainCategory_HEALTH      = 2,
    TPMainCategory_SERVICES   = 3,
    TPMainCategory_NIGHTLIFE   = 4,
    TPMainCategory_SHOPPING    = 5,
    TPMainCategory_TRANSPORT   = 6,
    TPMainCategory_TOURISM     = 7,
    TPMainCategory_EVENTS      = 8
} TPMainCategory;

typedef enum : NSInteger{
    TPAccountType_TRAVELER = 0,
    TPAccountType_REGISTERED_BUSINESS = 1,
    TPAccountType_MOBILE_BUSINESS = 2
} TPAccountType;
#endif


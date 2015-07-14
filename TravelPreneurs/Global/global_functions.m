//
//  global_functions.m
//  TravelPreneurs
//
//  Created by CGH on 1/27/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#include "global_functions.h"
#import "MyEnums.h"
#import "MyUtils.h"
#import "defs.h"
#import "NSString+Translate.h"

void ShowErrorAlert(NSString* text)
{
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString( @"Error", nil )
                              message:text
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                              otherButtonTitles:nil];
    
    [alertView show];
}


NSArray* mainCategories()
{
  return @[ @{@"type": @(TPMainCategory_DINING), @"icon": @"icon_dinning.png" , @"big_icon": @"icon_dinning_big.png"},
     @{@"type": @(TPMainCategory_ACTIVITIES), @"icon": @"icon_activities.png", @"big_icon": @"icon_activities_big.png"},
     @{@"type": @(TPMainCategory_HEALTH), @"icon": @"icon_health.png", @"big_icon": @"icon_health_big.png"},
     @{@"type": @(TPMainCategory_SERVICES), @"icon": @"icon_servicies.png", @"big_icon": @"icon_servicies_big.png"},
     @{@"type": @(TPMainCategory_NIGHTLIFE), @"icon": @"icon_nightlife.png", @"big_icon": @"icon_nightlife_big.png"},
     @{@"type": @(TPMainCategory_SHOPPING), @"icon": @"icon_shopping.png", @"big_icon": @"icon_shopping_big.png"},
     @{@"type": @(TPMainCategory_TRANSPORT), @"icon": @"icon_transport.png", @"big_icon": @"icon_transport_big.png"},
     @{@"type": @(TPMainCategory_TOURISM), @"icon": @"icon_tourism.png", @"big_icon": @"icon_tourism_big.png"},
     @{@"type": @(TPMainCategory_EVENTS), @"icon": @"icon_events.png", @"big_icon": @"icon_events_big.png"}];
}

NSArray* diningSubCategories()
{
    NSArray* titleArray = @[[@"bakery" translate],
                            [@"cafe" translate],
                            [@"fast food" translate],
                            [@"food truck" translate],
                            [@"food court" translate],
                            [@"kiosk" translate],
                            [@"restaurant" translate],
                            [@"street food" translate]];
    NSArray* valueArray = @[
                            @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7),
                            ];
    
    NSMutableArray* _mSubCategoryArrayForFirst = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForFirst addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    

    titleArray = @[[@"coffee" translate],
                   [@"sweets" translate],
                   [@"sandwich" translate],
                   [@"gourmet" translate],
                   [@"seafood" translate],
                   [@"snack" translate],
                   [@"vegetarian" translate],
                   [@"grilled" translate],
                   [@"Thai" translate],
                   [@"Lao" translate],
                   [@"Cambodian" translate],
                   [@"Burmese" translate],
                   [@"Vietnamese" translate],
                   [@"Japanese" translate],
                   [@"Malay" translate],
                   [@"Chinese" translate],
                   [@"Korean" translate],
                   [@"Indonesian" translate],
                   [@"Indian" translate],
                   [@"Nepalese" translate],
                   [@"Bulgarian" translate],
                   [@"Romanian" translate],
                   [@"Czech" translate],
                   [@"Turkish" translate],
                   [@"Lebanese" translate],
                   [@"Arabic" translate],
                   [@"French" translate],
                   [@"German" translate],
                   [@"Italian" translate],
                   [@"Spanish" translate],
                   [@"American" translate],
                   [@"Mexican" translate],
                   [@"Russian" translate],
                   [@"Hungarian" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10),
                   @(11), @(12), @(13), @(14), @(15), @(16), @(17), @(18), @(19), @(20),
                   @(21), @(22), @(23), @(24), @(25), @(26), @(27), @(28),  @(29), @(30),
                   @(31), @(32), @(33),
                  ];
    
    NSMutableArray* _mSubCategoryArrayForSecond = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForSecond addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i] }];
    }
    

    titleArray = @[
                   [@"24 Hours" translate],
                   [@"Breakfast" translate],
                   [@"Lunch" translate],
                   [@"Dinner" translate],
                   [@"Delivery" translate],
                   [@"Take Away" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForThird = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForThird addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    NSArray* result = @[_mSubCategoryArrayForFirst, _mSubCategoryArrayForSecond, _mSubCategoryArrayForThird];
    return result;
}

NSArray* activitiesSubCategories()
{
    NSArray* titleArray = @[
                            [@"Outdoor" translate],
                            [@"Indoor" translate],
                            [@"Casino" translate],
                            [@"City" translate],
                            [@"Country" translate],
                            [@"Lake" translate],
                            [@"Snow" translate],
                            [@"Mountains" translate],
                            [@"Desert" translate],
                            [@"Trails" translate],
                            [@"Sea" translate],
                            [@"River" translate],
                            [@"Off Road" translate]
                            ];
    NSArray* valueArray = @[
                            @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10),
                            @(11), @(12), @(13)
                            ];
    
    NSMutableArray* _mSubCategoryArrayForFirst = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForFirst addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Surfing" translate],
                   [@"Skiing" translate],
                   [@"Boating" translate],
                   [@"Trekking" translate],
                   [@"Camping" translate],
                   [@"Hiking" translate],
                   [@"Cycling" translate],
                   [@"Motorsports" translate],
                   [@"Fishing" translate],
                   [@"Rafting" translate],
                   [@"Horse Ride" translate],
                   [@"Hot Air Balloon" translate],
                   [@"Tennis" translate],
                   [@"Golf" translate],
                   [@"Billiards" translate],
                   [@"Bowling" translate],
                   [@"Gambling" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10),
                   @(11), @(12), @(13), @(14), @(15), @(16), @(17)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForSecond = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForSecond addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Day" translate],
                   [@"Night" translate],
                   [@"Adult" translate],
                   [@"Children" translate],
                   [@"Family" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForThird = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForThird addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    NSArray* result = @[_mSubCategoryArrayForFirst, _mSubCategoryArrayForSecond, _mSubCategoryArrayForThird];
    return result;
}

NSArray* healthSubCategories()
{
    NSArray* titleArray = @[
                            [@"Pharmacy" translate],
                            [@"Shop" translate],
                            [@"Spa" translate],
                            [@"Clinic" translate],
                            [@"Gym" translate],
                            [@"Sauna" translate],
                            [@"Studio" translate],
                            [@"Freelance" translate]
                            ];
    NSArray* valueArray = @[
                            @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8)
                            ];
    
    NSMutableArray* _mSubCategoryArrayForFirst = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForFirst addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Medicine" translate],
                   [@"Doctor" translate],
                   [@"Dentist" translate],
                   [@"Acupuncture" translate],
                   [@"Massage" translate],
                   [@"Homeopath" translate],
                   [@"Chiropractor" translate],
                   [@"Trainer" translate],
                   [@"Yoga" translate],
                   [@"Health Food" translate],
                   [@"Reiki" translate],
                   [@"Martial Arts" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10),
                   @(11), @(12)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForSecond = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForSecond addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Walk In" translate],
                   [@"24 Hours" translate],
                   [@"Emergency" translate],
                   [@"Appointment" translate],
                   [@"Gay" translate],
                   [@"Women" translate],
                   [@"Men" translate],
                   [@"Children" translate],
                   [@"Everybody" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForThird = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForThird addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    NSArray* result = @[_mSubCategoryArrayForFirst, _mSubCategoryArrayForSecond, _mSubCategoryArrayForThird];
    return result;
}

NSArray* servicesSubCategories()
{
    NSArray* titleArray = @[
                            [@"Shop" translate],
                            [@"Office" translate],
                            [@"Kiosk" translate],
                            [@"Market" translate],
                            [@"Mall" translate]
                            ];
    NSArray* valueArray = @[
                            @(0), @(1), @(2), @(3), @(4), @(5)
                            ];
    
    NSMutableArray* _mSubCategoryArrayForFirst = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForFirst addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Exchange" translate],
                   [@"Laundry" translate],
                   [@"Tailor" translate],
                   [@"Real Estate" translate],
                   [@"Salon" translate],
                   [@"Barber" translate],
                   [@"Manicure" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForSecond = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForSecond addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"24 Hours" translate],
                   [@"Delivery" translate],
                   [@"Appointment" translate],
                   [@"Walk In" translate],
                   [@"Men" translate],
                   [@"Women" translate],
                   [@"Children" translate],
                   [@"Family" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForThird = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForThird addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    NSArray* result = @[_mSubCategoryArrayForFirst, _mSubCategoryArrayForSecond, _mSubCategoryArrayForThird];
    return result;
}

NSArray* nightlifeSubCategories()
{
    NSArray* titleArray = @[
                            [@"Pub" translate],
                            [@"Bar" translate],
                            [@"Disco" translate],
                            [@"Lounge" translate],
                            [@"Dancing" translate],
                            [@"Club" translate]
                            ];
    NSArray* valueArray = @[
                            @(0), @(1), @(2), @(3), @(4), @(5), @(6)
                            ];
    
    NSMutableArray* _mSubCategoryArrayForFirst = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForFirst addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Happy Hour" translate],
                   [@"Beer" translate],
                   [@"Wine" translate],
                   [@"Cocktail" translate],
                   [@"Live Music" translate],
                   [@"DJ" translate],
                   [@"Sport" translate],
                   [@"Show" translate],
                   [@"Food" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForSecond = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForSecond addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Singles" translate],
                   [@"Private" translate],
                   [@"After Hours" translate],
                   [@"Gay" translate],
                   [@"Erotic" translate],
                   [@"Everybody" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForThird = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForThird addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    NSArray* result = @[_mSubCategoryArrayForFirst, _mSubCategoryArrayForSecond, _mSubCategoryArrayForThird];
    return result;
}

NSArray* shoppingSubCategories()
{

    NSArray* titleArray = @[
                            [@"Shop" translate],
                            [@"Bazaar" translate],
                            [@"Mall" translate],
                            [@"Market" translate],
                            [@"Kiosk" translate]
                            ];
    NSArray* valueArray = @[
                            @(0), @(1), @(2), @(3), @(4), @(5)
                            ];
    
    NSMutableArray* _mSubCategoryArrayForFirst = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForFirst addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Erotic" translate],
                   [@"Handicraft" translate],
                   [@"Antique" translate],
                   [@"Souvenir" translate],
                   [@"Flowers" translate],
                   [@"Gourment" translate],
                   [@"Clothing" translate],
                   [@"Accessories" translate],
                   [@"Furniture" translate],
                   [@"Decor" translate],
                   [@"Electronics" translate],
                   [@"Toys" translate],
                   [@"Gifts" translate],
                   [@"Food" translate],
                   [@"Lifestyle" translate],
                   [@"Fashion" translate],
                   [@"Sports" translate],
                   [@"Jewelry" translate],
                   [@"Beauty" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10),
                   @(11), @(12), @(13), @(14), @(15), @(16), @(17), @(18), @(19)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForSecond = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForSecond addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Men" translate],
                   [@"Women" translate],
                   [@"Children" translate],
                   [@"Family" translate],
                   [@"Everybody" translate],
                   [@"Adult" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForThird = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForThird addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    NSArray* result = @[_mSubCategoryArrayForFirst, _mSubCategoryArrayForSecond, _mSubCategoryArrayForThird];
    return result;
}

NSArray* transportSubCategories()
{
    NSArray* titleArray = @[
                            [@"Rental" translate],
                            [@"Taxi" translate]
                            ];
    NSArray* valueArray = @[
                            @(0), @(1)
                            ];
    
    NSMutableArray* _mSubCategoryArrayForFirst = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForFirst addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Car" translate],
                   [@"Van" translate],
                   [@"Scooter" translate],
                   [@"Motorcycle" translate],
                   [@"Limousine" translate],
                   [@"Bicycle" translate],
                   [@"Bus" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForSecond = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForSecond addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Airport" translate],
                   [@"Tour" translate],
                   [@"Driver" translate],
                   [@"Self Drive" translate],
                   [@"Delivery" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForThird = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForThird addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    NSArray* result = @[_mSubCategoryArrayForFirst, _mSubCategoryArrayForSecond, _mSubCategoryArrayForThird];
    return result;
}

NSArray* tourismSubCategories()
{
    NSArray* titleArray = @[
                            [@"Agent" translate],
                            [@"Guide" translate]
                            ];
    NSArray* valueArray = @[
                            @(0), @(1)
                            ];
    
    NSMutableArray* _mSubCategoryArrayForFirst = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForFirst addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Ticket" translate],
                   [@"Tour" translate],
                   [@"Expedition" translate],
                   [@"Walking" translate],
                   [@"Day Trip" translate],
                   [@"Cruise" translate],
                   [@"Historical" translate],
                   [@"Cultural" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForSecond = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForSecond addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Group" translate],
                   [@"Family" translate],
                   [@"Single" translate],
                   [@"Gay" translate],
                   [@"Handicap" translate],
                   [@"Couples" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForThird = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForThird addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    NSArray* result = @[_mSubCategoryArrayForFirst, _mSubCategoryArrayForSecond, _mSubCategoryArrayForThird];
    return result;
}

NSArray* eventsSubCategories()
{
    NSArray* titleArray = @[
                            [@"Theatre" translate],
                            [@"Gallery" translate],
                            [@"Cabaret" translate],
                            [@"Street" translate],
                            [@"Outdoor" translate]
                            ];
    NSArray* valueArray = @[
                            @(0), @(1), @(2), @(3), @(4)
                            ];
    
    NSMutableArray* _mSubCategoryArrayForFirst = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForFirst addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Play" translate],
                   [@"Exhibition" translate],
                   [@"Comedy" translate],
                   [@"Art" translate],
                   [@"Music" translate],
                   [@"Cultural" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForSecond = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForSecond addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    
    titleArray = @[
                   [@"Day" translate],
                   [@"Night" translate],
                   [@"Adult" translate],
                   [@"Children" translate],
                   [@"Family" translate],
                   [@"Gay" translate]
                   ];
    valueArray = @[
                   @(0), @(1), @(2), @(3), @(4), @(5)
                   ];
    
    NSMutableArray* _mSubCategoryArrayForThird = [[NSMutableArray alloc] init];
    
    for( int i = 0 ; i<titleArray.count; i++)
    {
        [_mSubCategoryArrayForThird addObject:@{kTitle: [titleArray objectAtIndex:i], kType: [valueArray objectAtIndex:i]}];
    }
    
    NSArray* result = @[_mSubCategoryArrayForFirst, _mSubCategoryArrayForSecond, _mSubCategoryArrayForThird];
    return result;
}

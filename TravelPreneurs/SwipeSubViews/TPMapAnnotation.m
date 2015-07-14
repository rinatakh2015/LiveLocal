//
//  TPMapAnnotationView.m
//  TravelPreneurs
//
//  Created by CGH on 1/29/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPMapAnnotation.h"
#import "defs.h"
@implementation TPMapAnnotation

+ (instancetype)accountWithAttributes:(NSDictionary *)attributes {
    return [[self alloc] initWithAttributes:attributes];
}

- (id)initWithAttributes:(NSDictionary *)attributes;
{
    self = [super init];
    if (self) {
        [self populateFromAttributes:attributes];
    }
    return self;
}

-(id)initWithUser:(User *)user
{
    self = [super init];
    if(self)
    {
        self.userID = user.identifier;
        self.fullname = user.fullName;
        self.businessName = user.businessName;
        self.managerName = user.managerName;
        self.accountType = user.accountType;
        self.coordinate = CLLocationCoordinate2DMake(user.latitude, user.longitude);
        self.country = user.country;
        self.telephone = user.phoneNumber;
        self.email = user.email;
        self.imageURL = user.avatarImageURL;
    }
    return self;
}
- (void)populateFromAttributes:(NSDictionary *)attributes {
    
    self.userID = [attributes[kUserId] integerValue];
    self.fullname = attributes[kFullname] ?: nil;
    
    if([attributes[kAvatarImageURL] isEqual:[NSNull null]]) {
        self.imageURL = nil;
    } else {
        self.imageURL = attributes[kAvatarImageURL];
    }
    self.telephone = attributes[kPhone] ?: nil;
    self.businessName = attributes[kBusinessName] ?: nil;
    self.managerName = attributes[kManagerName] ?: nil;
    self.country = attributes[kCountry] ?: nil;
    self.accountType = attributes[kAccountType] ? [attributes[kAccountType] integerValue] : 0;
    if (![attributes[kLatitude] isEqual:[NSNull null]]) {
        CLLocationDegrees latitude = [attributes[kLatitude] doubleValue];
        CLLocationDegrees longitude = [attributes[kLongitude] doubleValue];
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
}



- (NSString *)title {
    if (self.accountType == TPAccountType_TRAVELER) {
        return _fullname;
    }
    else
        return _businessName;
    
}

- (NSString *)subtitle {
    if (self.accountType == TPAccountType_TRAVELER) {
        //return self.country;
        return @"";
    }
    else
        return _managerName;
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

@end

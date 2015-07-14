//
//  TPMapAnnotationView.h
//  TravelPreneurs
//
//  Created by CGH on 1/29/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MyEnums.h"
#import "User.h"
@interface TPMapAnnotation : NSObject<MKAnnotation>
@property long userID;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, strong) NSString *managerName;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *imageURL;
@property TPAccountType accountType;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initWithUser:(User*)user;
@end

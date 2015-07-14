//
//  LyphyPerson.h
//  Lyphy
//
//  Created by Liang Xing on 28/1/14.
//  Copyright (c) 2014 LiangXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyEnums.h"

@interface User : NSObject
@property long identifier;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *accessToken;

@property (strong, nonatomic) NSString *fullName;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phoneNumber;


@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *nativeLanguage;
@property (strong, nonatomic) NSArray *spokenLanguages;
@property TPAccountType accountType;
@property TPMainCategory mainCategory;
@property (strong, nonatomic) NSArray* subCategories;
@property (strong, nonatomic) NSString *businessName;
@property (strong, nonatomic) NSString *managerName;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *facebook;
@property (strong, nonatomic) NSString *linkedin;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *avatarImageURL;
@property (strong, nonatomic) NSString *backgroundImageURL;
@property (strong, nonatomic) NSString *timeCreated;
@property (strong, nonatomic) NSDictionary *creditCardInfo;
@property double latitude;
@property double longitude;
@property BOOL verified;
@property BOOL blocked;
@property BOOL registeredCard;


@property (strong, nonatomic) NSString* firstSubCategoryText;
@property (strong, nonatomic) NSString* secondSubCategoryText;
@property (strong, nonatomic) NSString* thirdSubCategoryText;

@property NSMutableArray* favouriteIds;

+(User*)userFromDic:(NSDictionary*) dic;
+(User*)copy:(User*)user;

@end

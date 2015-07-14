//
//  Preferences.h
//  SXTLearning
//
//  Created by CGH on 11/5/14.
//  Copyright (c) 2014 Shanghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyEnums.h"
@interface Preferences : NSObject

+ (instancetype)sharedInstance;
@property long userId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* fullname;
@property (nonatomic, strong) NSString* accessToken;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* timeCreated;
@property (nonatomic, strong) NSString* offlineAvatar;
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
@property double latitude;
@property double longitude;
@property BOOL verified;
@property BOOL blocked;
@property BOOL registeredCard;
-(void) clear;
@end

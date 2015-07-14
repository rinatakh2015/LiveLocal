//
//  LyphyPerson.m
//  Lyphy
//
//  Created by Liang Xing on 28/1/14.
//  Copyright (c) 2014 LiangXing. All rights reserved.
//

#import "User.h"
#import "defs.h"

@implementation User
+(User*)userFromDic:(NSDictionary*) dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]] || ![dic valueForKey:kUserId] || [[dic valueForKey:kUserId] integerValue] <= 0 || ![dic objectForKey:kUserName] ) {
        return nil;
    }
    
    User* user = [[User alloc] init];
    user.identifier = [[dic valueForKey:kUserId] integerValue];
    user.userName = [dic objectForKey:kUserName];
    user.phoneNumber = [dic objectForKey:kPhone] ?: nil;
    user.fullName = [dic objectForKey:kFullname] ?: nil;
    user.email = [dic objectForKey:kEmail] ?: nil;
    user.timeCreated = [dic objectForKey:kTimeCreated] ?: nil;
    user.country = [dic objectForKey:kCountry] ?: nil;
    user.nativeLanguage = [dic objectForKey:kNativeLanguage] ?: nil;
    user.spokenLanguages = [dic objectForKey:kSpokenLanguages] ? [[dic objectForKey:kSpokenLanguages] componentsSeparatedByString:@","] : nil;
    user.accountType = [dic valueForKey:kAccountType] ? [[dic valueForKey:kAccountType] integerValue] : 0;
    user.mainCategory = [dic valueForKey:kMainCategory] ? [[dic valueForKey:kMainCategory] integerValue] : 0;
    user.subCategories = [dic objectForKey:kSubCategories] ? [[dic objectForKey:kSubCategories] componentsSeparatedByString:@","] : nil;
    user.businessName = [dic objectForKey:kBusinessName] ?: nil;
    user.managerName = [dic objectForKey:kManagerName] ?: nil;
    user.address1 = [dic objectForKey:kAddress1] ?: nil;
    user.address2 = [dic objectForKey:kAddress2] ?: nil;
    user.city = [dic objectForKey:kCity] ?: nil;
    user.state = [dic objectForKey:kState] ?: nil;
    user.postalCode = [dic objectForKey:kPostalCode] ?: nil;
    user.facebook = [dic objectForKey:kFacebook] ?: nil;
    user.linkedin = [dic objectForKey:kLinkedin] ?: nil;
    user.website = [dic objectForKey:kWebsite] ?: nil;
    user.avatarImageURL = [dic objectForKey:kAvatarImageURL] ?: nil;
    user.backgroundImageURL = [dic objectForKey:kBackgroundImageURL] ?: nil;
    user.latitude = [dic valueForKey:kLatitude] ? [[dic valueForKey:kLatitude] doubleValue] : 0;
    user.longitude = [dic valueForKey:kLongitude] ? [[dic valueForKey:kLongitude] doubleValue] : 0;
    user.verified = [dic valueForKey:kVerified] ? [[dic valueForKey:kVerified] boolValue] : false;
    user.blocked = [dic valueForKey:kBlocked] ? [[dic valueForKey:kBlocked] boolValue] : true;
    user.registeredCard = [dic objectForKey:kRegisteredCard] ? [[dic valueForKey:kRegisteredCard] boolValue] : false;
    return user;
}

+(User*)copy:(User*)user
{
    User* newUser = [[User alloc] init];
    newUser.identifier = user.identifier;
    newUser.userName = [NSString stringWithString:user.userName];
    newUser.accessToken = user.accessToken ? [NSString stringWithString:user.accessToken] : nil;
    newUser.phoneNumber = user.phoneNumber ? [NSString stringWithString:user.phoneNumber]: nil;
    newUser.fullName = user.fullName ? [NSString stringWithString:user.fullName]: nil;
    newUser.email = user.email ? [NSString stringWithString:user.email]: nil;
    newUser.password = user.email ? [NSString stringWithString:user.password]: nil;
    newUser.timeCreated = user.timeCreated ? [NSString stringWithString:user.timeCreated]: nil;
    newUser.country = user.country ? [NSString stringWithString:user.country]: nil;
    newUser.nativeLanguage = user.nativeLanguage ? [NSString stringWithString:user.nativeLanguage]: nil;
    newUser.spokenLanguages = user.spokenLanguages ? [NSArray arrayWithArray:user.spokenLanguages] : nil;
    newUser.accountType = user.accountType;
    newUser.mainCategory = user.mainCategory;
    newUser.subCategories = user.subCategories ? [NSArray arrayWithArray:user.subCategories] : nil;
    newUser.businessName = user.businessName ? [NSString stringWithString:user.businessName] : nil;
    newUser.managerName = user.managerName ? [NSString stringWithString:user.managerName] : nil;
    newUser.address1 = user.address1 ? [NSString stringWithString:user.address1]: nil;
    newUser.address2 = user.address2 ? [NSString stringWithString:user.address2]: nil;
    newUser.city = user.city ? [NSString stringWithString:user.city]: nil;
    newUser.state = user.state ? [NSString stringWithString:user.state]: nil;
    newUser.postalCode = user.postalCode ? [NSString stringWithString:user.postalCode]: nil;
    newUser.facebook = user.facebook ? [NSString stringWithString:user.facebook]: nil;
    newUser.linkedin = user.linkedin ? [NSString stringWithString:user.linkedin]: nil;
    newUser.website = user.website ? [NSString stringWithString:user.website]: nil;
    newUser.avatarImageURL = user.avatarImageURL ? [NSString stringWithString:user.avatarImageURL]: nil;
    newUser.backgroundImageURL = user.backgroundImageURL ? [NSString stringWithString:user.backgroundImageURL]: nil;
    newUser.latitude = user.latitude;
    newUser.longitude = user.longitude;
    newUser.verified = user.verified;
    newUser.blocked = user.blocked;
    newUser.registeredCard = user.registeredCard;
    
    return newUser;
}
@end

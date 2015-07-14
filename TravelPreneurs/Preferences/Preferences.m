//
//  Preferences.m
//  SXTLearning
//
//  Created by CGH on 11/5/14.
//  Copyright (c) 2014 Shanghai. All rights reserved.
//

#import "Preferences.h"
#import "defs.h"

@implementation Preferences
+ (instancetype)sharedInstance
{
    static Preferences *settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[self alloc] init];
    });
    return settings;
}


-(void) clear{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserName];
    [defaults removeObjectForKey:kPhone];
    [defaults removeObjectForKey:kPassword];
    [defaults removeObjectForKey:kUserId];
    [defaults removeObjectForKey:kAccessToken];
    [defaults removeObjectForKey:kFullname];
    [defaults removeObjectForKey:kEmail];
    [defaults removeObjectForKey:kAvatarImageURL];
    [defaults removeObjectForKey:kNativeLanguage];
    [defaults removeObjectForKey:kSpokenLanguages];
    [defaults removeObjectForKey:kCountry];
    [defaults removeObjectForKey:kAddress1];
    [defaults removeObjectForKey:kAddress2];
    [defaults removeObjectForKey:kCity];
    [defaults removeObjectForKey:kState];
    [defaults removeObjectForKey:kPostalCode];
    [defaults removeObjectForKey:kFacebook];
    [defaults removeObjectForKey:kLinkedin];
    [defaults removeObjectForKey:kWebsite];
    [defaults removeObjectForKey:kAvatarImageURL];
    [defaults removeObjectForKey:kBackgroundImageURL];
    [defaults removeObjectForKey:kBusinessName];
    [defaults removeObjectForKey:kManagerName];
    [defaults removeObjectForKey:kAccountType];
    [defaults removeObjectForKey:kMainCategory];
    [defaults removeObjectForKey:kSubCategories];
    [defaults removeObjectForKey:kTimeCreated];
    [defaults removeObjectForKey:kLatitude];
    [defaults removeObjectForKey:kLongitude];
    [defaults synchronize];
}

-(NSString*) phone{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kPhone];
}

-(void) setPhone:(NSString*) phone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (!phone) {
        [defaults removeObjectForKey:kPhone];
        [defaults synchronize];
        return;
    }
    
    [defaults setObject:phone forKey:kPhone];
    [defaults synchronize];
}

-(NSString*) password{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kPassword];
}

-(void) setPassword:(NSString*) password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!password) {
        [defaults removeObjectForKey:kPassword];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:password forKey:kPassword];
    [defaults synchronize];
}

-(long) userId{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserId];
}

-(void) setUserId:(long) userId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!userId) {
        [defaults removeObjectForKey:kUserId];
        [defaults synchronize];
        return;
    }

    
    [defaults setInteger:userId forKey:kUserId];
    [defaults synchronize];
}

-(NSString*) fullname{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kFullname];
}

-(void) setFullname:(NSString*) fullname
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!fullname) {
        [defaults removeObjectForKey:kFullname];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:fullname forKey:kFullname];
    [defaults synchronize];
}

-(NSString*) accessToken{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAccessToken];
}

-(void) setAccessToken:(NSString*) accessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (!accessToken) {
        [defaults removeObjectForKey:kAccessToken];
        [defaults synchronize];
        return;
    }

    [defaults setObject:accessToken forKey:kAccessToken];
    [defaults synchronize];
}

-(NSString*) email{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kEmail];
}

-(void) setEmail:(NSString*) email
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!email) {
        [defaults removeObjectForKey:kEmail];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:email forKey:kEmail];
    [defaults synchronize];
}

-(NSString*) avatarImageURL{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAvatarImageURL];
}

-(void) setAvatarImageURL:(NSString *)avatarImageURL
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!avatarImageURL) {
        [defaults removeObjectForKey:kAvatarImageURL];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:avatarImageURL forKey:kAvatarImageURL];
    [defaults synchronize];
}

-(NSString*) backgroundImageURL{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kBackgroundImageURL];
}

-(void) setBackgroundImageURL:(NSString *)backgroundImageURL
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (!backgroundImageURL) {
        [defaults removeObjectForKey:kBackgroundImageURL];
        [defaults synchronize];
        return;
    }
    
    [defaults setObject:backgroundImageURL forKey:kBackgroundImageURL];
    [defaults synchronize];
}


-(NSString*) timeCreated{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kTimeCreated];
}

-(void) setTimeCreated:(NSString*) timeCreated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!timeCreated) {
        [defaults removeObjectForKey:kTimeCreated];
        [defaults synchronize];
        return;
    }

    [defaults setObject:timeCreated forKey:kTimeCreated];
    [defaults synchronize];
}

-(NSString*) nativeLanguage{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kNativeLanguage];
}

-(void) setNativeLanguage:(NSString*) nativeLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!nativeLanguage) {
        [defaults removeObjectForKey:kNativeLanguage];
        [defaults synchronize];
        return;
    }
    
    [defaults setObject:nativeLanguage forKey:kNativeLanguage];
    [defaults synchronize];
}

-(NSString*) userName{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserName];
}

-(void) setUserName:(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!userName) {
        [defaults removeObjectForKey:kUserName];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:userName forKey:kUserName];
    [defaults synchronize];
}


-(NSString*) offlineAvatar{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kOfflineAvatar];
}

-(void) setOfflineAvatar:(NSString*) offlineAvatar
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!offlineAvatar) {
        [defaults removeObjectForKey:kOfflineAvatar];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:offlineAvatar forKey:kOfflineAvatar];
    [defaults synchronize];
}

-(NSString*) country{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kCountry];
}

-(void) setCountry:(NSString *)country
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!country) {
        [defaults removeObjectForKey:kCountry];
        [defaults synchronize];
        return;
    }
    
    [defaults setObject:country forKey:kCountry];
    [defaults synchronize];
}

-(NSArray*) spokenLanguages{
    NSString* string =  [[NSUserDefaults standardUserDefaults] stringForKey:kSpokenLanguages];
    if (!string) {
        return nil;
    }
    NSArray* spokenLanguages = [string componentsSeparatedByString:@","];
    return spokenLanguages;
}

-(void) setSpokenLanguages:(NSArray *)spokenLanguages
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!spokenLanguages) {
        [defaults removeObjectForKey:kSpokenLanguages];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:[spokenLanguages componentsJoinedByString:@","] forKey:kSpokenLanguages];
    [defaults synchronize];
}

-(TPAccountType) accountType{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAccountType];
}

-(void) setAccountType:(TPAccountType)accountType
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (accountType<0) {
        [defaults removeObjectForKey:kAccountType];
        [defaults synchronize];
        return;
    }

    [defaults setInteger:accountType forKey:kAccountType];
    [defaults synchronize];
}

-(TPMainCategory)mainCategory{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kMainCategory];
}

-(void) setMainCategory:(TPMainCategory)mainCategory
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (mainCategory<0) {
        [defaults removeObjectForKey:kMainCategory];
        [defaults synchronize];
        return;
    }

    
    [defaults setInteger:mainCategory forKey:kMainCategory];
    [defaults synchronize];
}

-(NSArray*) subCategories{
    NSString* string =  [[NSUserDefaults standardUserDefaults] stringForKey:kSubCategories];
    if (!string) {
        return nil;
    }
    NSArray* subCategories = [string componentsSeparatedByString:@","];
    return subCategories;
}

-(void) setSubCategories:(NSArray *)subCategories
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!subCategories) {
        [defaults removeObjectForKey:kSubCategories];
        [defaults synchronize];
        return;
    }
    
    [defaults setObject:[subCategories componentsJoinedByString:@","] forKey:kSpokenLanguages];
    [defaults synchronize];
}


-(NSString*) businessName{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kBusinessName];
}

-(void) setBusinessName:(NSString *)businessName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!businessName) {
        [defaults removeObjectForKey:kBusinessName];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:businessName forKey:kBusinessName];
    [defaults synchronize];
}

-(NSString*) managerName{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kManagerName];
}

-(void) setManagerName:(NSString *)managerName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!managerName) {
        [defaults removeObjectForKey:kManagerName];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:managerName forKey:kManagerName];
    [defaults synchronize];
}

-(NSString*) address1{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAddress1];
}

-(void) setAddress1:(NSString *)address1
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!address1) {
        [defaults removeObjectForKey:kAddress1];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:address1 forKey:kAddress1];
    [defaults synchronize];
}

-(NSString*) address2{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAddress2];
}

-(void) setAddress2:(NSString *)address2
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!address2) {
        [defaults removeObjectForKey:kAddress2];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:address2 forKey:kAddress2];
    [defaults synchronize];
}

-(NSString*) city{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kCity];
}

-(void) setCity:(NSString *)city
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!city) {
        [defaults removeObjectForKey:kCity];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:city forKey:kCity];
    [defaults synchronize];
}

-(NSString*) state{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kState];
}

-(void) setState:(NSString *)state
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!state) {
        [defaults removeObjectForKey:kState];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:state forKey:kState];
    [defaults synchronize];
}

-(NSString*) postalCode{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kPostalCode];
}

-(void) setPostalCode:(NSString *)postalCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!postalCode) {
        [defaults removeObjectForKey:kPostalCode];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:postalCode forKey:kPostalCode];
    [defaults synchronize];
}

-(NSString*) facebook{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kFacebook];
}

-(void) setFacebook:(NSString *)facebook
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!facebook) {
        [defaults removeObjectForKey:kFacebook];
        [defaults synchronize];
        return;
    }
    
    [defaults setObject:facebook forKey:kFacebook];
    [defaults synchronize];
}

-(NSString*) linkedin{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kLinkedin];
}

-(void) setLinkedin:(NSString *)linkedin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!linkedin) {
        [defaults removeObjectForKey:kLinkedin];
        [defaults synchronize];
        return;
    }
    
    [defaults setObject:linkedin forKey:kLinkedin];
    [defaults synchronize];
}

-(NSString*) website{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kWebsite];
}

-(void) setWebsite:(NSString *)website
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!website) {
        [defaults removeObjectForKey:kWebsite];
        [defaults synchronize];
        return;
    }

    
    [defaults setObject:website forKey:kWebsite];
    [defaults synchronize];
}

-(double)latitude{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kLatitude];
}

-(void) setLatitude:(double)latitude
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (latitude<0) {
        [defaults removeObjectForKey:kLatitude];
        [defaults synchronize];
        return;
    }
    
    
    [defaults setDouble:latitude forKey:kLatitude];
    [defaults synchronize];
}

-(double)longitude{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kLongitude];
}

-(void) setLongitude:(double)longitude
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (longitude<0) {
        [defaults removeObjectForKey:kLongitude];
        [defaults synchronize];
        return;
    }
    
    [defaults setDouble:longitude forKey:kLongitude];
    [defaults synchronize];
}

-(BOOL)verified{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kVerified];
}

-(void) setVerified:(BOOL)verified
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:verified forKey:kVerified];
    [defaults synchronize];
}

-(BOOL)blocked{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kBlocked];
}

-(void) setBlocked:(BOOL)blocked
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:blocked forKey:kBlocked];
    [defaults synchronize];
}

-(BOOL)registeredCard{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kRegisteredCard];
}

-(void) setRegisteredCard:(BOOL)registeredCard
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:registeredCard forKey:kRegisteredCard];
    [defaults synchronize];
}

@end

//
//  APIClient.m
//  pinion
//
//  Created by CGH on 10/9/14.
//  Copyright (c) 2014 jianming. All rights reserved.
//

#import "APIClient.h"
#import "AFNetworking.h"
#import "defs.h"
#import "global_functions.h"
#import "NSObject+SBJson.h"
#import "MyUtils.h"
#import "DBManager.h"
#import "Preferences.h"
#import "AppDelegate.h"

@implementation APIClient
+(void)loginWithUserName:(NSString*)userName Password:(NSString*)password DeviceToken:(NSString*)deviceToken completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = LOGIN_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:userName forKey:kUserName];
    [dataDic setObject:password forKey:kPassword];


    if (deviceToken != nil && ![deviceToken isEqualToString:@""]) {
        [dataDic setObject:deviceToken forKey:kDeviceToken];
    }
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     NSDictionary* data = [result objectForKey:@"data"];
                     [MyUtils shared].user.identifier = [data valueForKey:kUserId] ? [[data valueForKey:kUserId] integerValue] : 0;
                     [MyUtils shared].user.userName = [data objectForKey:kUserName] ?: nil;
                     [MyUtils shared].user.accessToken = [data objectForKey:kAccessToken] ?: nil;
                     [MyUtils shared].user.fullName = [data objectForKey:kFullname] ?: nil;
                     [MyUtils shared].user.email = [data objectForKey:kEmail] ?: nil;
                     [MyUtils shared].user.phoneNumber = [data objectForKey:kPhone] ?: nil;
                     [MyUtils shared].user.timeCreated = [data objectForKey:kTimeCreated] ?: nil;
                     [MyUtils shared].user.avatarImageURL = [data objectForKey:kAvatarImageURL] ?: nil;
                     [MyUtils shared].user.backgroundImageURL = [data objectForKey:kBackgroundImageURL] ?: nil;
                     [MyUtils shared].user.businessName = [data objectForKey:kBusinessName] ?: nil;
                     [MyUtils shared].user.managerName = [data objectForKey:kManagerName] ?: nil;
                     [MyUtils shared].user.country = [data objectForKey:kCountry] ?: nil;
                     [MyUtils shared].user.address1 = [data objectForKey:kAddress1] ?: nil;
                     [MyUtils shared].user.address2 = [data objectForKey:kAddress2] ?: nil;
                     [MyUtils shared].user.city = [data objectForKey:kCity] ?: nil;
                     [MyUtils shared].user.state = [data objectForKey:kState] ?: nil;
                     [MyUtils shared].user.postalCode = [data objectForKey:kPostalCode] ?: nil;
                     [MyUtils shared].user.accountType = [data valueForKey:kAccountType] ? [[data valueForKey:kAccountType] integerValue] : 0;
                     [MyUtils shared].user.nativeLanguage = [data objectForKey:kNativeLanguage] ?: nil;
                     [MyUtils shared].user.spokenLanguages = [data objectForKey:kSpokenLanguages] ? [[data objectForKey:kSpokenLanguages] componentsSeparatedByString:@","] : nil;
                     [MyUtils shared].user.mainCategory = [data valueForKey:kMainCategory] ? [[data valueForKey:kMainCategory] integerValue] : 0;
                     [MyUtils shared].user.subCategories = [data objectForKey:kSubCategories] ? [[data objectForKey:kSubCategories] componentsSeparatedByString:@","] : nil;
                     [MyUtils shared].user.facebook = [data objectForKey:kFacebook] ?: nil;
                     [MyUtils shared].user.linkedin = [data objectForKey:kLinkedin] ?: nil;
                     [MyUtils shared].user.website = [data objectForKey:kWebsite] ?: nil;
                     [MyUtils shared].user.latitude = [data objectForKey:kLatitude] ? [[data objectForKey:kLatitude] doubleValue] :0;
                     [MyUtils shared].user.longitude = [data objectForKey:kLongitude] ? [[data objectForKey:kLongitude] doubleValue] : 0;
                     [MyUtils shared].user.verified = [data valueForKey:kVerified] ? [[data valueForKey:kVerified] boolValue] : false;
                     [MyUtils shared].user.blocked = [data valueForKey:kBlocked] ? [[data valueForKey:kBlocked] boolValue] : true;
                     [MyUtils shared].user.registeredCard = [data valueForKey:kRegisteredCard] ? [[data valueForKey:kRegisteredCard] boolValue] : false;
                     [MyUtils shared].user.password = password ;
                     NSMutableArray* favouriteIds = [data objectForKey:kFavouriteIds] ?: nil;
                     [MyUtils shared].user.favouriteIds = favouriteIds;
                     
                     [Preferences sharedInstance].phone = [MyUtils shared].user.phoneNumber;
                     [Preferences sharedInstance].password = [MyUtils shared].user.password;
                     [Preferences sharedInstance].userId = [MyUtils shared].user.identifier;
                     [Preferences sharedInstance].userName = [MyUtils shared].user.userName;
                     [Preferences sharedInstance].accessToken = [MyUtils shared].user.accessToken;
                     [Preferences sharedInstance].fullname = [MyUtils shared].user.fullName;
                     [Preferences sharedInstance].email = [MyUtils shared].user.email;
                     [Preferences sharedInstance].avatarImageURL = [MyUtils shared].user.avatarImageURL;
                     [Preferences sharedInstance].backgroundImageURL = [MyUtils shared].user.backgroundImageURL;
                     [Preferences sharedInstance].businessName = [MyUtils shared].user.businessName;
                     [Preferences sharedInstance].managerName = [MyUtils shared].user.managerName;
                     [Preferences sharedInstance].timeCreated = [MyUtils shared].user.timeCreated;
                     [Preferences sharedInstance].nativeLanguage = [MyUtils shared].user.nativeLanguage;
                     [Preferences sharedInstance].spokenLanguages = [MyUtils shared].user.spokenLanguages;
                     [Preferences sharedInstance].accountType = [MyUtils shared].user.accountType;
                     [Preferences sharedInstance].mainCategory = [MyUtils shared].user.mainCategory;
                     [Preferences sharedInstance].subCategories = [MyUtils shared].user.subCategories;
                     [Preferences sharedInstance].address1 = [MyUtils shared].user.address1;
                     [Preferences sharedInstance].address2 = [MyUtils shared].user.address2;
                     [Preferences sharedInstance].country = [MyUtils shared].user.country;
                     [Preferences sharedInstance].city = [MyUtils shared].user.city;
                     [Preferences sharedInstance].state = [MyUtils shared].user.state;
                     [Preferences sharedInstance].postalCode = [MyUtils shared].user.postalCode;
                     [Preferences sharedInstance].facebook = [MyUtils shared].user.facebook;
                     [Preferences sharedInstance].linkedin = [MyUtils shared].user.linkedin;
                     [Preferences sharedInstance].website = [MyUtils shared].user.website;
                     [Preferences sharedInstance].latitude = [MyUtils shared].user.latitude;
                     [Preferences sharedInstance].longitude = [MyUtils shared].user.longitude;
                     [Preferences sharedInstance].verified = [MyUtils shared].user.verified;
                     [Preferences sharedInstance].blocked = [MyUtils shared].user.blocked;
                     [Preferences sharedInstance].registeredCard = [MyUtils shared].user.registeredCard;
                     
                     completionHandler(data, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }

         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
    
}

+(void)signUpWithUser:(User*)user Completion:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = SIGNUP_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];

    [dataDic setObject:user.password forKey:kPassword];
    [dataDic setObject:user.userName forKey:kUserName];
    [dataDic setObject:user.email forKey:kEmail];
    [dataDic setObject:user.nativeLanguage forKey:kNativeLanguage];
    [dataDic setObject:[user.spokenLanguages componentsJoinedByString:@","] forKey:kSpokenLanguages];
    [dataDic setValue:@(user.accountType) forKey:kAccountType];
    [dataDic setValue:@(user.mainCategory) forKey:kMainCategory];
    [dataDic setObject:user.country forKey:kCountry];
    
    if(user.subCategories)
        [dataDic setObject:[user.subCategories componentsJoinedByString:@","] forKey:kSubCategories];
    if(user.fullName)
    {
        NSString* text = [user.fullName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kFullname];
    }
    if(user.avatarImageURL)
        [dataDic setObject:user.avatarImageURL forKey:kAvatarImageURL];
    if(user.backgroundImageURL)
        [dataDic setObject:user.backgroundImageURL forKey:kBackgroundImageURL];
    if(user.businessName)
    {
        NSString* text = [user.businessName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kBusinessName];
    }
    if(user.managerName)
    {
        NSString* text = [user.managerName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kManagerName];
    }
    if (user.phoneNumber)
        [dataDic setObject:user.phoneNumber forKey:kPhone];
    if(user.address1)
    {
        NSString* text = [user.address1 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kAddress1];
    }
    if(user.address2)
    {
        NSString* text = [user.address2 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kAddress2];
    }

    if(user.city)
        [dataDic setObject:user.city forKey:kCity];
    if(user.state)
        [dataDic setObject:user.state forKey:kState];
    if(user.postalCode)
        [dataDic setObject:user.postalCode forKey:kPostalCode];
    if(user.facebook)
        [dataDic setObject:user.facebook forKey:kFacebook];
    if(user.linkedin)
        [dataDic setObject:user.linkedin forKey:kLinkedin];
    if(user.website)
        [dataDic setObject:user.website forKey:kWebsite];
    if(user.creditCardInfo)
        [dataDic setObject:[user.creditCardInfo JSONRepresentation] forKey:kCreditCard];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     
                     [self loginWithUserName:user.userName Password:user.password DeviceToken:AppDelegateAccessor.dToken completionHandler:^(NSDictionary *passedResponse, NSError *error) {
                         completionHandler(result, nil);
                     }];
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
    
}


+(void)checkCardWithUser:(User*)user Completion:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = CHECKCARD_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:user.password forKey:kPassword];
    [dataDic setObject:user.userName forKey:kUserName];
    [dataDic setObject:user.email forKey:kEmail];
    [dataDic setObject:user.nativeLanguage forKey:kNativeLanguage];
    [dataDic setObject:[user.spokenLanguages componentsJoinedByString:@","] forKey:kSpokenLanguages];
    [dataDic setValue:@(user.accountType) forKey:kAccountType];
    [dataDic setValue:@(user.mainCategory) forKey:kMainCategory];
    [dataDic setObject:user.country forKey:kCountry];
    
    if(user.subCategories)
        [dataDic setObject:[user.subCategories componentsJoinedByString:@","] forKey:kSubCategories];
    if(user.fullName)
    {
        NSString* text = [user.fullName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kFullname];
    }
    if(user.avatarImageURL)
        [dataDic setObject:user.avatarImageURL forKey:kAvatarImageURL];
    if(user.backgroundImageURL)
        [dataDic setObject:user.backgroundImageURL forKey:kBackgroundImageURL];
    if(user.businessName)
    {
        NSString* text = [user.businessName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kBusinessName];
    }
    if(user.managerName)
    {
        NSString* text = [user.managerName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kManagerName];
    }
    if (user.phoneNumber)
        [dataDic setObject:user.phoneNumber forKey:kPhone];
    if(user.address1)
    {
        NSString* text = [user.address1 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kAddress1];
    }
    if(user.address2)
    {
        NSString* text = [user.address2 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kAddress2];
    }
    
    if(user.city)
        [dataDic setObject:user.city forKey:kCity];
    if(user.state)
        [dataDic setObject:user.state forKey:kState];
    if(user.postalCode)
        [dataDic setObject:user.postalCode forKey:kPostalCode];
    if(user.facebook)
        [dataDic setObject:user.facebook forKey:kFacebook];
    if(user.linkedin)
        [dataDic setObject:user.linkedin forKey:kLinkedin];
    if(user.website)
        [dataDic setObject:user.website forKey:kWebsite];
    if(user.creditCardInfo)
        [dataDic setObject:[user.creditCardInfo JSONRepresentation] forKey:kCreditCard];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);

                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
    
}

+(void)logout:(NSString*)deviceToken completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = LOGOUT_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    
    
    if (deviceToken != nil && ![deviceToken isEqualToString:@""]) {
        [dataDic setObject:deviceToken forKey:kDeviceToken];
    }
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     [[Preferences sharedInstance] clear];
                     [MyUtils shared].user = [[User alloc] init];
                     [MyUtils shared].tempUser = [[User alloc] init];
                     
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
    
}

/*Not Used*/
+(void)getVerificationCodeWithCountryCode:(int)countryCode LocalNumber:(NSString*)localNumber completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = VERIFICATION_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:[NSNumber numberWithLong:countryCode] forKey:@"country_code"];
    [dataDic setObject:localNumber forKey:@"phone"];
    
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
    
}

/*Not Used*/
+(void)resetPasswordWithVerificationCode:(NSString*)verificationCode LocalNumber:(NSString*)localNumber Password:(NSString*)password completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = RESET_PASSWORD_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:verificationCode forKey:@"verify_code"];
    [dataDic setObject:localNumber forKey:@"phone"];
    [dataDic setObject:password forKey:@"password"];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
    
}

+(void)updateProfile:(User*)user Completion: (void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = UPDATE_PROFILE_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@(user.identifier) forKey:kUserId];
    [dataDic setObject:user.password forKey:kPassword];
    [dataDic setObject:user.accessToken forKey:kAccessToken];
    [dataDic setObject:user.userName forKey:kUserName];
    [dataDic setObject:user.email forKey:kEmail];
    [dataDic setObject:user.nativeLanguage forKey:kNativeLanguage];
    [dataDic setObject:[user.spokenLanguages componentsJoinedByString:@","] forKey:kSpokenLanguages];
    [dataDic setValue:@(user.accountType) forKey:kAccountType];
    
    if (user.mainCategory) {
        [dataDic setValue:@(user.mainCategory) forKey:kMainCategory];
    }
    
    if (user.subCategories) {
        [dataDic setObject:[user.subCategories componentsJoinedByString:@","] forKey:kSubCategories];
    }
    
    
    if(user.fullName)
    {
        NSString* text = [user.fullName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kFullname];
    }
    if(user.avatarImageURL)
        [dataDic setObject:user.avatarImageURL forKey:kAvatarImageURL];
    if(user.backgroundImageURL)
        [dataDic setObject:user.backgroundImageURL forKey:kBackgroundImageURL];
    if(user.businessName)
    {
        NSString* text = [user.businessName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kBusinessName];
    }
    if(user.managerName)
    {
        NSString* text = [user.managerName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kManagerName];
    }
    if (user.phoneNumber)
        [dataDic setObject:user.phoneNumber forKey:kPhone];
    if(user.address1)
    {
        NSString* text = [user.address1 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kAddress1];
    }
    if(user.address2)
    {
        NSString* text = [user.address2 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [dataDic setObject:text forKey:kAddress2];
    }
    if (user.country)
        [dataDic setObject:user.country forKey:kCountry];
    if(user.city)
        [dataDic setObject:user.city forKey:kCity];
    if(user.state)
        [dataDic setObject:user.state forKey:kState];
    if(user.postalCode)
        [dataDic setObject:user.postalCode forKey:kPostalCode];
    if(user.facebook)
        [dataDic setObject:user.facebook forKey:kFacebook];
    if(user.linkedin)
        [dataDic setObject:user.linkedin forKey:kLinkedin];
    if(user.website)
        [dataDic setObject:user.website forKey:kWebsite];
    if(user.creditCardInfo)
        [dataDic setObject:[user.creditCardInfo JSONRepresentation] forKey:kCreditCard];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     [self loginWithUserName:user.userName Password:user.password DeviceToken:AppDelegateAccessor.dToken completionHandler:^(NSDictionary *passedResponse, NSError *error) {
                         completionHandler(result, nil);
                     }];

                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
    
}
+(void)getNearbyUsersWithRadius:(int)radius MainCategory:(TPMainCategory)mainCategory SubCategories:(NSArray*)subCategories Latitude:(double)latitude Longitude:(double)longitude Count:(int)count Page:(long)page completionHandler:(void (^)(NSMutableArray *passedResponse, NSError *error))completionHandler
{
    NSString* serverURL = BASE_URL;
    NSString* api = GET_NEARBY_USERS_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setValue:@([MyUtils shared].user.accountType) forKey:kAccountType];
    [dataDic setValue:@(mainCategory) forKey:kMainCategory];
    [dataDic setObject:[subCategories componentsJoinedByString:@","] forKey:kSubCategories];
    [dataDic setValue:@(longitude) forKey:kLongitude];
    [dataDic setValue:@(latitude) forKey:kLatitude];
    [dataDic setValue:@(radius) forKey:kRadius];
    [dataDic setValue:@(count) forKey:kPageCount];
    [dataDic setValue:@(page) forKey:kCurrentPage];
    
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     NSMutableArray* users = [[NSMutableArray alloc] init];
                     NSArray* data = [result objectForKey:@"data"];
                     for (NSDictionary* dic in data) {
                         User* user = [User userFromDic:dic];
                         if (user) {
                             [users addObject:user];
                         }
                     }
                     completionHandler(users, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}

+(void)getNearbyUsersWithRadius:(int)radius Count:(int)count Page:(long)page completionHandler:(void (^)(NSMutableArray *passedResponse, NSError *error))completionHandler
{
    [self getNearbyUsersWithRadius:radius MainCategory:[MyUtils shared].user.mainCategory SubCategories:[MyUtils shared].user.subCategories Latitude:[MyUtils shared].user.latitude Longitude:[MyUtils shared].user.longitude Count:count Page:page completionHandler:completionHandler];
}

+(void)getUserReviews:(long)searchUserId Count:(int)count Page:(long)page completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = GET_USER_REVIEWS_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setObject:@(searchUserId) forKey:kSearchUserID];
    [dataDic setValue:@(count) forKey:kPageCount];
    [dataDic setValue:@(page) forKey:kCurrentPage];
    
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     NSDictionary* reviews = [result objectForKey:@"data"];
                     completionHandler(reviews, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}


+(void)writeUserReview:(long)searchUserId Rating:(int)rating Text:(NSString*)text completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = WRITE_USER_REVIEW_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setObject:@(searchUserId) forKey:kSearchUserID];
    [dataDic setValue:@(rating) forKey:kRating];
    [dataDic setValue:text forKey:kText];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}

+(void)getFavouriteUsers:(int)count Page:(long)page completionHandler:(void (^)(NSMutableArray *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = GET_FAVOURITE_USERS_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setValue:@([MyUtils shared].user.accountType) forKey:kAccountType];
    [dataDic setValue:@(count) forKey:kPageCount];
    [dataDic setValue:@(page) forKey:kCurrentPage];
    
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     NSMutableArray* users = [[NSMutableArray alloc] init];
                     NSArray* data = [result objectForKey:@"data"];
                     for (NSDictionary* dic in data) {
                         User* user = [User userFromDic:dic];
                         if (user) {
                             [users addObject:user];
                         }
                     }
                     completionHandler(users, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}

+(void)favouriteUser:(long)searchUserId completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
{
    NSString* serverURL = BASE_URL;
    NSString* api = FAVOURITE_USER_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setObject:@(searchUserId) forKey:kSearchUserID];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}

+(void)disFavouriteUser:(long)searchUserId completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = DISFAVOURITE_USER_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setValue:@([MyUtils shared].user.accountType) forKey:kAccountType];
    [dataDic setObject:@(searchUserId) forKey:kSearchUserID];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}

+(void)getUserUploadedPhotos:(long)searchUserId Count:(int)count Page:(long)page completionHandler:(void (^)(NSArray *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = GET_USER_UPLOADED_PHOTOS_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setObject:@(searchUserId) forKey:kSearchUserID];
    [dataDic setValue:@(count) forKey:kPageCount];
    [dataDic setValue:@(page) forKey:kCurrentPage];
    
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     NSArray* photos = [result objectForKey:@"data"];
                     completionHandler(photos, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}
+(void)deleteUserUploadedPhoto:(NSString*)photoIds completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = DELETE_USER_UPLOADED_PHOTOS_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setObject:photoIds forKey:kPhotoIDs];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}

+(void)uploadUserPhoto:(NSString*)photoURL Thumbnail:(NSString*)thumbnail completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = UPLOAD_USER_PHOTO_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setObject:photoURL forKey:kPhotoURL];
    [dataDic setObject:thumbnail ?: @"" forKey:kThumbnail];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     NSDictionary* data = [result objectForKey:@"data"];
                     completionHandler(data, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}
+(void)getGreetingWords:(long)searchUserId completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = GET_GREETING_WORDS_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setObject:@(searchUserId) forKey:kSearchUserID];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     NSDictionary* greeting = [result objectForKey:@"data"];
                     completionHandler(greeting, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}

+(void)writeGreetingWords:(NSString*)text Completion:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = WRITE_GREETING_WORDS_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setObject:text forKey:kText];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}
+(void)updateLocation:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = UPDATE_LOCATION_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setValue:@([MyUtils shared].user.longitude) forKey:kLongitude];
    [dataDic setValue:@([MyUtils shared].user.latitude) forKey:kLatitude];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}
+ (NSDictionary *)uploadFile:(NSString*)type FileName:(NSString *)filename withData:(NSData*)data
{
    if (data == nil) {
        return nil;
    }
    // setting up the URL to post to
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?user_id=%ld&token=%@&file=binaryfile&type=%@", BASE_URL, UPLOAD_PHOTO_URL,[MyUtils shared].user.identifier, [MyUtils shared].user.accessToken, type];
    
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    /*
     add some header info now
     we always need a boundary when we post a file
     also we need to set the content type
     
     You might want to generate a random boundary.. this is just the same
     as my output from wireshark on a valid html post
     */
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /*
     now lets create the body of the post
     */
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"%@.png", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"photo upload returnData = %@", returnString);
    
    if (returnData == nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSDictionary *myJson = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:&error];
    
    if([[myJson valueForKey:@"status"] isEqualToString:@"error"])
    {
        NSLog(@"It failed to upload the avatar");
    }
    
    if([[myJson valueForKey:@"status"] isEqualToString:@"success"])
    {
        return myJson;
    }
    
    return nil;
}

+(void)registerChatUserWithId:(NSString*)userId Name:(NSString*)name Password:(NSString*)password Email:(NSString*)email completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    /*NSString* registerURL = @"http://121.41.77.201:9090/plugins/userService/userservice?type=add&secret=m8bIXEXM&username=1&password=Great2015&name=12312313315&email=tester@pincooler.com";
     NSError* error;
     NSStringEncoding encoding;
     NSString* result = [NSString stringWithContentsOfURL:[NSURL URLWithString:registerURL] encoding:encoding error:&error];
     */
    NSString* serverURL = PKL_XMPP_REGISTER_USER_URL;
    NSString* api = @"userservice";
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:userId forKey:@"username"];
    [dataDic setObject:password forKey:@"password"];
    [dataDic setObject:@"add" forKey:@"type"];
    [dataDic setObject:PKL_XMPP_ADMIN_SECRET_KEY forKey:@"secret"];
    [dataDic setObject:name forKey:@"name"];
    [dataDic setObject:email forKey:@"email"];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     getPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             if ( [[responseString lowercaseString] rangeOfString:@"ok"].location != NSNotFound) {
                 NSDictionary* result = @{@"success" : @"yes"};
                 completionHandler(result, nil);
             }
             else{
                 
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
                 
                 NSDictionary* result = @{@"success" : @"no"};
                 completionHandler(result, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}

+(void)changePassword:(NSString*)userName Completion:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler
{
    
    NSString* serverURL = BASE_URL;
    NSString* api = CHANGE_PASSWORD_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:userName forKey:kUserName];
    [dataDic setObject:@"change_password" forKey:kType];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     completionHandler(result, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}

+(void)reportViolation:(int)photoId completionHandler:(void (^)(NSArray *passedResponse, NSError *error))completionHandler
{
    NSString* serverURL = BASE_URL;
    NSString* api = REPORT_VIOLATION_URL;
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setValue:@([MyUtils shared].user.identifier) forKey:kUserId];
    [dataDic setObject:[MyUtils shared].user.accessToken forKey:kAccessToken];
    [dataDic setValue:@(photoId) forKey:kPhotoID];
    
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverURL] ];
    
    [client
     postPath:api
     parameters:dataDic
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSMutableDictionary *details = [NSMutableDictionary dictionary];
             [details setValue:@"There was an error communicating with the server" forKey:NSLocalizedDescriptionKey];
             NSError *error = [NSError errorWithDomain:SERVER_ERROR  code:operation.response.statusCode userInfo:details];
             completionHandler(nil, error);
         } else {
             NSString* responseString = [operation responseString];
             NSDictionary *result = [responseString JSONValue];
             if([result objectForKey:@"status"])
             {
                 if([[result objectForKey:@"status"] isEqualToString:@"success"])
                 {
                     NSArray* data = [result objectForKey:@"data"];
                     completionHandler(data, nil);
                 }
                 else{
                     NSMutableDictionary *details = [NSMutableDictionary dictionary];
                     [details setValue:[result objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                     NSError *error = [NSError errorWithDomain:RESULT_FAILED  code:0 userInfo:details];
                     completionHandler(nil, error);
                 }
                 
             }
             else{
                 NSMutableDictionary *details = [NSMutableDictionary dictionary];
                 [details setValue:responseString forKey:NSLocalizedDescriptionKey];
                 NSError *error = [NSError errorWithDomain:INVALID_ACCESS  code:0 userInfo:details];
                 completionHandler(nil, error);
             }
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completionHandler(nil, error);
     }];
}
@end

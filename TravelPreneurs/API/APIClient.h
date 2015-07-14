//
//  APIClient.h
//  pinion
//
//  Created by CGH on 10/9/14.
//  Copyright (c) 2014 jianming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface APIClient : NSObject
+(void)loginWithUserName:(NSString*)userName Password:(NSString*)password DeviceToken:(NSString*)deviceToken completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)logout:(NSString*)deviceToken completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)getVerificationCodeWithCountryCode:(int)countryCode LocalNumber:(NSString*)localNumber completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)resetPasswordWithVerificationCode:(NSString*)verificationCode LocalNumber:(NSString*)localNumber Password:(NSString*)password completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)signUpWithUser:(User*)user Completion:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)updateProfile:(User*)user Completion: (void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)getNearbyUsersWithRadius:(int)radius MainCategory:(TPMainCategory)mainCategory SubCategories:(NSArray*)subCategories Latitude:(double)latitude Longitude:(double)longitude Count:(int)count Page:(long)page completionHandler:(void (^)(NSMutableArray *passedResponse, NSError *error))completionHandler;
+(void)getNearbyUsersWithRadius:(int)radius Count:(int)count Page:(long)page completionHandler:(void (^)(NSMutableArray *passedResponse, NSError *error))completionHandler;
+(void)getUserReviews:(long)searchUserId Count:(int)count Page:(long)page completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)writeUserReview:(long)searchUserId Rating:(int)rating Text:(NSString*)text completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)getFavouriteUsers:(int)count Page:(long)page completionHandler:(void (^)(NSMutableArray *passedResponse, NSError *error))completionHandler;
+(void)favouriteUser:(long)searchUserId completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)disFavouriteUser:(long)searchUserId completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)getUserUploadedPhotos:(long)searchUserId Count:(int)count Page:(long)page completionHandler:(void (^)(NSArray *passedResponse, NSError *error))completionHandler;
+(void)uploadUserPhoto:(NSString*)photoURL Thumbnail:(NSString*)thumbnail completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)deleteUserUploadedPhoto:(NSString*)photoIds completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)getGreetingWords:(long)searchUserId completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)writeGreetingWords:(NSString*)text Completion:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)reportViolation:(int)photoId completionHandler:(void (^)(NSArray *passedResponse, NSError *error))completionHandler;
+(void)updateLocation:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;

+(void)registerChatUserWithId:(NSString*)userId Name:(NSString*)name Password:(NSString*)password Email:(NSString*)email completionHandler:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
+(void)changePassword:(NSString*)userName Completion:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;

+ (NSDictionary *)uploadFile:(NSString*)type FileName:(NSString *)filename withData:(NSData*)data;
+(void)checkCardWithUser:(User*)user Completion:(void (^)(NSDictionary *passedResponse, NSError *error))completionHandler;
@end

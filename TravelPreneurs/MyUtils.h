//
//  MySingleton.h
//  LeaderBoard
//
//  Created by cgh on 9/4/13.
//  Copyright (c) 2013 shinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyEnums.h"
#import "User.h"
#import <CoreLocation/CoreLocation.h>

@interface MyUtils : NSObject
@property User* user;
@property User* tempUser;

@property CLLocation* currentLocation;

@property int searchRadius;

@property (strong, nonatomic) NSMutableDictionary* chatMessages;
@property (strong, nonatomic) NSMutableDictionary* chatRedFlagDic;
@property (strong, nonatomic) NSMutableDictionary* translationDic;
- (id) initSingleton;
+ (MyUtils *) shared;

-(void)applyDefaultFonts:(UIView*)parentView;
-(void) makeCircleView:(UIView*) view;
-(void) makeCircleViewWithBorder:(UIView *)view BorderWidth:(int) borderWidth BorderColor:(UIColor*) borderColor;
-(void) makeRectOutlineOfView:(UIView *)view;
-(NSString *) randomStringWithLength: (int) len;

-(NSString*) convertMainCategoryToString: (int) category;

-(NSString*) getChattingRoomIdentifierWith:(long)userIdentifier;
-(void)setTranslationLanguage:(NSString*)language;
-(NSString*)translateWith:(NSString*)key;
-(void)applyTranslation:(UIView*)parentView;

@end

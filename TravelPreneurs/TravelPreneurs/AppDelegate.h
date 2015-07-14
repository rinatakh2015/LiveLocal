//
//  AppDelegate.h
//  TravelPreneurs
//
//  Created by CGH on 12/14/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XMPPFramework.h"
#import "XMPPRoomMemoryStorage.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

#define AppDelegateAccessor ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@class CEReversibleAnimationController, CEBaseInteractionController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,  CLLocationManagerDelegate , XMPPRosterDelegate, XMPPRoomDelegate, XMPPMUCDelegate>
{
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPMUC                             *roomMuc;
    
    NSString *password;
    BOOL allowSelfSignedCertificates;
    BOOL allowSSLHostNameMismatch;
    BOOL isOpen;
    NSMutableArray *buddyArray;
    
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRoomCoreDataStorage *xmppRoomStorage;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong) XMPPRoom *xmppChatRoom;

@property (nonatomic, strong) id  _messageDelegate;
@property (nonatomic, strong) NSMutableArray *buddyArray;
@property (nonatomic, strong) NSMutableArray *arrPendingJid;
@property (nonatomic, strong) NSMutableArray *arrPendingGroupID;

@property (nonatomic, strong) NSMutableDictionary *groupInvitesDic;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *dToken;

@property (strong, nonatomic) CEReversibleAnimationController *settingsAnimationController;
@property (strong, nonatomic) CEReversibleAnimationController *navigationControllerAnimationController;
@property (strong, nonatomic) CEBaseInteractionController *navigationControllerInteractionController;
@property (strong, nonatomic) CEBaseInteractionController *settingsInteractionController;

@property (nonatomic, strong) CLLocationManager *locationManager;

-(BOOL) connect;
-(void) disconnect;

-(void) createGroup:(NSString *) groupID invites:(NSMutableArray *) userInvites;

@end


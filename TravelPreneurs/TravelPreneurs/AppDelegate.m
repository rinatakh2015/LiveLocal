//
//  AppDelegate.m
//  TravelPreneurs
//
//  Created by CGH on 12/14/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "AppDelegate.h"
#import "CEFlipAnimationController.h"
#import "CEHorizontalSwipeInteractionController.h"
#import "MyUtils.h"
#import "APIClient.h"
#import "global_functions.h"
#import "defs.h"
#import "NSDate+Custom.h"
#import "Preferences.h"
#import "NSDateFormatter+Custom.h"

@interface AppDelegate ()
- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;
@end

@implementation AppDelegate

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRoomStorage;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppChatRoom;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //AppDelegateAccessor.navigationControllerAnimationController = [CEFlipAnimationController new];
    //AppDelegateAccessor.navigationControllerInteractionController = [CEHorizontalSwipeInteractionController new];
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
    }
    
    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            NSLog(@"Launched from push notification: %@", dictionary);
            //[self addMessageFromRemoteNotification:dictionary updateUI:NO];
        }
    }

    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestAlwaysAuthorization];
    //[self.locationManager startUpdatingLocation];
    //[self.locationManager startMonitoringSignificantLocationChanges];
    
    // Setup the XMPP stream
    [self setupStream];
    
    if ([Preferences sharedInstance].nativeLanguage) {
        [[MyUtils shared] setTranslationLanguage:[Preferences sharedInstance].nativeLanguage];
    }
    else
        [[MyUtils shared] setTranslationLanguage:@"english"];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    _dToken = [[[deviceToken description]
                stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
               stringByReplacingOccurrencesOfString:@" "
               withString:@""];
    NSLog(@"My token is: %@", deviceToken);
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Device token error: %@", [err localizedDescription]);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {

    [self.locationManager stopMonitoringSignificantLocationChanges];
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        isInBackground = YES;
    }
    
    [MyUtils shared].currentLocation = ((CLLocation*)[locations lastObject]);
    //if logged in
    if ([MyUtils shared].currentLocation && [MyUtils shared].user.identifier && ([MyUtils shared].user.accountType == TPAccountType_TRAVELER || [MyUtils shared].user.accountType == TPAccountType_MOBILE_BUSINESS)) {
        
        [MyUtils shared].user.latitude = [MyUtils shared].currentLocation.coordinate.latitude;
        [MyUtils shared].user.longitude = [MyUtils shared].currentLocation.coordinate.longitude;
        [APIClient updateLocation:^(NSDictionary *passedResponse, NSError *error) {
            if (error) {
                //ShowErrorAlert(error.localizedDescription);
            }
        }];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
    return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
    return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

#pragma mark XMPP Setup Stream
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupStream
{
    roomMuc = [[XMPPMUC alloc]initWithDispatchQueue:dispatch_get_main_queue()];
    
    // Multi user chat
    xmppRoomStorage=[[XMPPRoomCoreDataStorage alloc]init];
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    
    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    // Setup capabilities
    //
    // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
    // Basically, when other clients broadcast their presence on the network
    // they include information about what capabilities their client supports (audio, video, file transfer, etc).
    // But as you can imagine, this list starts to get pretty big.
    // This is where the hashing stuff comes into play.
    // Most people running the same version of the same client are going to have the same list of capabilities.
    // So the protocol defines a standardized way to hash the list of capabilities.
    // Clients then broadcast the tiny hash instead of the big list.
    // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
    // and also persistently storing the hashes so lookups aren't needed in the future.
    //
    // Similarly to the roster, the storage of the module is abstracted.
    // You are strongly encouraged to persist caps information across sessions.
    //
    // The XMPPCapabilitiesCoreDataStorage is an ideal solution.
    // It can also be shared amongst multiple streams to further reduce hash lookups.
    
    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // Activate xmpp modules
    
    [xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];
    [xmppCapabilities      activate:xmppStream];
    [roomMuc               activate:xmppStream];
    
    // Add ourself as a delegate to anything we may be interested in
    [roomMuc addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // Optional:
    //
    // Replace me with the proper domain and port.
    // The example below is setup for a typical google talk account.
    //
    // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
    // For example, if you supply a JID like 'user@quack.com/rsrc'
    // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
    //
    // If you don't specify a hostPort, then the default (5222) will be used.
    
    [xmppStream setHostAddress:PKL_XMPP_SERVER_NAME];
    [xmppStream setHostPort:PKL_XMPP_PORT];
    
    [xmppStream setHostName:PKL_XMPP_DOMAIN_NAME];
    
    // You may need to alter these settings depending on the server you're connecting to
    allowSelfSignedCertificates = NO;
    allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect         deactivate];
    [xmppRoster            deactivate];
    [xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    [xmppCapabilities      deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
    xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
    xmppvCardAvatarModule = nil;
    xmppCapabilities = nil;
    xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    
    NSLog(@"%@", presence);
    [[self xmppStream] sendElement:presence];

    if ([MyUtils shared].user.favouriteIds) {
        for (NSString* favouriteId in [MyUtils shared].user.favouriteIds) {
            [AppDelegateAccessor createGroup:[[MyUtils shared] getChattingRoomIdentifierWith:[favouriteId integerValue]] invites:nil];
        }
    }

    
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect {
    
    if (![xmppStream isDisconnected]) {
       return YES;
    }
    
    NSString *jabberID = [NSString stringWithFormat:@"%ld@%@", [MyUtils shared].user.identifier, PKL_XMPP_DOMAIN_NAME];
    NSString *jabberPassword = PKL_XMPP_USER_DEFAULT_PASSWORD;
    NSLog(@"jabberuserID:%@:%@", jabberID, jabberPassword);
    
    if (jabberID == nil || jabberPassword == nil) {
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    password = jabberPassword;
    
    NSError *error = nil;

    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
         message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
         delegate:nil
         cancelButtonTitle:@"Ok"
         otherButtonTitles:nil];
         [alertView show];
        return NO;
    }
    
    return YES;
}

- (void)disconnect {
    //[self postLeaveRequest];
    [self goOffline];
    [xmppStream disconnect];
}


/**************************XMPP*******************************/
#define kInviteSubscription 20150113

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

#pragma mark -
#pragma mark XMPP delegates

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if (allowSelfSignedCertificates)
    {
        [settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
    }
    
    if (allowSSLHostNameMismatch)
    {
        [settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
    }
    else
    {
        // Google does things incorrectly (does not conform to RFC).
        // Because so many people ask questions about this (assume xmpp framework is broken),
        // I've explicitly added code that shows how other xmpp clients "do the right thing"
        // when connecting to a google server (gmail, or google apps for domains).
        
        NSString *expectedCertName = nil;
        
        NSString *serverDomain = xmppStream.hostName;
        NSString *virtualDomain = [xmppStream.myJID domain];
        
        if ([serverDomain isEqualToString:@"talk.google.com"])
        {
            if ([virtualDomain isEqualToString:@"gmail.com"])
            {
                expectedCertName = virtualDomain;
            }
            else
            {
                expectedCertName = serverDomain;
            }
        }
        else if (serverDomain == nil)
        {
            expectedCertName = virtualDomain;
        }
        else
        {
            expectedCertName = serverDomain;
        }
        
        if (expectedCertName)
        {
            [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
        }
    }
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    isOpen = YES;
    
    NSError *error = nil;
    [[self xmppStream] authenticateWithPassword:password error:&error];
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [self registerToXMPPWithSuccess:^{
        //[self connect];
        [xmppStream authenticateWithPassword:PKL_XMPP_USER_DEFAULT_PASSWORD error:nil];
        
    } Failure:^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Can't authenticate to chat server"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSXMLElement *queryElement = [iq elementForName: @"query" xmlns: @"http://jabber.org/protocol/disco#items"];
    
    if (queryElement) {
        NSArray *itemElements = [queryElement elementsForName: @"item"];
        
        for (int i=0; i<[itemElements count]; i++) {
            
            NSString *jid=[[[itemElements objectAtIndex:i] attributeForName:@"jid"] stringValue];
            NSString *name=[[[itemElements objectAtIndex:i] attributeForName:@"name"] stringValue];
            NSLog(@"jid = %@ name = %@",jid, name);
            [self.buddyArray addObject:name];
        }
        if ([self.buddyArray count] > 0)
        {
            //notify buddy list
        }
    }
    
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // A simple example of inbound message handling.
    
    if ([message isChatMessageWithBody])
    {
        NSString *chatType = [[message attributeForName:@"type"] stringValue];
        NSString *gidStr = [[message elementForName:@"GroupId"] stringValue];
        NSString *deleteMember = [[message elementForName:@"deleteMember"] stringValue];
        
        NSString *body = [[message elementForName:@"body"] stringValue];
        DDXMLElement *delay = [message elementForName:@"delay"]; // this element exists if this message is history message.
        NSString* stamp = nil;
        if(delay)
        {
            stamp = [[delay attributeForName:@"stamp"] stringValue];
        }
        
        NSString *msgType = [[message elementForName:@"messageType"] stringValue];
        
        if (msgType == nil) {
            msgType = PKL_MESSAGE_TYPE_TEXT;
        }
        
        NSString* senderJid = [[message attributeForName:@"from"] stringValue];
        //NSString *username = [[message from] user]; //This wiill return the id of chatroom, so we can get group id without using GroupId element separaely.
        NSString* username = [[senderJid componentsSeparatedByString:@"/"] objectAtIndex:1];
        
        /*if (!username || [username isEqualToString:[NSString stringWithFormat:@"%ld", [MyUtils shared].user.identifier]])
            return;*/

        NSMutableDictionary* dic = [MyUtils shared].chatRedFlagDic;
        if (username && ![username isEqualToString:[NSString stringWithFormat:@"%ld", [MyUtils shared].user.identifier]])
            [[MyUtils shared].chatRedFlagDic setValue:@(1) forKey:username];
        
        /*if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            
        }
        else
        {
            // We are not active, so use a local notification instead
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"Ok";
            localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",username,body];
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }*/
        
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:body forKey:@"msg"];
        [m setObject:username forKey:@"sender"];
        if (gidStr) {
            [m setObject:gidStr forKey:@"groupid"];
        }
        if (deleteMember) {
            [m setObject:deleteMember forKey:@"deleteMember"];
        }
        [m setObject:chatType forKey:@"type"];
        [m setObject:msgType forKey:@"messageType"];

        if (!stamp) {
            [m setObject:[NSDate getCurrentTime] forKey:@"time"];
        }
        else{
            NSDate* date = [[NSDateFormatter jsonDateFormatter] dateFromString:stamp];
            [m setObject:[NSDate getCommonTimeStr:date] forKey:@"time"];
        }
        
        
        NSMutableArray* messageArray = [[MyUtils shared].chatMessages objectForKey:gidStr];
        if (messageArray) {
            [messageArray addObject:m];
        }
        else{
            messageArray = [[NSMutableArray alloc ] initWithObjects:m, nil];
            [[MyUtils shared].chatMessages setObject:messageArray forKey:gidStr];
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newMessageReceived" object:m];
        
        
        
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    //    NSString *presenceType = [presence type]; // online/offline
    //	NSString *myUsername = [[sender myJID] user];
    //	NSString *presenceFromUser = [[presence from] user];
    //
    //	if (![presenceFromUser isEqualToString:myUsername]) {
    //		if ([presenceType isEqualToString:@"available"]) {
    //
    //
    //
    //		} else if ([presenceType isEqualToString:@"unavailable"]) {
    //
    //
    //
    //		}
    //	}
    //
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if (!isOpen)
    {
        DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
    }
}

- (void)dealloc {
    [self teardownStream];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Sent when a presence subscription request is received.
 * That is, another user has added you to their roster,
 * and is requesting permission to receive presence broadcasts that you send.
 *
 * The entire presence packet is provided for proper extensibility.
 * You can use [presence from] to get the JID of the user who sent the request.
 *
 * The methods acceptPresenceSubscriptionRequestFrom: and rejectPresenceSubscriptionRequestFrom: can
 * be used to respond to the request.
 **/
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *username = [jidStrBare stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@", PKL_XMPP_DOMAIN_NAME] withString:@""];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        // body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
        if (displayName != nil)
            body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
        else
            body = [NSString stringWithFormat:@"Buddy request from %@", username];
    }
    else
    {
        // body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
        body = [NSString stringWithFormat:@"Buddy request from %@", user.jid.user];
    }
    
    [self.arrPendingJid addObject:[presence from]];
    if ([presence attributeStringValueForName:@"groupID"]) {
        [self.arrPendingGroupID addObject:[presence attributeStringValueForName:@"groupID"]];
    } else {
        [self.arrPendingGroupID addObject:@""];
    }
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:self
                                                  cancelButtonTitle:@"Accept"
                                                  otherButtonTitles:@"Reject", nil];
        alertView.tag = kInviteSubscription;
        [alertView show];
    }
    else
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"OK";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

- (void)removedUser:(XMPPJID *)userJID {
    NSString *username = [[userJID full] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@", PKL_XMPP_DOMAIN_NAME] withString:@""];
}

/**
 * Sent when a Roster Push is received as specified in Section 2.1.6 of RFC 6121.
 **/
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq
{
    
}

/**
 * Sent when the initial roster is received.
 **/
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    
}

/**
 * Sent when the initial roster has been populated into storage.
 **/
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    //    [[AppDelegate sharedInstance] getAllRegisteredUsers];
}

/**
 * Sent when the roster recieves a roster item.
 *
 * Example:
 *
 * <item jid='romeo@example.net' name='Romeo' subscription='both'>
 *   <group>Friends</group>
 * </item>
 **/
- (void)xmppRoster:(XMPPRoster *)sender didRecieveRosterItem:(NSXMLElement *)item
{
    
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
    
    NSString *displayName = [user displayName];
    NSString *jidStrBare = [presence fromStr];
    NSString *username = [jidStrBare stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@", PKL_XMPP_DOMAIN_NAME] withString:@""];
    NSString *body = nil;
    
    if (![displayName isEqualToString:jidStrBare])
    {
        // body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
        if (displayName != nil)
            body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
        else
            body = [NSString stringWithFormat:@"Buddy request from %@", username];
    }
    else
    {
        // body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
        body = [NSString stringWithFormat:@"Buddy request from %@", user.jid.user];
    }
    
    [self.arrPendingJid addObject:[presence from]];
    if ([presence attributeStringValueForName:@"groupID"]) {
        [self.arrPendingGroupID addObject:[presence attributeStringValueForName:@"groupID"]];
    } else {
        [self.arrPendingGroupID addObject:@""];
    }
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
                                                            message:body
                                                           delegate:self
                                                  cancelButtonTitle:@"Accept"
                                                  otherButtonTitles:@"Reject", nil];
        alertView.tag = kInviteSubscription;
        [alertView show];
    }
    else
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"OK";
        localNotification.alertBody = body;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

#pragma mark GetAllUsers
- (void)getAllRegisteredUsers {
    
    NSError *error = [[NSError alloc] init];
    NSXMLElement *query = [[NSXMLElement alloc] initWithXMLString:@"<query xmlns='http://jabber.org/protocol/disco#items' node='all users'/>"
                                                            error:&error];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get"
                                 to:[XMPPJID jidWithString:PKL_XMPP_DOMAIN_NAME]
                          elementID:[xmppStream generateUUID] child:query];
    [xmppStream sendElement:iq];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag != kInviteSubscription)
        return;
    
    XMPPJID *pendingJid = [self.arrPendingJid objectAtIndex:self.arrPendingJid.count - 1];
    //NSString *pendingGroupID = [self.arrPendingGroupID objectAtIndex:self.arrPendingGroupID.count - 1];
    [self.arrPendingJid removeObject:pendingJid];
    //[self.arrPendingGroupID removeObject:pendingGroupID];
    //NSString *username = [[pendingJid full] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@", PKL_XMPP_DOMAIN_NAME] withString:@""];
    
    if (buttonIndex == 1)
    {
        //Accept
        [xmppRoster acceptPresenceSubscriptionRequestFrom:pendingJid andAddToRoster:YES];
        
    }
    else if (buttonIndex == 0)
    {
        
        //reject
        [xmppRoster rejectPresenceSubscriptionRequestFrom:pendingJid];
    }
}

#pragma mark - XMPP MultiUserChat

-(void) createGroup:(NSString *) groupID invites:(NSMutableArray *) userInvites{
    
    //NSString *uname = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    XMPPRoomMemoryStorage* roomStorage= [[XMPPRoomMemoryStorage alloc]init];
    
    XMPPJID *chatRoomJID = [XMPPJID jidWithUser:groupID domain:[NSString stringWithFormat: @"conference.%@", PKL_XMPP_DOMAIN_NAME] resource:nil];
    
    XMPPRoom* groupRoom = [[XMPPRoom alloc]initWithRoomStorage:roomStorage jid:chatRoomJID dispatchQueue:dispatch_get_main_queue()];

    [groupRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [groupRoom activate:xmppStream];
    
    long oneMonthSeconds = 3600 * 24 * 30;
    NSXMLElement *history = [NSXMLElement elementWithName:@"history"];
    [history addAttributeWithName:@"seconds" stringValue:[NSString stringWithFormat:@"%ld", oneMonthSeconds]];
    
    [groupRoom joinRoomUsingNickname:[NSString stringWithFormat:@"%ld", [MyUtils shared].user.identifier] history:history password:@"admin765"];
    

    if(!self.groupInvitesDic)
        self.groupInvitesDic = [[NSMutableDictionary alloc] init];

    if(userInvites)
        [self.groupInvitesDic setObject:userInvites forKey:groupID];
    
    self.xmppChatRoom = groupRoom;

}
/*
- (void)inviteUser:(NSString *)groupid member:(NSString *)member {
    
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@", member, PKL_XMPP_DOMAIN_NAME];
    NSString *inviteMessageStr = @"Join Group";
    
    NSXMLElement *invite = [NSXMLElement elementWithName:@"invite"];
    [invite addAttributeWithName:@"to" stringValue:jidStr];
    
    if ([inviteMessageStr length] > 0)
    {
        [invite addChild:[NSXMLElement elementWithName:@"reason" stringValue:inviteMessageStr]];
    }
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCUserNamespace];
    [x addChild:invite];
    
    XMPPMessage *message = [XMPPMessage message];
    [message addAttributeWithName:@"groupid" stringValue:groupid];
    [message addAttributeWithName:@"to" stringValue:jidStr];
    [message addChild:x];
    
    [xmppStream sendElement:message];
}

- (void)declineUser:(NSString *)groupid member:(NSString *)member {
    
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@", member, PKL_XMPP_DOMAIN_NAME];
    NSString *inviteMessageStr = @"Join Group";
    
    NSXMLElement *decline = [NSXMLElement elementWithName:@"decline"];
    [decline addAttributeWithName:@"to" stringValue:jidStr];
    
    if ([inviteMessageStr length] > 0)
    {
        [decline addChild:[NSXMLElement elementWithName:@"reason" stringValue:inviteMessageStr]];
    }
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCUserNamespace];
    [x addChild:decline];
    
    XMPPMessage *message = [XMPPMessage message];
    [message addAttributeWithName:@"groupid" stringValue:groupid];
    [message addAttributeWithName:@"to" stringValue:jidStr];
    [message addChild:x];
    
    [xmppStream sendElement:message];
}
*/
#pragma mark - XMPP ROOM delegate

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    
}
- (void)xmppRoomDidJoin:(XMPPRoom *)sender{
    
    NSLog(@"XMPP ROOM Joined");
    
    [sender fetchConfigurationForm];
    
    xmppChatRoom = sender;
    //[self goOnline];
    //[xmppRoster addUser:[xmppChatRoom myRoomJID] withNickname:[[xmppChatRoom myRoomJID] full]];
    
    XMPPJID* jID = sender.roomJID;
    NSString* groupID = jID.user;
    
    
    NSArray* userInvites;
    if(self.groupInvitesDic)
    {
        userInvites = [self.groupInvitesDic objectForKey:groupID];
        
        if(!userInvites)
            return;
        
        for(User* user in userInvites)
        {
            NSString *jabberID = [NSString stringWithFormat:@"%ld@%@", user.identifier, PKL_XMPP_DOMAIN_NAME];
            NSString *jabberPassword = PKL_XMPP_USER_DEFAULT_PASSWORD;
            
            if (jabberID == nil || jabberPassword == nil) {
                continue;
            }
            
            NSString* fullname = [MyUtils shared].user.fullName &&  [MyUtils shared].user.fullName.length > 0 ? [MyUtils shared].user.fullName : @"someone";
            [sender inviteUser:[XMPPJID jidWithString:jabberID] withMessage:[NSString stringWithFormat:@"%@ invites you from %@", fullname, [MyUtils shared].user.country]];
        }
        
        [self.groupInvitesDic removeObjectForKey:groupID];
    }
}


- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm{
    DDLogVerbose(@"%@: %@ -> %@", THIS_FILE, THIS_METHOD, sender.roomJID.user);
    
    //to change the configuration to make the room persistent you can add something like:
    NSXMLElement *newConfig = [configForm copy];
    NSArray* fields = [newConfig elementsForName:@"field"];
    for (NSXMLElement *field in fields) {
        NSString *var = [field attributeStringValueForName:@"var"];
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
    }
    
    [sender configureRoomUsingOptions:newConfig];
    
}

#pragma mark -  XMPPMUCDelegate

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *) roomJID didReceiveInvitation:(XMPPMessage *)message {
    
    NSLog(@"RECEIVED INVITATION");
    
    
    /*NSString* messageBody = [message body];
    [self.arrPendingJid addObject:roomJID];

    UIAlertView* inviteAlert = [[UIAlertView alloc] initWithTitle:@"Invitation" message:messageBody delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
    inviteAlert.tag = kInviteSubscription;
    [inviteAlert show];*/
    
    [self createGroup:roomJID.user invites:nil];
    
    NSString* senderJid = [[message attributeForName:@"from"] stringValue];
    NSArray* components = [senderJid componentsSeparatedByString:@"/"];
    if( components && components.count > 1 )
    {
        NSString* username = [[senderJid componentsSeparatedByString:@"/"] objectAtIndex:1];
        [[MyUtils shared].user.favouriteIds addObject:username];
    }
}

- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *) roomJID didReceiveInvitationDecline:(XMPPMessage *)message {
    
}

-(void)registerToXMPPWithSuccess:(void (^)()) successHandler Failure: (void(^)()) failureHandler {
    //[MyUtils shared].user.fullName
    [APIClient registerChatUserWithId: [NSString stringWithFormat:@"%ld", [MyUtils shared].user.identifier]  Name:[NSString stringWithFormat:@"%ld", [MyUtils shared].user.identifier] Password:PKL_XMPP_USER_DEFAULT_PASSWORD Email:[MyUtils shared].user.email completionHandler:^(NSDictionary *passedResponse, NSError *error) {
        if (error) {
            /*[[[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];*/
            if (failureHandler) {
                failureHandler();
            }
            
        }
        else{
            if (successHandler) {
                successHandler();
            }
            
        }
    }];
}
@end

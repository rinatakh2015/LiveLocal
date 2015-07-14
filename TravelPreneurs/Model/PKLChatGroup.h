//
//  PKLChatGroup.h
//  pincooler
//
//  Created by CGH on 1/13/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPRoom.h"

@interface PKLChatGroup : NSObject

@property(nonatomic, strong) XMPPRoom *room;
@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *mod;
@property(nonatomic, strong) NSString *imageName;
@property(nonatomic, strong) NSString *owner;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, strong) NSDate *lastChangedDate;
@property(nonatomic, strong) NSMutableArray *unreadMessages;
@property(nonatomic, strong) NSString *lastMsgReceivedUsername;

@end

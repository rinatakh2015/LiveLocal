//
//  TPFavouriteView.h
//  TravelPreneurs
//
//  Created by CGH on 1/17/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "TPChatViewController.h"
#import "User.h"

@interface TPFavouriteView : UIView < UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate >
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* mFavouriteArray;

@property (strong, nonatomic) TPChatViewController* chatViewController;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint;

@property User* user;

@property int lastLoadedCount;
@property int lastLoadedPage;
@property int page;

-(void)initialize:(User*)user;
@end

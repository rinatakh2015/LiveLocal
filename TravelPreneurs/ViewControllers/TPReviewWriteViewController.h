//
//  TPReviewWriteViewController.h
//  TravelPreneurs
//
//  Created by CGH on 1/18/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarRatingControl.h"
#import "AsyncImageView.h"
#import "SZTextView.h"
#import "User.h"
@class TPReviewView;
@interface TPReviewWriteViewController : UIViewController<StarRatingDelegate>

@property (strong, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *mBusinessNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *mManagerNameLabel;

@property (strong, nonatomic) IBOutlet SZTextView *textView;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint2;
@property (strong, nonatomic) IBOutlet StarRatingControl *ratingControl;

@property float score;

@property User* user;
@property TPReviewView* reviewView;

-(id)initWithUser:(User*)user;
@end

//
//  TPReviewView.h
//  TravelPreneurs
//
//  Created by CGH on 1/16/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPReviewWriteViewController.h"
#import "User.h"

@interface TPReviewView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* mReviewArray;

@property (strong, nonatomic) TPReviewWriteViewController* reviewWriteViewController;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint;

@property (strong, nonatomic) IBOutlet StarRatingControl *mAverageRatingControl;
@property (strong, nonatomic) IBOutlet UILabel *mTotalReviews;
@property (strong, nonatomic) IBOutlet UILabel *mAverageRatingLabel;
@property (strong, nonatomic) IBOutlet UIButton *writeReviewButton;

@property (strong, nonatomic) IBOutlet UILabel *mFiveCountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *mFourCountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *mThreeCountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *mTwoCountsLabel;
@property (strong, nonatomic) IBOutlet UILabel *mOneCountsLabel;

@property (strong, nonatomic) IBOutlet UIImageView *mFiveBarView;
@property (strong, nonatomic) IBOutlet UIImageView *mFourBarView;
@property (strong, nonatomic) IBOutlet UIImageView *mThreeBarView;
@property (strong, nonatomic) IBOutlet UIImageView *mTwoBarView;
@property (strong, nonatomic) IBOutlet UIImageView *mOneBarView;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mFiveBarTrailingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mFourBarTrailingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mThreeBarTrailingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mTwoBarTrailingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mOneBarTrailingConstant;

@property int lastLoadedCount;
@property int lastLoadedPage;
@property int page;

-(void)initialize:(User*)user;
@end

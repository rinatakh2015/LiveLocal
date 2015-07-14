//
//  TPTravelerViewController.h
//  TravelPreneurs
//
//  Created by CGH on 1/15/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "TPLocalBusinessView.h"
#import "TPLocationView.h"
#import "TPReviewView.h"
#import "TPFavouriteView.h"
#import "TPLinksView.h"
#import "TPPhotosView.h"
#import "TPGreetingView.h"
#import "TPUserViewControllerDelegate.h"
#import "User.h"
@interface TPTravelerViewController : UIViewController<UIGestureRecognizerDelegate, TPUserViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property User* user;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *managerNameLabel;
@property (strong, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet AsyncImageView *featuredImageView;
@property (strong, nonatomic) IBOutlet UIView *swipeViewContainer;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) IBOutlet UILabel *subCategoryLabel1;
@property (strong, nonatomic) IBOutlet UILabel *subCategoryLabel2;
@property (strong, nonatomic) IBOutlet UILabel *subCategoryLabel3;
@property (strong, nonatomic) IBOutlet UIView *subCategoryDividerView1;
@property (strong, nonatomic) IBOutlet UIView *subCategoryDividerView2;


@property (strong, nonatomic) TPLocalBusinessView* localBusinessView;
@property (strong, nonatomic) TPLocationView* locationView;
@property (strong, nonatomic) TPReviewView* reviewView;
@property (strong, nonatomic) TPFavouriteView* favouriteView;
@property (strong, nonatomic) TPLinksView* linksView;
@property (strong, nonatomic) TPPhotosView* photosView;
@property (strong, nonatomic) TPGreetingView* greetingView;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *inputPanelVerticalSpacingConstraint;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarHorizentalCenterConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarSettingButtonLeadingConstraint;


//Category
@property (strong, nonatomic) IBOutlet UIView *mCategoryPanel;
@property (strong, nonatomic) IBOutlet UICollectionView *mMainCategoryCollectionView;

@property (strong, nonatomic) IBOutlet UIPickerView *mSubCategoryPickerFirst;
@property (strong, nonatomic) IBOutlet UIPickerView *mSubCategoryPickerSecond;
@property (strong, nonatomic) IBOutlet UIPickerView *mSubCategoryPickerThird;
@property (strong, nonatomic) IBOutlet UIView *mIputPanel;
@property (strong, nonatomic) IBOutlet UIView *mSubCategoryView;
@property (strong, nonatomic) IBOutlet UIView *mBottomView;

@property int selectedMainCategoryIndex;

@property(nonatomic, strong) NSArray* mMainCategoryArray;
@property(nonatomic, strong) NSArray* mSubCategoryArrayForFirst;
@property(nonatomic, strong) NSArray* mSubCategoryArrayForSecond;
@property(nonatomic, strong) NSArray* mSubCategoryArrayForThird;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mCategoryPanelTopSpacingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mInputPanelTopSpacingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mMainCategoryCollectionViewTopSpacingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mSubCategoryViewHeightConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mSubCategoryViewTopSpacingConstant;

@property BOOL isPanelMoved;

@end

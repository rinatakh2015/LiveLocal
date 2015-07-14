//
//  TPCategoryViewController.h
//  TravelPreneurs
//
//  Created by CGH on 12/16/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPCategoryViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *mMainCategoryCollectionView;

@property (strong, nonatomic) IBOutlet UIPickerView *mSubCategoryPickerFirst;
@property (strong, nonatomic) IBOutlet UIPickerView *mSubCategoryPickerSecond;
@property (strong, nonatomic) IBOutlet UIPickerView *mSubCategoryPickerThird;
@property (strong, nonatomic) IBOutlet UIImageView *mFeaturedImageView;
@property (strong, nonatomic) IBOutlet UIView *mIputPanel;
@property (strong, nonatomic) IBOutlet UIView *mSubCategoryView;

@property int selectedMainCategoryIndex;

@property(nonatomic, strong) NSArray* mMainCategoryArray;
@property(nonatomic, strong) NSArray* mSubCategoryArrayForFirst;
@property(nonatomic, strong) NSArray* mSubCategoryArrayForSecond;
@property(nonatomic, strong) NSArray* mSubCategoryArrayForThird;
@property (strong, nonatomic) IBOutlet UIView *mBottomView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mInputPanelTopSpacingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mMainCategoryCollectionViewTopSpacingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mSubCategoryViewTopSpacingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mSubCategoryViewHeightConstant;

@property BOOL isPanelMoved;
@end

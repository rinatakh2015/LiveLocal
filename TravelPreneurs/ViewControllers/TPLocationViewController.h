//
//  TPLocationViewController.h
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPLocationViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mDividerHeightConstraint1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mDividerHeightConstraint2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mDividerHeightConstraint3;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mBottomViewBottomSpaceConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mInputPanelTopSpaceConstant;

@property (strong, nonatomic) IBOutlet UIImageView *mFeaturedImageView;
@property (strong, nonatomic) IBOutlet UIView *mInputPanel;
@property (strong, nonatomic) IBOutlet UIView *mBottomView;
@property (strong, nonatomic) IBOutlet UIView *mInputContainer;

@property    BOOL isPanelMoved;

@end

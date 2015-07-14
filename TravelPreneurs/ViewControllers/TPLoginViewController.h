//
//  TPLoginViewController.h
//  TravelPreneurs
//
//  Created by CGH on 1/15/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPLoginViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mDividerHeightConstraint1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mDividerHeightConstraint2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mDividerHeightConstraint3;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mBottomViewBottomSpaceConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mInputPanelTopSpaceConstant;

@property (strong, nonatomic) IBOutlet UIButton *mSignupButton;
@property (strong, nonatomic) IBOutlet UIImageView *mFeaturedImageView;
@property (strong, nonatomic) IBOutlet UIView *mInputPanel;
@property (strong, nonatomic) IBOutlet UIView *mBottomView;
@property (strong, nonatomic) IBOutlet UIView *mInputContainer;

@property (strong, nonatomic) IBOutlet UITextField *mUserNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *mPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *mTermsButton;
@property (strong, nonatomic) IBOutlet UIButton *mPrivacyButton;

@property    BOOL isPanelMoved;

@end

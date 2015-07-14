//
//  TPLinksView.h
//  TravelPreneurs
//
//  Created by CGH on 1/17/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface TPLinksView : UIView<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthDividerCenterYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightDividerCenterYConstraint;
@property (strong, nonatomic) User* user;
-(void) initialize:(User*)user;
@end

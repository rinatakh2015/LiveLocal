//
//  TPGreetingView.h
//  TravelPreneurs
//
//  Created by CGH on 1/16/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPHelloViewController.h"
#import "SZTextView.h"
#import "User.h"
@interface TPGreetingView : UIView
@property (strong, nonatomic) IBOutlet SZTextView *messageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint;
@property (strong, nonatomic) TPHelloViewController* helloViewController;
@property (strong, nonatomic) IBOutlet UIButton *writeGreetingButton;

@property User* user;
- (IBAction)onClickEdit:(id)sender;

-(void)initialize:(User*)user;

@end

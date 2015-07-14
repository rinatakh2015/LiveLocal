//
//  TPHelloViewController.h
//  TravelPreneurs
//
//  Created by CGH on 1/20/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"
#import "User.h"

@class TPGreetingView;
@interface TPHelloViewController : UIViewController
@property (strong, nonatomic) IBOutlet SZTextView *textView;
@property (strong, nonatomic) TPGreetingView* greetingView;

@end

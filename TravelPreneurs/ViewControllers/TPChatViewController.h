//
//  TPChatViewController.h
//  TravelPreneurs
//
//  Created by CGH on 1/18/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "PKLChatGroup.h"
#import "User.h"

@interface TPChatViewController : UIViewController
{
    NSMutableArray	*messages;
    NSString *receiver;
    
    UIImagePickerController *mediaPicker;
    UIViewController *viewCamera;
    
}


@property (strong, nonatomic) IBOutlet UITextView *messageField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mMessageContainerHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mMessageContainerBottomVerticalSpace;

@property (strong, nonatomic) PKLChatGroup* pklChatGroup;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomLineSeparatorHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet AsyncImageView *userAvatarImageView;
@property (strong, nonatomic) IBOutlet AsyncImageView *myAvatarImageView;
@property (strong, nonatomic) User* user;

-(id)initWithUser:(User*)user;
-(void) initialize;
@end

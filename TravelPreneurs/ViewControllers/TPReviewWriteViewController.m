//
//  TPReviewWriteViewController.m
//  TravelPreneurs
//
//  Created by CGH on 1/18/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPReviewWriteViewController.h"
#import "MyUtils.h"
#import "MBProgressHUD.h"
#import "APIClient.h"
#import "global_functions.h"
#import "TPReviewView.h"

@interface TPReviewWriteViewController ()

@end

@implementation TPReviewWriteViewController

-(id)initWithUser:(User*)user{
    self  = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.placeholder = [[MyUtils shared ] translateWith: @"Write review"];
    self.lineSeparatorHeightConstraint1.constant = 0.5;
    self.lineSeparatorHeightConstraint2.constant = 0.5;
    
    [[MyUtils shared] makeCircleViewWithBorder:self.avatarImageView BorderWidth:1 BorderColor:[UIColor blackColor]];
    self.ratingControl.editable = YES;
    
    if (self.user) {
        if (self.user.avatarImageURL) {
            [self.avatarImageView loadImageFromURL:[NSURL URLWithString:self.user.avatarImageURL]];
        }
        else
            [self.avatarImageView setImage:[UIImage imageNamed:@"icon_defaultavatar.png"]];
        
        if (self.user.businessName) {
            self.mBusinessNameLabel.text = self.user.businessName;
        }
        else
            self.mBusinessNameLabel.text = @"";

        if (self.user.managerName) {
            self.mManagerNameLabel.text = self.user.managerName;
        }
        else
            self.mManagerNameLabel.text = @"";
    }

    [[MyUtils shared] applyTranslation:self.view];
}

-(BOOL) isForMe
{
    return self.user.identifier == [MyUtils shared].user.identifier;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickDone:(id)sender {
    
    if (self.textView.text.length == 0) {
        return;
    }
    if (self.textView.text.length >= 1000) {
        ShowErrorAlert(@"Review message can not be exceeded 1000 characters.");
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APIClient writeUserReview:self.user.identifier Rating:self.ratingControl.rating Text:self.textView.text completionHandler:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
                [nav popViewControllerAnimated:YES];
            });
            
        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }
    }];
    
}
- (IBAction)onClickCancel:(id)sender {
    UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    [nav popViewControllerAnimated:YES];
}


- (void)starRatingControl:(StarRatingControl *)control didUpdateRating:(NSUInteger)rating {
}

- (void)starRatingControl:(StarRatingControl *)control willUpdateRating:(NSUInteger)rating {

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

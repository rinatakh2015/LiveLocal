//
//  TPGreetingView.m
//  TravelPreneurs
//
//  Created by CGH on 1/16/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPGreetingView.h"
#import "MyUtils.h"
#import "global_functions.h"
#import "APIClient.h"
#import "MBProgressHUD.h"
#import "defs.h"

@implementation TPGreetingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initialize:(User*)user
{
    self.user = user;
    self.lineSeparatorHeightConstraint.constant = 0.5;
    self.messageView.placeholder = @"Message";
    
    if (self.user.identifier == [MyUtils shared].user.identifier) {
        [self.writeGreetingButton setHidden:NO];
    }
    else
        self.writeGreetingButton.hidden = YES;
    
    [[MyUtils shared] applyTranslation:self];
    
    [self loadData];
}

-(void)loadData
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [APIClient getGreetingWords:self.user.identifier completionHandler:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:NO];
        if (!error) {
            self.messageView.text = ([passedResponse count] && [passedResponse objectForKey:kText]) ? [passedResponse objectForKey:kText] : @"";
        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }

    }];

}
- (IBAction)onClickEdit:(id)sender {
    self.helloViewController = [[TPHelloViewController alloc] init];
    self.helloViewController.greetingView  = self;
    UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    [nav pushViewController:self.helloViewController animated:YES];
}
@end

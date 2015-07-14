//
//  TPLinksView.m
//  TravelPreneurs
//
//  Created by CGH on 1/17/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPLinksView.h"
#import "defs.h"
#import "AppDelegate.h"
#import "MyUtils.h"

@implementation TPLinksView

-(void) initialize:(User*)user{
    self.user = user;
    self.lineSeparatorHeightConstraint.constant = 0.5;
    
    //[self sampleData];
    [[MyUtils shared] applyTranslation:self];
}

-(void) sampleData
{
    self.user = [User userFromDic:@{kUserId : @(1), kUserName: @"Tester1", kFacebook:@"http://facebook.com", kEmail:@"datong_song@hotmail.com", kLinkedin:@"http://linkedin.com", kWebsite:@"http://bing.com"}];
}
- (IBAction)onEmailClick:(id)sender {
    if (self.user && self.user.email) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[self.user.email]];
        [controller setSubject:@""];
        [controller setMessageBody:@"" isHTML:NO];
        if (controller)
        {
            UINavigationController* nav = (UINavigationController*)[AppDelegateAccessor window].rootViewController;
            [nav presentViewController:controller animated:YES completion:nil];
        }
    }
}
- (IBAction)onWebsiteClick:(id)sender {
    if (self.user && self.user.website) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.user.website]];
    }
}
- (IBAction)onLinkedinClick:(id)sender {
    if (self.user && self.user.linkedin) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.user.linkedin]];
    }
}
- (IBAction)onFacebookClick:(id)sender {
    if (self.user && self.user.facebook) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.user.facebook]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    UINavigationController* nav = (UINavigationController*)[AppDelegateAccessor window].rootViewController;
    [nav dismissModalViewControllerAnimated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

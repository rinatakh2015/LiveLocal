//
//  TPLoginViewController.m
//  TravelPreneurs
//
//  Created by CGH on 1/15/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPLoginViewController.h"
#import "AppDelegate.h"
#import "Preferences.h"
#import "MyUtils.h"
#import "MBProgressHUD.h"
#import "global_functions.h"
#import "APIClient.h"
#import "AppDelegate.h"
#import "MyEnums.h"
#import "TPTravelerViewController.h"
#import "TPSetupViewController.h"
#import "NSString+Translate.h"
@interface TPLoginViewController ()


@end

@implementation TPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mDividerHeightConstraint1 setConstant:0.5];
    [_mDividerHeightConstraint2 setConstant:0.5];
    [_mDividerHeightConstraint3 setConstant:0.5];
    [self.mTermsButton setTitle:[@"Terms Of Use" translate] forState:UIControlStateNormal];
    [self.mPrivacyButton setTitle:[@"Privacy Policy" translate] forState:UIControlStateNormal];
    
    //set notification for when keyboard shows/hides
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    singleTapGestureRecognizer.delegate = self;
    singleTapGestureRecognizer.numberOfTapsRequired =1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    if ([Preferences sharedInstance].userName != nil) {
        
        NSString* userName = [Preferences sharedInstance].userName;
        NSString* password = [Preferences sharedInstance].password;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [APIClient loginWithUserName:userName Password:password DeviceToken:AppDelegateAccessor.dToken completionHandler:^(NSDictionary *passedResponse, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            if (error == nil) {
 
                [self.mUserNameTextField setText:@""];
                [self.mPasswordTextField setText:@""];
                [AppDelegateAccessor.locationManager startMonitoringSignificantLocationChanges];
                [AppDelegateAccessor connect];
                [self performSegueWithIdentifier:@"ViewTravelUser" sender:self];
                
            }
            else{
                ShowErrorAlert([error localizedDescription]);
                [self.mUserNameTextField setText:userName];
                [self.mPasswordTextField setText:password];
            }

        }];
        
    }
    
    [[MyUtils shared] applyTranslation:self.view];
}
CGSize keyboardSize;
//keyboard
-(void) keyboardWillShow:(NSNotification *)note{
    
    // Step 1: Get the size of the keyboard.
    keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [self movePanel:YES];
}

-(void) keyboardWillHide:(NSNotification *)note{
    [self moveBackPanel:YES Completion:nil];

}


-(void) movePanel:(BOOL) isAnimated
{
    if (_isPanelMoved) {
        return;
    }
    [self.view layoutIfNeeded];
    
    if (isAnimated) {
        self.mBottomViewBottomSpaceConstant.constant = keyboardSize.height;
        self.mInputPanelTopSpaceConstant.constant = -self.mFeaturedImageView.frame.size.height;//-keyboardSize.height;
        
        _isPanelMoved = YES;
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];

        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        
        self.mBottomViewBottomSpaceConstant.constant = -keyboardSize.height;
        self.mInputPanelTopSpaceConstant.constant = -keyboardSize.height;
        
        _isPanelMoved = YES;
        [self.view layoutIfNeeded];
    }
    
}

-(void) moveBackPanel:(BOOL) isAnimated Completion:(void(^)())completion
{
    if (!_isPanelMoved) {
        return;
    }
    
    
    if (isAnimated) {
        self.mBottomViewBottomSpaceConstant.constant = 0;
        self.mInputPanelTopSpaceConstant.constant = 0;

        _isPanelMoved = NO;
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if(finished && completion)
                completion();
        }];
    }
    else{
        self.mBottomViewBottomSpaceConstant.constant = 0;
        self.mInputPanelTopSpaceConstant.constant = 0;
        
        _isPanelMoved = NO;
        [self.view layoutIfNeeded];
        if(completion)
            completion();
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return false;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view==self.view ) {
        return YES;
    }
    else if (touch.view == self.mInputContainer || touch.view == self.mInputPanel || touch.view == self.mBottomView)
    {
        return YES;
    }
    return NO;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
}



- (IBAction)onOk:(id)sender {

    if (self.isPanelMoved) {
        [self moveBackPanel:YES Completion:^{
            [self login];
        }];
        [self.view endEditing:YES];
    }
    else
    {
        [self login];
    }

}

-(void)login
{
    NSString* userName = self.mUserNameTextField.text;
    NSString* password = self.mPasswordTextField.text;
    
    if([userName isEqualToString:@""] || [password isEqualToString:@""])
    {
        ShowErrorAlert(@"Please input correct user name and password!");
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APIClient loginWithUserName:userName Password:password DeviceToken:AppDelegateAccessor.dToken completionHandler:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if (error == nil) {
            
            [self.mUserNameTextField setText:@""];
            [self.mPasswordTextField setText:@""];
            [AppDelegateAccessor.locationManager startMonitoringSignificantLocationChanges];
            [AppDelegateAccessor connect];
            [self performSegueWithIdentifier:@"ViewTravelUser" sender:self];

        }
        else{
            ShowErrorAlert([error localizedDescription]);
            [self.mUserNameTextField setText:userName];
            [self.mPasswordTextField setText:password];
        }
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)unwindSegue
{
}
- (IBAction)onClickForgotPassword:(id)sender {
    if(self.mUserNameTextField.text.length == 0)
    {
        ShowErrorAlert(@"Please enter your user name");
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APIClient changePassword:self.mUserNameTextField.text Completion:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if(error == nil)
        {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Email was sent to your email address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        else{
            ShowErrorAlert(error.localizedDescription);
        }
    }];
}
- (IBAction)onClickTerms:(id)sender {
    NSURL* url = [NSURL URLWithString:@"http://livelocaltravel.com/about/terms-of-use/"];
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
   
}

- (IBAction)onClickPrivacy:(id)sender {
    NSURL* url = [NSURL URLWithString:@"http://livelocaltravel.com/about/privacy-policy/"];
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewTravelUser"]) {
        TPTravelerViewController* travelerViewController = (TPTravelerViewController*)segue.destinationViewController;
        travelerViewController.user = [MyUtils shared].user;
    }

}


@end

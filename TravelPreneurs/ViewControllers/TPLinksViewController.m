//
//  TPLinksViewController.m
//  TravelPreneurs
//
//  Created by CGH on 12/16/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "TPLinksViewController.h"
#import "MyUtils.h"

@interface TPLinksViewController ()
@property (strong, nonatomic) IBOutlet UITextField *mFacebookTextField;
@property (strong, nonatomic) IBOutlet UITextField *mLinkedinTextField;
@property (strong, nonatomic) IBOutlet UITextField *mWebsiteTextField;

@end

@implementation TPLinksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mDividerHeightConstraint1 setConstant:0.5];
    [_mDividerHeightConstraint2 setConstant:0.5];
    [_mDividerHeightConstraint3 setConstant:0.5];
    
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
    
    if ([MyUtils shared].tempUser.facebook) {
        self.mFacebookTextField.text = [MyUtils shared].tempUser.facebook;
    }
    
    if ([MyUtils shared].tempUser.linkedin) {
        self.mLinkedinTextField.text = [MyUtils shared].tempUser.linkedin;
    }
    
    if ([MyUtils shared].tempUser.website) {
        self.mWebsiteTextField.text = [MyUtils shared].tempUser.website;
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
            [self.mInputPanel  layoutIfNeeded];
            [self.mBottomView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        
        self.mBottomViewBottomSpaceConstant.constant = -keyboardSize.height;
        self.mInputPanelTopSpaceConstant.constant = -keyboardSize.height;
        
        
        _isPanelMoved = YES;
        [self.mInputPanel  layoutIfNeeded];
        [self.mBottomView layoutIfNeeded];
        
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
            [self.mInputPanel  layoutIfNeeded];
            [self.mBottomView layoutIfNeeded];
        } completion:^(BOOL finished) {
            if(finished && completion)
                completion();
        }];
    }
    else{
        self.mBottomViewBottomSpaceConstant.constant = 0;
        self.mInputPanelTopSpaceConstant.constant = 0;
        
        
        _isPanelMoved = NO;
        [self.mInputPanel  layoutIfNeeded];
        [self.mBottomView layoutIfNeeded];
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
    
    if (self.mFacebookTextField.text.length > 0) {
        [MyUtils shared].tempUser.facebook = self.mFacebookTextField.text;
    }
    
    if (self.mLinkedinTextField.text.length > 0) {
        [MyUtils shared].tempUser.linkedin = self.mLinkedinTextField.text;
    }
    
    if (self.mWebsiteTextField.text.length > 0) {
        [MyUtils shared].tempUser.website = self.mWebsiteTextField.text;
    }
    
    if (self.isPanelMoved) {
        [self moveBackPanel:YES Completion:^{
            [self performSegueWithIdentifier:@"ViewCategory" sender:self];
        }];
        [self.view endEditing:YES];
    }
    else
        [self performSegueWithIdentifier:@"ViewCategory" sender:self];
}

- (IBAction)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)unwindToLinks:(UIStoryboardSegue *)unwindSegue
{
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

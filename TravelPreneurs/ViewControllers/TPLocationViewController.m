//
//  TPLocationViewController.m
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "TPLocationViewController.h"
#import "MyUtils.h"
#import "global_functions.h"
#import "NSString+Translate.h"

@interface TPLocationViewController ()
@property (strong, nonatomic) IBOutlet UITextField *mAddress1TextField;
@property (strong, nonatomic) IBOutlet UITextField *mAddress2TextField;
@property (strong, nonatomic) IBOutlet UITextField *mCityTextField;
@property (strong, nonatomic) IBOutlet UITextField *mStateTextField;
@property (strong, nonatomic) IBOutlet UITextField *mPostalCodeTextField;
@end

@implementation TPLocationViewController


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
    
    [self.mAddress1TextField setPlaceholder:[NSString stringWithFormat:@"%@ 1", [@"Address" translate]]];
    [self.mAddress2TextField setPlaceholder:[NSString stringWithFormat:@"%@ 2", [@"Address" translate]]];
    [self.mCityTextField setPlaceholder:@"City"];
    [self.mStateTextField setPlaceholder:@"State"];
    [self.mPostalCodeTextField setPlaceholder:@"Post Code"];
    
    if ([MyUtils shared].tempUser.address1) {
        [self.mAddress1TextField setText:[MyUtils shared].tempUser.address1];
    }
    
    if([MyUtils shared].tempUser.address2)
    {
        [self.mAddress2TextField setText:[MyUtils shared].tempUser.address2];
    }
    
    if ([MyUtils shared].tempUser.city) {
        [self.mCityTextField setText:[MyUtils shared].tempUser.city];
    }
    
    if ([MyUtils shared].tempUser.state) {
        [self.mStateTextField setText:[MyUtils shared].tempUser.state];
    }
    
    if ([MyUtils shared].tempUser.postalCode) {
        [self.mPostalCodeTextField setText:[MyUtils shared].tempUser.postalCode];
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
    if (self.mAddress1TextField.text.length == 0 ) {
        
        return;
    }
    
    [MyUtils shared].tempUser.address1 = self.mAddress1TextField.text;
    [MyUtils shared].tempUser.address2 = self.mAddress2TextField.text;
    [MyUtils shared].tempUser.city = self.mCityTextField.text;
    [MyUtils shared].tempUser.state = self.mStateTextField.text;
    [MyUtils shared].tempUser.postalCode = self.mPostalCodeTextField.text;
    
    if (self.isPanelMoved) {
        [self moveBackPanel:YES Completion:^{
            [self performSegueWithIdentifier:@"ViewLinks" sender:self];
        }];
        [self.view endEditing:YES];
    }
    else
        [self performSegueWithIdentifier:@"ViewLinks" sender:self];
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

- (IBAction)unwindToLocation:(UIStoryboardSegue *)unwindSegue
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

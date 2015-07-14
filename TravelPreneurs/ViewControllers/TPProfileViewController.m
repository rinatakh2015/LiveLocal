//
//  TPProfileViewController.m
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "TPProfileViewController.h"
#import "MyUtils.h"
#import "NSString+Translate.h"

@interface TPProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextField *mBusinessNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *mManagerNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *mEmailTextField;

@end

@implementation TPProfileViewController

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
    
    if ([MyUtils shared].tempUser.accountType == TPAccountType_TRAVELER) {

        self.businessIconImageView.hidden = YES;
        self.mBusinessNameTextField.hidden = YES;
        self.mFirstUnderLine.hidden = YES;
        self.mManagerIconTopSpacingConstant.constant = 37;
        
        self.mManagerNameTextField.placeholder = @"Personal Name";
        if ([MyUtils shared].tempUser.fullName ) {
            [self.mManagerNameTextField setText:[MyUtils shared].tempUser.fullName];
        }

    }
    else{
        if ([MyUtils shared].tempUser.accountType == TPAccountType_REGISTERED_BUSINESS) {
            [self.businessIconImageView setImage:[UIImage imageNamed:@"icon_registered_business"]];
        }
        else{
            [self.businessIconImageView setImage:[UIImage imageNamed:@"icon_mobile_business"]];
        }
        self.businessIconImageView.hidden = NO;
        self.mBusinessNameTextField.hidden = NO;
        self.mFirstUnderLine.hidden = NO;
        self.mManagerIconTopSpacingConstant.constant = 0;
        
        self.mManagerNameTextField.placeholder = @"Manager Name";
        
        if ([MyUtils shared].tempUser.businessName ) {
            [self.mBusinessNameTextField setText:[MyUtils shared].tempUser.businessName];
        }
        if ([MyUtils shared].tempUser.managerName ) {
            [self.mManagerNameTextField setText:[MyUtils shared].tempUser.managerName];
        }
    }

    
    if ([MyUtils shared].tempUser.email ) {
        [self.mEmailTextField setText:[MyUtils shared].tempUser.email];
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

    if ([MyUtils shared].tempUser.accountType == TPAccountType_TRAVELER) {
        if ([self.mManagerNameTextField text].length == 0 || [self.mEmailTextField text].length == 0) {
            return;
        }
        [MyUtils shared].tempUser.businessName = nil;
        [MyUtils shared].tempUser.managerName = nil;
        [MyUtils shared].tempUser.fullName = self.mManagerNameTextField.text;
        [MyUtils shared].tempUser.email = [self.mEmailTextField text];

    }
    else{
        if ([self.mBusinessNameTextField text].length == 0 || [self.mManagerNameTextField text].length == 0 || [self.mEmailTextField text].length == 0) {
            return;
        }
        [MyUtils shared].tempUser.businessName = [self.mBusinessNameTextField text];
        [MyUtils shared].tempUser.managerName = [self.mManagerNameTextField text];
        [MyUtils shared].tempUser.email = [self.mEmailTextField text];
    }
    
    if (self.isPanelMoved) {
        [self moveBackPanel:YES Completion:^{
            [self gotoNextPage];
        }];
        [self.view endEditing:YES];
    }
    else
        [self gotoNextPage];
    
}
-(void) gotoNextPage
{
    if ([MyUtils shared].tempUser.accountType == TPAccountType_TRAVELER) {
        [self performSegueWithIdentifier:@"ViewSecurity" sender:self];
        return;
    }
    else if([MyUtils shared].tempUser.accountType == TPAccountType_MOBILE_BUSINESS)
    {
        [self performSegueWithIdentifier:@"ViewLinks" sender:self];
        return;
    }
    [self performSegueWithIdentifier:@"ViewLocation" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];    
}

- (IBAction)unwindToProfile:(UIStoryboardSegue *)unwindSegue
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

//
//  TPAccountViewController.m
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "TPAccountViewController.h"
#import "MyUtils.h"

@interface TPAccountViewController ()

@end

@implementation TPAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mAccountTypePicker selectRow:[MyUtils shared].tempUser.accountType inComponent:0 animated:NO];
    
    [[MyUtils shared] applyTranslation:self.view];    
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

- (IBAction)unwindToAccount:(UIStoryboardSegue *)unwindSegue
{
}

- (void)accountPicker:(AccountTypePicker *)picker Type:(int)type
{
    [MyUtils shared].tempUser.accountType = type;
}

- (IBAction)onOk:(id)sender {
    [MyUtils shared].tempUser.accountType = [self.mAccountTypePicker selectedRowInComponent:0];
    [self performSegueWithIdentifier:@"ViewProfile" sender:self];
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

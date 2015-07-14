//
//  TPCountryViewController.m
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "TPCountryViewController.h"
#import "MyUtils.h"

@interface TPCountryViewController ()

@end

@implementation TPCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mCountryPicker.delegate = self;
    if(![MyUtils shared].tempUser.country || [MyUtils shared].tempUser.country.length == 0)
        [self.mCountryPicker setSelectedCountryCode:@"US"];
    else
        [self.mCountryPicker setSelectedCountryName:[MyUtils shared].tempUser.country];
    
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

- (IBAction)unwindToCountry:(UIStoryboardSegue *)unwindSegue
{
}

- (void)countryPicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code
{
    [MyUtils shared].tempUser.country = name;
}

- (IBAction)onOk:(id)sender {
    [MyUtils shared].tempUser.country = self.mCountryPicker.selectedCountryName;
    [self performSegueWithIdentifier:@"ViewAccount" sender:self];    
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

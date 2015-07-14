//
//  TPSetupViewController.m
//  TravelPreneurs
//
//  Created by CGH on 12/14/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "TPSetupViewController.h"
#import "MyUtils.h"

@interface TPSetupViewController ()


@end

@implementation TPSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mNativeLanguagePicker.languagePickerDelegate = self;
    if (![self.mNativeLanguagePicker selectLanguage:[MyUtils shared].tempUser.nativeLanguage]) {
        [self.mNativeLanguagePicker selectLanguage:@"English"];
    }
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

- (IBAction)unwindToSetup:(UIStoryboardSegue *)unwindSegue
{
}

- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onOk:(id)sender {
    [self setLanguage];    
    [self performSegueWithIdentifier:@"ViewLanguages" sender:self];
}

-(void)setLanguage{
    [MyUtils shared].tempUser.nativeLanguage = [self.mNativeLanguagePicker standardLangaugeOfSelectedRow];
    [[MyUtils shared] setTranslationLanguage: [self.mNativeLanguagePicker standardLangaugeOfSelectedRow]];
}

#pragma mark - LanguagePickerView Delegate
- (void)languagePicker:(LanguagePickerView *)picker didSelectLanguageWithName:(NSString *)name Index:(int)index
{
    [self setLanguage];
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

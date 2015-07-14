//
//  TPSpokenLanguageViewController.m
//  TravelPreneurs
//
//  Created by CGH on 12/15/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "TPSpokenLanguageViewController.h"
#import "MyUtils.h"

@interface TPSpokenLanguageViewController ()

@end

@implementation TPSpokenLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mSpokenLanguagePicker1.languagePickerDelegate = self;
    self.mSpokenLanguagePicker2.languagePickerDelegate = self;
    self.mSpokenLanguagePicker3.languagePickerDelegate = self;

    self.mSpokenLanguagePicker1.isShort = YES;
    self.mSpokenLanguagePicker2.isShort = YES;
    self.mSpokenLanguagePicker3.isShort = YES;
    
    [self.mSpokenLanguagePicker1 setUp];
    [self.mSpokenLanguagePicker2 setUp];
    [self.mSpokenLanguagePicker3 setUp];
    
    self.mSpokenLanguagePicker2.hasPlaceHolder = YES;
    self.mSpokenLanguagePicker3.hasPlaceHolder = YES;
    

    

    if (![MyUtils shared].tempUser.spokenLanguages) {
        [self.mSpokenLanguagePicker1 selectRow:0 inComponent:0 animated:NO];
        [self.mSpokenLanguagePicker2 selectRow:0 inComponent:0 animated:NO];
        [self.mSpokenLanguagePicker3 selectRow:0 inComponent:0 animated:NO];
    }
    else{
        if (![self.mSpokenLanguagePicker1 selectLanguage:[[MyUtils shared].tempUser.spokenLanguages objectAtIndex:0]]) {
            [self.mSpokenLanguagePicker1 selectRow:0 inComponent:0 animated:NO];
        }
        if (![self.mSpokenLanguagePicker2 selectLanguage:[[MyUtils shared].tempUser.spokenLanguages objectAtIndex:1]]) {
            [self.mSpokenLanguagePicker2 selectRow:0 inComponent:0 animated:NO];
        }
        if (![self.mSpokenLanguagePicker3 selectLanguage:[[MyUtils shared].tempUser.spokenLanguages objectAtIndex:2]]) {
            [self.mSpokenLanguagePicker3 selectRow:0 inComponent:0 animated:NO];
        }
        
    }
    
    [[MyUtils shared] applyTranslation:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)unwindToSpokenLanguage:(UIStoryboardSegue *)unwindSegue
{
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void) setLanguages{
    NSString* language1 = [self.mSpokenLanguagePicker1 standardLangaugeOfSelectedRow];
    NSString* language2 = [self.mSpokenLanguagePicker2 standardLangaugeOfSelectedRow];
    NSString* language3 = [self.mSpokenLanguagePicker3 standardLangaugeOfSelectedRow];
    
    [MyUtils shared].tempUser.spokenLanguages = @[language1, language2, language3];
}
#pragma mark - LanguagePickerView Delegate
- (void)languagePicker:(LanguagePickerView *)picker didSelectLanguageWithName:(NSString *)name Index:(int)index
{
    [self setLanguages];
}

- (IBAction)onOk:(id)sender {
    
    [self setLanguages];
    [self performSegueWithIdentifier:@"ViewCountry" sender:self];
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

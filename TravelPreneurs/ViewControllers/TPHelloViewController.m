//
//  TPHelloViewController.m
//  TravelPreneurs
//
//  Created by CGH on 1/20/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPHelloViewController.h"
#import "MyUtils.h"
#import "MBProgressHUD.h"
#import "global_functions.h"
#import "APIClient.h"
#import "defs.h"
#import "TPGreetingView.h"

@interface TPHelloViewController ()

@end

@implementation TPHelloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.placeholder = [[MyUtils shared] translateWith:@"Message"];
    [[MyUtils shared] applyTranslation:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickSave:(id)sender {
    
    if (self.textView.text.length == 0) {
        return;
    }
    
    if (self.textView.text.length >= 1000) {
        ShowErrorAlert(@"Hello message can not be exceeded 1000 characters.");
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APIClient writeGreetingWords:self.textView.text Completion:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
                [nav popViewControllerAnimated:YES];
                
            });
            
        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }
    }];
}

- (IBAction)onClickCancel:(id)sender {
    UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    [nav popViewControllerAnimated:YES];
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

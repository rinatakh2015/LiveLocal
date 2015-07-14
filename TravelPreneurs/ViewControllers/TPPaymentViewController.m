//
//  TPPaymentViewController.m
//  TravelPreneurs
//
//  Created by CGH on 2/23/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPPaymentViewController.h"
#import "MyUtils.h"
#import "defs.h"
#import "APIClient.h"
#import "MBProgressHUD.h"
#import "NSString+Translate.h"
#import "global_functions.h"

#define REPLACE_CARD_ALERT 1000
@interface TPPaymentViewController ()
{
    NSDictionary* cardInfo;
    IBOutlet UILabel *bankCardLabel;
    IBOutlet UILabel *descriptionLabel;
}
@end

@implementation TPPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    cardInfo = [MyUtils shared].tempUser.creditCardInfo;
    
    [[MyUtils shared] applyTranslation:self.view];
    bankCardLabel.text = [NSString stringWithFormat:@"+ %@", [@"Bank Card" translate]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CardIOUtilities preload];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onAddCard:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:scanViewController animated:YES completion:nil];

}


- (IBAction)onOk:(id)sender {
    if ([MyUtils shared].tempUser.registeredCard && cardInfo) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You already have a card registered. Are you going to change it?", nil) message:@"" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alertView.tag = REPLACE_CARD_ALERT;
        [alertView show];
    }
    else
    {
        [self checkCard];
    }
}

-(void)checkCard
{
    [MyUtils shared].tempUser.creditCardInfo = cardInfo;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APIClient checkCardWithUser:[MyUtils shared].tempUser Completion:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if (error) {
            ShowErrorAlert(error.localizedDescription);
        }
        else{
            [MyUtils shared].tempUser.creditCardInfo = cardInfo;
            [self performSegueWithIdentifier:@"ViewAddPhoto" sender:self];
        }
    }];
}
- (IBAction)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == REPLACE_CARD_ALERT) {
        if ( buttonIndex == 0 ) {
            [self checkCard];
            return;
        }
    }
    
    [self performSegueWithIdentifier:@"ViewAddPhoto" sender:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - CardIO delegate
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    
    cardInfo = @{kCardNumber: info.cardNumber, kExpiryMonth: @(info.expiryMonth), kExpiryYear: @(info.expiryYear), kCvv:info.cvv };
    
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}
@end

//
//  TPAddPhotoViewController.m
//  TravelPreneurs
//
//  Created by CGH on 1/15/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPAddPhotoViewController.h"
#import "MyUtils.h"
#import "defs.h"
#import "global_functions.h"
#import "MBProgressHUD.h"
#import "APIClient.h"
#import "TPTravelerViewController.h"
#import "AppDelegate.h"
#import "NSString+Translate.h"

@interface TPAddPhotoViewController ()
{
    int photo_type; // 0: Avatar Image; 1: Background Image;
}
@property (strong, nonatomic) IBOutlet UILabel *backgroundLabel;
@property (strong, nonatomic) IBOutlet UILabel *portraitLabel;
@end

@implementation TPAddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.portraitLabel.text = [NSString stringWithFormat:@"+ %@", [@"Portrait" translate]];
    self.backgroundLabel.text = [NSString stringWithFormat:@"+ %@", [@"Background" translate]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.avatarImageView layoutIfNeeded];
    
    
    if ([MyUtils shared].tempUser.accountType == TPAccountType_TRAVELER) {

       [self.avatarImageView setImage:[UIImage imageNamed:@"icon_avatarbg.png"]];
        if ([MyUtils shared].tempUser.avatarImageURL) {
            [self.avatarImageView loadImageFromURL:[NSURL URLWithString:[MyUtils shared].tempUser.avatarImageURL]];
        }

        [self.featuredImageView setImage:[UIImage imageNamed:@"featured_user.png"]];
        if ([MyUtils shared].tempUser.backgroundImageURL) {
            [self.featuredImageView loadImageFromURL:[NSURL URLWithString:[MyUtils shared].tempUser.backgroundImageURL]];
        }
        
        [self.titleLabel setText:[MyUtils shared].tempUser.fullName];
        self.managerNameLabel.hidden = YES;
        self.subCategoryLabel1.hidden = YES;
        self.subCategoryLabel2.hidden = YES;
        self.subCategoryLabel3.hidden = YES;
        self.subCategoryDividerView1.hidden = YES;
        self.subCategoryDividerView2.hidden = YES;
        
        self.avatarHorizentalCenterConstant.constant = 0;
        self.avatarTopConstraint.constant = -71;
        self.avatarWidthConstraint.constant = 190;
    }
    else{
        [self.avatarImageView setImage:[UIImage imageNamed:@"icon_avatarbg_business"]];
        if ([MyUtils shared].tempUser.avatarImageURL) {
            [self.avatarImageView loadImageFromURL:[NSURL URLWithString:[MyUtils shared].tempUser.avatarImageURL]];
        }
 
        [self.featuredImageView setImage:[UIImage imageNamed:@"featured_business.png"]];
        if ([MyUtils shared].tempUser.backgroundImageURL) {
            [self.featuredImageView loadImageFromURL:[NSURL URLWithString:[MyUtils shared].tempUser.backgroundImageURL]];
        }
        
        [self.titleLabel setText:[MyUtils shared].tempUser.businessName];
        [self.managerNameLabel setText:[MyUtils shared].tempUser.managerName];
        
        self.managerNameLabel.hidden = NO;
        self.subCategoryLabel1.hidden = NO;
        self.subCategoryLabel2.hidden = NO;
        self.subCategoryLabel3.hidden = NO;
        self.subCategoryDividerView1.hidden = NO;
        self.subCategoryDividerView2.hidden = NO;
        
        self.avatarHorizentalCenterConstant.constant = 60;
        self.avatarTopConstraint.constant = -67;
        self.avatarWidthConstraint.constant = 158;
        
        self.subCategoryLabel1.text = [MyUtils shared].tempUser.firstSubCategoryText;
        self.subCategoryLabel2.text = [MyUtils shared].tempUser.secondSubCategoryText;
        self.subCategoryLabel3.text = [MyUtils shared].tempUser.thirdSubCategoryText;
    }
    
 
    
    [[MyUtils shared] applyTranslation:self.view];
   
    [self.avatarImageView layoutIfNeeded];
    
    [[MyUtils shared] makeCircleViewWithBorder:self.avatarImageView BorderWidth:MAIN_AVATAR_BORDER_WIDTH * self.avatarImageView.frame.size.width / 179.0 BorderColor:MAIN_AVATAR_BORDER_COLOR];
    
}

-(void)viewDidAppear:(BOOL)animated
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onOk:(id)sender {
    if ([MyUtils shared].tempUser.identifier > 0 ) {
        [self updateProfile];
        return;
    }
    [self signUp];
}

-(void)signUp
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [APIClient signUpWithUser:[MyUtils shared].tempUser Completion:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (error == nil) {
            
            if ([MyUtils shared].user.blocked || ![MyUtils shared].user.verified) {
                [self performSegueWithIdentifier:@"BackToLogin" sender:self];
                return;
            }
            
            [AppDelegateAccessor.locationManager startMonitoringSignificantLocationChanges];            
            [AppDelegateAccessor connect];
            [self performSegueWithIdentifier:@"ViewTravelUser" sender:self];

        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }
    }];

}

-(void)updateProfile
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APIClient updateProfile:[MyUtils shared].tempUser Completion:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (error == nil) {
            
            if ([MyUtils shared].user.blocked || ![MyUtils shared].user.verified) {
                [self performSegueWithIdentifier:@"BackToLogin" sender:self];
                return;
            }
            
            [self performSegueWithIdentifier:@"ViewTravelUser" sender:self];


        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }
    }];
    
}

/**************************Photo Take*****************************************/
- (IBAction)takePhoto:(id)sender {
    if (!mediaPicker) {
        //camera setting
        mediaPicker = [[UIImagePickerController alloc] init];
        [mediaPicker setDelegate:self];
        mediaPicker.allowsEditing = YES;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString( @"Cancel", nil )
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString( @"Take photo", nil ), NSLocalizedString( @"Choose from Library", nil ), nil];
        [actionSheet showInView:self.view];
    } else {
        if (!viewCamera) {
            viewCamera = [[UIViewController alloc] init];
            viewCamera.view.backgroundColor = [UIColor whiteColor];
        }
        [self.navigationController pushViewController:viewCamera animated:NO];
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [viewCamera presentViewController:mediaPicker animated:NO completion:nil];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (!viewCamera) {
        viewCamera = [[UIViewController alloc] init];
        viewCamera.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self.navigationController pushViewController:viewCamera animated:NO];
    if (buttonIndex == 0) {
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if (buttonIndex == 1) {
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    else{
        actionSheet.hidden = YES;
        return;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [viewCamera presentViewController:mediaPicker animated:NO completion:nil];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    /*chosenImage = [chosenImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(PHOTO_WIDTH, PHOTO_HEIGHT) interpolationQuality:100];*/
    
    //save photo to file.
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *fileName = PHOTO_FILE_NAME;
    NSString *filePath = [documentsPath stringByAppendingPathComponent: fileName]; //Add the file name

    //Write the file
    if ([pngData writeToFile:filePath atomically:YES]) {
    }
    else{
        ShowErrorAlert(NSLocalizedString( @"Can not save photo", nil ));
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO ];
    [self onUpload];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
    [self.navigationController popViewControllerAnimated:NO];
}
/*************************Photo File Upload onto Server*********************************************/
- (void) onUpload {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *dirPaths;
        NSString *docsDir;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        NSString *photoFilePath = [docsDir stringByAppendingPathComponent:PHOTO_FILE_NAME];
        NSData* photoData = [NSData dataWithContentsOfFile:photoFilePath];
        
        if (photoData) {
            NSDictionary *    resDict = [APIClient uploadFile:photo_type == 0 ? kUploadTypeAvatar : kUploadTypeBackground  FileName:[NSString stringWithFormat:@"%ld", [MyUtils shared].user.identifier] withData:photoData];
            [self performSelectorOnMainThread:@selector(updateViewWithPhoto:) withObject:resDict waitUntilDone:YES];
            
        }
        
    });
    
    
}


-(void) updateViewWithPhoto:(NSDictionary*) dict{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    if (!dict) {
        return;
    }
    NSString* fileName = [dict objectForKey:kFileName];
    
    if (fileName != nil && ![fileName isEqualToString:@""]) {
        fileName = [NSString stringWithFormat:@"%@%@", BASE_URL, fileName];
        if (photo_type == 0) {
            [MyUtils shared].tempUser.avatarImageURL = fileName;
            [self.avatarImageView loadImageFromURL:[NSURL URLWithString:fileName]];
        }
        else if(photo_type == 1)
        {
            [MyUtils shared].tempUser.backgroundImageURL = fileName;
            [self.featuredImageView loadImageFromURL:[NSURL URLWithString:fileName]];
        }

    }
    
    
}
- (IBAction)onTakeAvatarPhotoClicked:(id)sender {
    photo_type = 0;
    [self takePhoto:sender];
}

- (IBAction)onTakeBackgroundPhotoClicked:(id)sender {
    photo_type = 1;
    [self takePhoto:sender];
}

- (IBAction)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

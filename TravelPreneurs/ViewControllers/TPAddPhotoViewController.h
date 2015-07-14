//
//  TPAddPhotoViewController.h
//  TravelPreneurs
//
//  Created by CGH on 1/15/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface TPAddPhotoViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *mediaPicker;
    UIViewController *viewCamera;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *managerNameLabel;
@property (strong, nonatomic) IBOutlet AsyncImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet AsyncImageView *featuredImageView;

@property (strong, nonatomic) IBOutlet UILabel *subCategoryLabel1;
@property (strong, nonatomic) IBOutlet UILabel *subCategoryLabel2;
@property (strong, nonatomic) IBOutlet UILabel *subCategoryLabel3;
@property (strong, nonatomic) IBOutlet UIView *subCategoryDividerView1;
@property (strong, nonatomic) IBOutlet UIView *subCategoryDividerView2;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarHorizentalCenterConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthConstraint;

@end

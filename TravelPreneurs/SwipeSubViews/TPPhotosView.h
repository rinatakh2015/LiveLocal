//
//  TPPhotosView.h
//  TravelPreneurs
//
//  Created by CGH on 1/17/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface TPPhotosView : UIView <UICollectionViewDelegate , UICollectionViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *mediaPicker;
    UIViewController *viewCamera;
}

@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;


@property (strong, nonatomic) NSMutableArray* mPhotoArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *lineSeparator;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint;

@property int lastLoadedCount;
@property int lastLoadedPage;
@property int page;

@property User* user;
-(void) initialize:(User*)user;
@end

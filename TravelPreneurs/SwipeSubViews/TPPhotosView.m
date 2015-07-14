//
//  TPPhotosView.m
//  TravelPreneurs
//
//  Created by CGH on 1/17/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPPhotosView.h"
#import "MyUtils.h"
#import "AsyncImageView.h"
#import "defs.h"
#import "APIClient.h"
#import "MBProgressHUD.h"
#import "global_functions.h"
#import "NSString+Translate.h"
@implementation TPPhotosView
-(void) initialize:(User*)user
{
    self.user = user;
    
    self.mPhotoArray = [[NSMutableArray alloc] init];

    //[self sampleData];

    _lastLoadedCount = 0;
    _page = 0;
    _lastLoadedPage = -1;
    
    [self loadData];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TPPhotosCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"PhotosCollectionViewCell"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];

    if ([self isForMe]) {
        //self.checkButton.hidden = NO;
        self.deleteButton.hidden = NO;
    }
    else{
        //self.checkButton.hidden = YES;
        self.deleteButton.hidden = YES;
    }
    
    self.lineSeparatorHeightConstraint.constant = 0.5;
    
    [[MyUtils shared] applyTranslation:self];    
}

-(void)loadData
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [APIClient getUserUploadedPhotos:self.user.identifier Count:COUNTS_PER_PAGE Page:_page completionHandler:^(NSArray *passedResponse, NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:NO];
        if (!error) {
            
            //If it is already loaded data, ignore it
            if (_page <= _lastLoadedPage) {
                return;
            }
            
            if(_page == 0)
            {
                [self.mPhotoArray removeAllObjects];
            }
            
            _lastLoadedCount = [passedResponse count];
            _lastLoadedPage = _page;
            
            if (_lastLoadedCount > 0) {
                [self.mPhotoArray addObjectsFromArray:passedResponse];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }
    }];
}

-(BOOL)isForMe
{
    return [MyUtils shared].user.identifier == self.user.identifier;
}

-(UINavigationController*)navigationController
{
    return (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
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
        [actionSheet showInView:self];
    } else {
        if (!viewCamera) {
            viewCamera = [[UIViewController alloc] init];
            [viewCamera.view setBackgroundColor:[UIColor whiteColor]];
        }
        
        [self.navigationController pushViewController:viewCamera animated:NO];
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [viewCamera presentViewController:mediaPicker animated:NO completion:nil];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (!viewCamera) {
        viewCamera = [[UIViewController alloc] init];
        [viewCamera.view setBackgroundColor:[UIColor whiteColor]];
    }
    
    [self.navigationController pushViewController:viewCamera animated:NO];
    if (buttonIndex == 0) {
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if (buttonIndex == 1) {
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    else{
        actionSheet.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
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
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *dirPaths;
        NSString *docsDir;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        NSString *photoFilePath = [docsDir stringByAppendingPathComponent:PHOTO_FILE_NAME];
        NSData* photoData = [NSData dataWithContentsOfFile:photoFilePath];
        
        if (photoData) {
            NSDictionary *    resDict = [APIClient uploadFile:kUploadTypeUserImage FileName:[NSString stringWithFormat:@"%ld", [MyUtils shared].user.identifier] withData:photoData];
            [self performSelectorOnMainThread:@selector(updateViewWithPhoto:) withObject:resDict waitUntilDone:YES];
            
        }
        
    });
    
    
}


-(void) updateViewWithPhoto:(NSDictionary*) dict{
    
    [MBProgressHUD hideAllHUDsForView:self animated:NO];
    if (!dict) {
        return;
    }
    
    NSString* fileName = [dict objectForKey:kFileName];
    NSString* thumbnail = [dict objectForKey:kThumbnail] ? [NSString stringWithFormat:@"%@%@", BASE_URL, [dict objectForKey:kThumbnail]] : @"";
    
    if (fileName != nil && ![fileName isEqualToString:@""]) {
        fileName = [NSString stringWithFormat:@"%@%@", BASE_URL, fileName];
        
        [APIClient uploadUserPhoto:fileName Thumbnail:thumbnail completionHandler:^(NSDictionary *passedResponse, NSError *error) {
            if (!error) {
                long photoID = [[passedResponse valueForKey:kPhotoID] integerValue];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:@{kPhotoID:@(photoID), kPhotoURL:fileName, kThumbnail:thumbnail, kSelected:@(0)}] ;
                [self.mPhotoArray insertObject:dic atIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
            else
                ShowErrorAlert(error.localizedDescription);
        }];
        
    }
    
    
}


-(void)showPhoto:(NSString*)photoUrl Identifier:(int)photoId
{
    if (!photoUrl || photoUrl.length == 0) {
        return;
    }
    CGRect frame = [self.superview.superview.superview.superview frame];
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    UIView* photoView = [[UIView alloc] initWithFrame:frame ];
    [photoView setBackgroundColor:BLUE_BACKGROUND_COLOR];
    
    UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 40, 20, 30, 30)];
    [closeButton setImage:[UIImage imageNamed:@"icon_times"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closePhotoView:) forControlEvents:UIControlEventTouchDown];
    
    [photoView addSubview:closeButton];
    
    if(![self isForMe])
    {
        UIButton* reportButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 30)];
        reportButton.tag = photoId;
        [reportButton setTitle:[@"Report" translate] forState:UIControlStateNormal];
        [reportButton addTarget:self action:@selector(reportViolation:) forControlEvents:UIControlEventTouchDown];
        
        [photoView addSubview:reportButton];
    }
    
    AsyncImageView* imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(20, 20, frame.size.width - 40, frame.size.height - 40)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView loadImageFromURL:[NSURL URLWithString:photoUrl]];
    
    [photoView addSubview:imageView];
    
    [self.superview.superview.superview.superview addSubview:photoView];
}

-(void)closePhotoView:(id)sender
{
    [[sender superview] removeFromSuperview];
}

-(void) reportViolation:(id)sender
{
    int photoId = (int)[sender tag];
    [MBProgressHUD showHUDAddedTo:self.superview.superview.superview.superview animated:YES];
    [APIClient reportViolation:photoId completionHandler:^(NSArray *passedResponse, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.superview.superview.superview.superview animated:NO];
        if (!error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Photo has been reported", nil) message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:NSLocalizedString(@"Error", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil] show];
        }
    }];
}

#pragma mark - Collection View
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self isForMe]) {
        return self.mPhotoArray.count + 1;
    }
    return self.mPhotoArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PhotosCollectionViewCell";
    
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    AsyncImageView* photoView = (AsyncImageView*)[cell viewWithTag:1];
    UIButton* redCheckButton = (UIButton*)[cell viewWithTag:2];
    [photoView setImage:nil];
    
    if ([self isForMe]) {
        if (indexPath.item == 0) {
            [photoView setImage:[UIImage imageNamed:@"icon_camera.png"]];
            [redCheckButton setHidden:YES];
            photoView.contentMode = UIViewContentModeCenter;
            [[MyUtils shared] makeCircleViewWithBorder:photoView BorderWidth:1 BorderColor:[UIColor grayColor]];
        }
        else{
            photoView.contentMode = UIViewContentModeScaleToFill;
            NSDictionary* photoDic = [_mPhotoArray objectAtIndex:indexPath.item - 1];
            if (![photoDic objectForKey:kPhotoURL] || ((NSString*)[photoDic objectForKey:kPhotoURL]).length == 0) {
                [photoView setImage:nil];
            }
            else{
                //NSString* photoName = (NSString*)[photoDic objectForKey:kPhotoURL];
                NSString* thumbnail = (NSString*)[photoDic objectForKey:kThumbnail];
                
                if ([thumbnail rangeOfString:@"http://"].location != NSNotFound || [thumbnail rangeOfString:@"https://"].location != NSNotFound ) {
                    [photoView loadImageFromURL:[NSURL URLWithString:thumbnail]];
                }
                else
                    [photoView setImage:[UIImage imageNamed:thumbnail]];
            }
            
            if ([[photoDic objectForKey:kSelected] integerValue] == 1) {
                [redCheckButton setHidden:NO];
            }
            else
                [redCheckButton setHidden:YES];
            [[MyUtils shared] makeCircleViewWithBorder:photoView BorderWidth:0 BorderColor:[UIColor grayColor]];
            
        }
        
        
        
        if (indexPath.item == [self.mPhotoArray count] && _lastLoadedCount == COUNTS_PER_PAGE && _page <= _lastLoadedPage ) {
            _page++;
            [self loadData];
        }
        
    }
    else{
        NSDictionary* photoDic = [_mPhotoArray objectAtIndex:indexPath.item];
        if (![photoDic objectForKey:kPhotoURL] || ((NSString*)[photoDic objectForKey:kPhotoURL]).length == 0) {
            [photoView setImage:nil];
        }
        else{
            //NSString* photoName = (NSString*)[photoDic objectForKey:kPhotoURL];
            NSString* thumbnail = (NSString*)[photoDic objectForKey:kThumbnail];
            
            if ([thumbnail rangeOfString:@"http://"].location != NSNotFound || [thumbnail rangeOfString:@"https://"].location != NSNotFound ) {
                [photoView loadImageFromURL:[NSURL URLWithString:thumbnail]];
            }
            else
                [photoView setImage:[UIImage imageNamed:thumbnail]];
        }
        
        if ([[photoDic objectForKey:kSelected] integerValue] == 1) {
            [redCheckButton setHidden:NO];
        }
        else
            [redCheckButton setHidden:YES];

        
        [[MyUtils shared] makeCircleViewWithBorder:cell BorderWidth:0 BorderColor:[UIColor grayColor]];
        
        if (indexPath.item == [self.mPhotoArray count] && _lastLoadedCount == COUNTS_PER_PAGE && _page <= _lastLoadedPage ) {
            _page++;
            [self loadData];
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(95, 95);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isForMe]) {
        if (indexPath.item == 0) {
            [self takePhoto:self];
        }
        else{
            NSMutableDictionary* dic = [self.mPhotoArray objectAtIndex:indexPath.item - 1];
            if ([[dic valueForKey:kSelected] integerValue] == 0 ) {
                [dic setObject:@(1) forKey:kSelected];
            }
            else{
                [dic setObject:@(0) forKey:kSelected];
            }
            
            [self.collectionView reloadData];
        }
    }
    else{
        NSMutableDictionary* dic = [self.mPhotoArray objectAtIndex:indexPath.item];
        [self showPhoto:[dic objectForKey:kPhotoURL] Identifier:[dic objectForKey:kPhotoID]];
    }

}

- (IBAction)onClickCheckAll:(id)sender {
    for (NSMutableDictionary* dic in self.mPhotoArray) {
        if ([[dic objectForKey:kSelected] integerValue] == 0) {
            [dic setObject:@(1) forKey:kSelected];
        }
    }
    
    [self.collectionView reloadData];
}
- (IBAction)onClickDelete:(id)sender {
    NSMutableArray* deletedArray = [[NSMutableArray alloc] init];
    NSMutableArray* deleteIdArray = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary* dic in self.mPhotoArray) {
        if ([[dic objectForKey:kSelected] integerValue] == 1) {
            [deletedArray addObject:dic];
            [deleteIdArray addObject:@([[dic valueForKey:kPhotoID] integerValue])];
        }
    }

    if (deleteIdArray.count) {
        NSString* ids = [deleteIdArray componentsJoinedByString:@","];
        [APIClient deleteUserUploadedPhoto:ids completionHandler:^(NSDictionary *passedResponse, NSError *error) {
            if (!error) {
                [self.mPhotoArray removeObjectsInArray:deletedArray];
                [self.collectionView reloadData];
            }
            else{
                ShowErrorAlert(error.localizedDescription);
            }
        }];

    }

}
@end

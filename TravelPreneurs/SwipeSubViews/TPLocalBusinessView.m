//
//  TPLocalBusinessView.m
//  TravelPreneurs
//
//  Created by CGH on 1/16/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPLocalBusinessView.h"
#import "AsyncImageView.h"
#import "MyUtils.h"
#import "defs.h"
#import "MBProgressHUD.h"
#import "APIClient.h"
#import "global_functions.h"
#import "TPTravelerViewController.h"
#import "UIImage+Resize.h"

@implementation TPLocalBusinessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) initialize:(User*)user
{
    self.user = user;
    self.mUsersArray = [[NSMutableArray alloc] init];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TPLocalBusinessCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"LocalBusinessCollectionViewCell"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];

    self.mainCategories = mainCategories();
    
    //[self sampleData];
    //self.selectedMainCategory = TPMainCategory_NONE;
    if(self.selectedMainCategory == TPMainCategory_NONE)
        self.selectedSubCategories = [[NSArray alloc] init];
    
    _lastLoadedCount = 0;
    _page = 0;
    _lastLoadedPage = -1;
    
    [[MyUtils shared] applyTranslation:self];
    
    [self.collectionView reloadData];
    
    [self loadData];

    
    self.lineSeparatorHeightConstraint.constant = 0.5;
}

-(void)sampleData
{
    User* user = [User userFromDic:@{kUserId:@(1), kUserName:@"Tester1", kAvatarImageURL: @"icon_dinning.png"}];
    [self.mUsersArray addObject:user];

    user = [User userFromDic:@{kUserId:@(2), kUserName:@"Tester2", kAvatarImageURL: @"icon_activities.png"}];
    [self.mUsersArray addObject:user];
    
    user = [User userFromDic:@{kUserId:@(3), kUserName:@"Tester3", kAvatarImageURL: @"icon_health.png"}];
    [self.mUsersArray addObject:user];
    
    user = [User userFromDic:@{kUserId:@(4), kUserName:@"Tester4", kAvatarImageURL: @"icon_servicies.png"}];
    [self.mUsersArray addObject:user];
    
    user = [User userFromDic:@{kUserId:@(5), kUserName:@"Tester5", kAvatarImageURL: @"icon_nightlife.png"}];
    [self.mUsersArray addObject:user];
    
    user = [User userFromDic:@{kUserId:@(6), kUserName:@"Tester6", kAvatarImageURL: @"icon_shopping.png"}];
    [self.mUsersArray addObject:user];
    
    user = [User userFromDic:@{kUserId:@(7), kUserName:@"Tester7", kAvatarImageURL: @"icon_transport.png"}];
    [self.mUsersArray addObject:user];
    
    user = [User userFromDic:@{kUserId:@(8), kUserName:@"Tester8", kAvatarImageURL: @"icon_tourism.png"}];
    [self.mUsersArray addObject:user];
    
    user = [User userFromDic:@{kUserId:@(9), kUserName:@"Tester9", kAvatarImageURL: @"icon_events.png"}];
    [self.mUsersArray addObject:user];
}

-(void)loadData
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [APIClient getNearbyUsersWithRadius:[MyUtils shared].searchRadius MainCategory:self.selectedMainCategory SubCategories:self.selectedSubCategories Latitude:self.user.latitude Longitude:self.user.longitude Count:COUNTS_PER_PAGE Page:_page completionHandler:^(NSMutableArray *passedResponse, NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:NO];
        if (!error) {
            
            //If it is already loaded data, ignore it
            if (_page <= _lastLoadedPage) {
                return;
            }
            
            if(_page == 0)
            {
                [self.mUsersArray removeAllObjects];
            }
            
            _lastLoadedCount = [passedResponse count];
            _lastLoadedPage = _page;
            
            
            [self.mUsersArray addObjectsFromArray:passedResponse];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            

        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }
    }];

}

-(void) refresh
{
    [self.mUsersArray removeAllObjects];
    _lastLoadedCount = 0;
    _page = 0;
    _lastLoadedPage = -1;
    
    [self loadData];
}
#pragma mark - Collection View
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mUsersArray.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"LocalBusinessCollectionViewCell";
    
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    AsyncImageView* photoView = (AsyncImageView*)[cell viewWithTag:1];
    
    if (indexPath.item == 0) {
        if(self.selectedMainCategory == TPMainCategory_NONE)
            [photoView setImage:[UIImage imageNamed:@"icon_branch_big.png"]];
        else{
            NSString* image = [[self.mainCategories objectAtIndex:self.selectedMainCategory] objectForKey:@"big_icon"];
            [photoView setImage:[[UIImage imageNamed:image] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(60, 60) interpolationQuality:200]];
        }
        photoView.contentMode = UIViewContentModeCenter;
        [[MyUtils shared] makeCircleViewWithBorder:photoView BorderWidth:1 BorderColor:[UIColor grayColor]];
    }
    else{
        
        User* user = [_mUsersArray objectAtIndex:indexPath.item - 1];
        if (!user.avatarImageURL || user.avatarImageURL.length == 0) {
            [photoView setImage:[UIImage imageNamed:@"icon_defaultavatar.png"]];
        }
        else{
            
            if ([user.avatarImageURL rangeOfString:@"http://"].location != NSNotFound || [user.avatarImageURL rangeOfString:@"https://"].location != NSNotFound ) {
                [photoView loadImageFromURL:[NSURL URLWithString:user.avatarImageURL]];
            }
            else
                [photoView setImage:[UIImage imageNamed:user.avatarImageURL]];
        }
        photoView.contentMode = UIViewContentModeScaleToFill;
        [[MyUtils shared] makeCircleViewWithBorder:photoView BorderWidth:0 BorderColor:[UIColor grayColor]];
    }
    
    if (indexPath.item == [self.mUsersArray count] && _lastLoadedCount == COUNTS_PER_PAGE && _page <= _lastLoadedPage ) {
        _page++;
        [self loadData];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(95, 95);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        if (self.delegate) {
            [self.delegate showCategoryView];
        }
    }
    else{
        TPTravelerViewController* travelerViewController =(TPTravelerViewController* )[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TPTravelerViewController"];
        travelerViewController.user = [self.mUsersArray objectAtIndex:indexPath.item - 1];

        UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
        [nav pushViewController:travelerViewController animated:YES];

    }
}
@end

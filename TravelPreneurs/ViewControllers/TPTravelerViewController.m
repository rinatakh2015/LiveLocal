//
//  TPTravelerViewController.m
//  TravelPreneurs
//
//  Created by CGH on 1/15/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPTravelerViewController.h"
#import "MyUtils.h"
#import "defs.h"
#import "SwipeView.h"
#import "global_functions.h"
#import "APIClient.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Preferences.h"
#import "TPSetupViewController.h"

@interface TPTravelerViewController () <SwipeViewDataSource, SwipeViewDelegate>
{
    BOOL isExpanded;
    int swipeViewPageCount;

}
@property (strong, nonatomic) UICollectionView* localBusinessCollectionView;
@property (strong, nonatomic) IBOutlet SwipeView *swipeView;
@property BOOL lockMoving;
@end

@implementation TPTravelerViewController

-(void)sampleData
{
    self.user = [User userFromDic:@{kUserId:@(1), kUserName:@"Tester1", kFullname:@"Matin1" , kBusinessName:@"BusinessName1", kManagerName:@"ManagerName1"}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.swipeView.wrapEnabled = YES;
    self.swipeView.scrollEnabled = NO;
    
    self.mSubCategoryPickerFirst.hidden =YES;
    self.mSubCategoryPickerSecond.hidden = YES;
    self.mSubCategoryPickerThird.hidden = YES;
    
    if (self.user.accountType == TPAccountType_TRAVELER && [self isForMe]) {
        swipeViewPageCount = 3;
    }

    if(self.user.accountType != TPAccountType_TRAVELER && [self isForMe])
    {
        swipeViewPageCount = 5;
    }

    if(self.user.accountType != TPAccountType_TRAVELER && ![self isForMe])
    {
        swipeViewPageCount = 5;
    }
    
    [_swipeView setAlignment:SwipeViewAlignmentCenter];
    _swipeView.itemsPerPage = 1;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [_swipeView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    singleTapGestureRecognizer.delegate = self;
    singleTapGestureRecognizer.numberOfTapsRequired =1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.mCategoryPanel addGestureRecognizer:singleTapGestureRecognizer];
    
    
    if (self.user) {
        if (self.user.accountType == TPAccountType_TRAVELER) {
            [self.titleLabel setText:self.user.fullName];
            self.managerNameLabel.hidden = YES;
            self.subCategoryLabel1.hidden = YES;
            self.subCategoryLabel2.hidden = YES;
            self.subCategoryLabel3.hidden = YES;
            self.subCategoryDividerView1.hidden = YES;
            self.subCategoryDividerView2.hidden = YES;
            
            self.avatarHorizentalCenterConstant.constant = 0;
            self.avatarTopConstraint.constant = -71;
            self.avatarWidthConstraint.constant = 190;
            self.avatarSettingButtonLeadingConstraint.constant = 11;

        }
        else
        {
            [self.titleLabel setText:self.user.businessName];
            [self.managerNameLabel setText:self.user.managerName];
            
            self.managerNameLabel.hidden = NO;
            self.subCategoryLabel1.hidden = NO;
            self.subCategoryLabel2.hidden = NO;
            self.subCategoryLabel3.hidden = NO;
            self.subCategoryDividerView1.hidden = NO;
            self.subCategoryDividerView2.hidden = NO;
            
            self.avatarHorizentalCenterConstant.constant = 60;
            self.avatarTopConstraint.constant = -67;
            self.avatarWidthConstraint.constant = 158;
            self.avatarSettingButtonLeadingConstraint.constant = 0;
        }
        
    }
    
    if ([self isForMe]) {
         self.homeButton.hidden = YES;
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"icon_gearwhite"] forState:UIControlStateNormal];
    }
    else{
        self.homeButton.hidden = NO;
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"icon_likewhite"] forState:UIControlStateNormal];
        
        if( [[MyUtils shared].user.favouriteIds containsObject:[NSString stringWithFormat:@"%ld", self.user.identifier]])
            self.chatButton.hidden = NO;
        else
            self.chatButton.hidden = YES;

    }
    
    
    [self initialize];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:@"newMessageReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatFlagChecked:) name:@"chatFlagChecked" object:nil];

    [self newMessageReceived:nil];

    [[MyUtils shared] setTranslationLanguage:[MyUtils shared].user.nativeLanguage];    
    [[MyUtils shared] applyTranslation:self.view];
}


- (void)newMessageReceived:(NSNotification *)note
{
    if ([self isForMe]) {
        [self chatFlagChecked:nil];
    }
    else{
        [self.chatButton setImage:[UIImage imageNamed:@"icon_chat_gray"] forState:UIControlStateNormal];
        NSNumber* flag = [[MyUtils shared].chatRedFlagDic valueForKey: [NSString stringWithFormat:@"%ld", self.user.identifier]];
        if (flag && [flag integerValue] == 1) {
            [self.chatButton setImage:[UIImage imageNamed:@"icon_chatred"] forState:UIControlStateNormal];
        }
    }

    if(self.favouriteView)
    {
        [self.favouriteView.tableView reloadData];
    }
    
}

- (void)chatFlagChecked:(NSNotification *)note
{

    bool hasNewMessage = NO;
    for (NSString* favouriteId in [MyUtils shared].user.favouriteIds) {
        NSMutableDictionary* dd = [MyUtils shared].chatRedFlagDic;
        NSNumber* flag = [[MyUtils shared].chatRedFlagDic valueForKey:favouriteId];
        if (flag && [flag integerValue] == 1) {
            [self.chatButton setImage:[UIImage imageNamed:@"icon_chatred"] forState:UIControlStateNormal];
            hasNewMessage = YES;
            break;
        }
    }
    if (!hasNewMessage) {
       [self.chatButton setImage:[UIImage imageNamed:@"icon_chat_gray"] forState:UIControlStateNormal];
    }

    if(self.favouriteView)
    {
        [self.favouriteView.tableView reloadData];
    }
    
}


-(BOOL) isForMe
{
    return [MyUtils shared].user.identifier == self.user.identifier;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.avatarImageView layoutIfNeeded];
    [[MyUtils shared] makeCircleViewWithBorder:self.avatarImageView BorderWidth:MAIN_AVATAR_BORDER_WIDTH * self.avatarImageView.frame.size.width / 179.0 BorderColor:MAIN_AVATAR_BORDER_COLOR];
    
    if (self.user.accountType == TPAccountType_TRAVELER) {
        
        [self.avatarImageView setImage:[UIImage imageNamed:@"icon_avatarbg.png"]];

        if (self.user.avatarImageURL) {
            [self.avatarImageView loadImageFromURL:[NSURL URLWithString:self.user.avatarImageURL]];
        }
        else{
            [self.avatarImageView setImage:[UIImage imageNamed:@"icon_defaultavatar"]];
        }

        [self.featuredImageView setImage:[UIImage imageNamed:@"featured_user.png"]];
        if (self.user.backgroundImageURL) {
            [self.featuredImageView loadImageFromURL:[NSURL URLWithString:self.user.backgroundImageURL]];
        }
        
    }
    else{
        [self.avatarImageView setImage:[UIImage imageNamed:@"icon_avatarbg_business"]];
        
        if (self.user.avatarImageURL) {
            [self.avatarImageView loadImageFromURL:[NSURL URLWithString:self.user.avatarImageURL]];
        }
        else{
            [self.avatarImageView setImage:[UIImage imageNamed:@"icon_defaultavatar"]];
        }
        
        [self.featuredImageView setImage:[UIImage imageNamed:@"featured_business.png"]];
        if (self.user.backgroundImageURL) {
            [self.featuredImageView loadImageFromURL:[NSURL URLWithString:self.user.backgroundImageURL]];
        }
        
    }
    
    self.mSubCategoryViewHeightConstant.constant = self.swipeViewContainer.frame.size.height - 60;
    [self.mSubCategoryView layoutIfNeeded];
    
    UIView* view = [self.swipeView currentItemView];
    if ([view respondsToSelector:@selector(initialize:)]) {
        [view performSelector:@selector(initialize:) withObject:self.user];
    }
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) favouriteUser
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APIClient favouriteUser:self.user.identifier completionHandler:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if (error) {
            ShowErrorAlert(error.localizedDescription);
        }
        else
        {
            [AppDelegateAccessor createGroup:[[MyUtils shared] getChattingRoomIdentifierWith:self.user.identifier] invites:[NSMutableArray arrayWithObject:self.user]];
            
            [self.user.favouriteIds addObject:[NSString stringWithFormat:@"%ld", self.user.identifier]];
            self.chatButton.hidden = NO;
        }
    }];
}
- (IBAction)onClickChatButton:(id)sender {
    if([self isForMe])
    {
        int count = 0;
        NSString* fId = nil;
        for (NSString* favouriteId in [MyUtils shared].user.favouriteIds) {
            NSNumber* flag = [[MyUtils shared].chatRedFlagDic valueForKey:favouriteId];
            if (flag && [flag integerValue] == 1) {
                count++;
                fId = favouriteId;
            }
        }
        
        /*if (count == 1) {
            TPChatViewController* chatViewController = [[TPChatViewController alloc] initWithUser:fId];
            
            UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
            [nav pushViewController:chatViewController animated:YES];
        }*/

         [self.swipeView setCurrentPage:2];
        
    }
    else{
        TPChatViewController* chatViewController = [[TPChatViewController alloc] initWithUser:self.user];
        
        UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
        [nav pushViewController:chatViewController animated:YES];
    }
}

- (IBAction)onClickSetting:(id)sender {
    if ([self isForMe]) {
        [MyUtils shared].tempUser = [User copy:[MyUtils shared].user];
        [self performSegueWithIdentifier:@"ViewSetup" sender:self];
    }
    else{
        [self favouriteUser];
    }

}

- (IBAction)onClickShareButton:(id)sender {
    NSString *textToShare = @"Please look at this awesome app!";
    NSURL *myWebsite = [NSURL URLWithString:@"http://itunesconnect.com"];
    UIImage *image = [UIImage imageNamed:@"share_image.png"];
    NSArray *objectsToShare = @[textToShare, myWebsite, image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)onClickHome:(id)sender {
    if (![self isForMe]) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}


#pragma mark - Swipe Sub Views
-(UIView*)viewForLocalBusinessWithParent:(UIView*) parentView
{
    if (self.localBusinessView) {
        self.localBusinessView.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
        self.localBusinessView.selectedMainCategory = self.selectedMainCategoryIndex;
        [self.localBusinessView initialize:self.user];
        return self.localBusinessView;
    }
    
    TPLocalBusinessView* view = (TPLocalBusinessView*)[[[NSBundle mainBundle] loadNibNamed:@"TPLocalBusinessView" owner:self options:nil] objectAtIndex:0];
    
    view.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
    view.selectedMainCategory = TPMainCategory_NONE;
    [view initialize:self.user];
    view.delegate = self;
    self.localBusinessView = view;
    
    return view;
}

-(UIView*)viewForLocationWithParent:(UIView*) parentView
{
    if (self.locationView) {
        self.locationView.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
        [self.locationView initialize:self.user];
        return self.locationView;
    }
    
    TPLocationView* view = (TPLocationView*)[[[NSBundle mainBundle] loadNibNamed:@"TPLocationView" owner:self options:nil] objectAtIndex:0];
    view.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
    [view initialize:self.user];
    self.locationView = view;
    
    return view;
}

-(UIView*)viewForReviewWithParent:(UIView*) parentView
{
    if (self.reviewView) {
        self.reviewView.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
        [self.reviewView initialize:self.user];
        return self.reviewView;
    }
    
    TPReviewView* view = (TPReviewView*)[[[NSBundle mainBundle] loadNibNamed:@"TPReviewView" owner:self options:nil] objectAtIndex:0];
    view.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
    [view initialize:self.user];
    self.reviewView  = view;
    
    return view;
}

-(UIView*)viewForFavouriteWithParent:(UIView*) parentView
{
    if (self.favouriteView) {
        self.favouriteView.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
        [self.favouriteView initialize:self.user];
        return self.favouriteView;
    }
    
    TPFavouriteView* view = (TPFavouriteView*)[[[NSBundle mainBundle] loadNibNamed:@"TPFavouriteView" owner:self options:nil] objectAtIndex:0];
    view.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
    [view initialize:self.user];
    self.favouriteView = view;
    
    return view;
}

-(UIView*)viewForLinksWithParent:(UIView*) parentView
{
    if (self.linksView) {
        [self.linksView initialize:self.user];
        self.linksView.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
        return self.linksView;
    }
    
    TPLinksView* view = (TPLinksView*)[[[NSBundle mainBundle] loadNibNamed:@"TPLinksView" owner:self options:nil] objectAtIndex:0];
    view.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
    [view initialize:self.user];
    self.linksView = view;
    
    return view;
}

-(UIView*)viewForPhotosWithParent:(UIView*) parentView
{
    if (self.photosView) {
        self.photosView.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
        [self.photosView initialize:self.user];
        return self.photosView;
    }
    
    TPPhotosView* view = (TPPhotosView*)[[[NSBundle mainBundle] loadNibNamed:@"TPPhotosView" owner:self options:nil] objectAtIndex:0];
    view.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
    [view initialize:self.user];
    self.photosView = view;
    
    return view;
}

-(UIView*)viewForGreetingWithParent:(UIView*) parentView
{
    if (self.greetingView) {
        self.greetingView.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
        [self.greetingView initialize:self.user];
        return self.greetingView;
    }
    
    TPGreetingView* view = (TPGreetingView*)[[[NSBundle mainBundle] loadNibNamed:@"TPGreetingView" owner:self options:nil] objectAtIndex:0];
    view.frame = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height) ;
    [view initialize:self.user];
    self.greetingView = view;
    
    return view;
}

-(void)swipeHandler:(UISwipeGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self.swipeView];
    if (point.y < 40) {
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
            [self.swipeView scrollToItemAtIndex:(self.swipeView.currentItemIndex + 1 ) % self.swipeView.numberOfItems duration:0.4];
        }
        else if(sender.direction == UISwipeGestureRecognizerDirectionRight)
        {
            [self.swipeView scrollToItemAtIndex:(self.swipeView.currentItemIndex - 1 ) % self.swipeView.numberOfItems duration:0.4];
        }
    }

}

#pragma mark - SwipeView delegate

-(CGSize)swipeViewItemSize:(SwipeView *)swipeView{
    
    if (isExpanded) {
        return swipeView.frame.size;
    }
    else{
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - self.featuredImageView.frame.size.height);
    }
    
    //return swipeView.frame.size;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return swipeViewPageCount;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //if current user is traveler, current page is for the traveler.
    if (self.user.accountType == TPAccountType_TRAVELER && [self isForMe]) {
        if( index == 0 )
        {
            view = [self viewForLocationWithParent:swipeView];
        }
        else if (index == 1) {
            view = [self viewForLocalBusinessWithParent:swipeView];
        }
        else if (index == 2)
        {
            view = [self viewForFavouriteWithParent:swipeView];
        }
    }
    
    //if current user is business, current page is for the business user.
    if(self.user.accountType != TPAccountType_TRAVELER && [self isForMe])
    {
        if( index == 0 )
        {
            view = [self viewForLocationWithParent:swipeView];
        }
        else if (index == 1) {
           view = [self viewForGreetingWithParent:swipeView];
        }
        else if (index == 2) {
            view = [self viewForFavouriteWithParent:swipeView];
        }
        else if (index == 3)
        {
            view = [self viewForPhotosWithParent:swipeView];
        }
        else if( index == 4 )
        {
            view = [self viewForReviewWithParent:swipeView];
        }

    }
    
    //if current user is traveler, current page user is business user
    if(self.user.accountType != TPAccountType_TRAVELER && ![self isForMe])
    {
        if( index == 0 )
        {
            view = [self viewForLocationWithParent:swipeView];
        }
        else if (index == 1) {
            view = [self viewForGreetingWithParent:swipeView];
        }
        else if (index == 2) {
            view = [self viewForReviewWithParent:swipeView];
        }
        else if (index == 3)
        {
            view = [self viewForLinksWithParent:swipeView];
        }
        else if( index == 4 )
        {
            view = [self viewForPhotosWithParent:swipeView];
        }
    }
    
    UISwipeGestureRecognizer* recognizerSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    recognizerSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft ;
    [view addGestureRecognizer:recognizerSwipeLeft];
    
    UISwipeGestureRecognizer* recognizerSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    recognizerSwipeRight.direction = UISwipeGestureRecognizerDirectionRight ;
    [view addGestureRecognizer:recognizerSwipeRight];
    
     return view;
}


-(void)swipeViewDidScroll:(SwipeView *)swipeView
{
}

#pragma mark - Handle Double Click

-(void) handleTapGesture:(id)sender{

    CGPoint point = [sender locationInView:self.swipeView];
    if (point.y > 40)
    {
        return;
    }
    
    if (isExpanded) {

        self.inputPanelVerticalSpacingConstraint.constant = 0;
        isExpanded = NO;

        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            /*dispatch_async(dispatch_get_main_queue(), ^{
                [self.view layoutIfNeeded];
            });*/
            [_swipeView reloadData];
        }];

    }
    else{
        
        if( [self.swipeView.currentItemView class] == [TPLinksView class] )
        {
            return;
        }
        
        self.inputPanelVerticalSpacingConstraint.constant =  -self.featuredImageView.frame.size.height + 20;
        isExpanded = YES;
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            /*dispatch_async(dispatch_get_main_queue(), ^{
                [self.view layoutIfNeeded];
            });*/
            [_swipeView reloadData];            
        }];
        

    }
}


#pragma mark - Category

-(void) initialize
{
    _mMainCategoryArray = mainCategories();
    
    _mSubCategoryArrayForFirst = @[];
    _mSubCategoryArrayForSecond = @[];
    _mSubCategoryArrayForThird = @[];
    
    _selectedMainCategoryIndex = TPMainCategory_NONE;

    
    self.lockMoving = YES;

    if (self.user.accountType != TPAccountType_TRAVELER) {
        [self collectionView:self.mMainCategoryCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:self.user.mainCategory inSection:0]];
        if (!self.user.subCategories) {
            [self.mSubCategoryPickerFirst selectRow:0 inComponent:0 animated:NO];
            [self.mSubCategoryPickerSecond selectRow:0 inComponent:0 animated:NO];
            [self.mSubCategoryPickerThird selectRow:0 inComponent:0 animated:NO];
        }
        else{
            [self.mSubCategoryPickerFirst selectRow:[[self.user.subCategories objectAtIndex:0] integerValue] inComponent:0 animated:NO];
            [self.mSubCategoryPickerSecond selectRow:[[self.user.subCategories objectAtIndex:1] integerValue] inComponent:0 animated:NO];
            [self.mSubCategoryPickerThird selectRow:[[self.user.subCategories objectAtIndex:2] integerValue] inComponent:0 animated:NO];
            
            self.subCategoryLabel1.text = [[self.mSubCategoryArrayForFirst objectAtIndex: [[self.user.subCategories objectAtIndex:0] integerValue]] objectForKey:@"title"];
            self.subCategoryLabel2.text = [[self.mSubCategoryArrayForSecond objectAtIndex: [[self.user.subCategories objectAtIndex:1] integerValue]] objectForKey:@"title"];
            self.subCategoryLabel3.text = [[self.mSubCategoryArrayForThird objectAtIndex: [[self.user.subCategories objectAtIndex:2] integerValue]] objectForKey:@"title"];
            
       }
    }

    self.lockMoving = NO;
    
}
#pragma mark - Collection View
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _mMainCategoryArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CollectionCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary* mainCategory = [_mMainCategoryArray objectAtIndex:indexPath.item];
    
    UIImageView* categoryImageView = (UIImageView*)[cell viewWithTag:1];
    UITextView* titleLabel = (UITextView*)[cell viewWithTag:2];
    UIImageView* selectionImageView = (UIImageView*)[cell viewWithTag:3];
    
    if (indexPath.item == _selectedMainCategoryIndex) {
        [selectionImageView setHidden:NO];
    }
    else
        [selectionImageView setHidden:YES];

    UIImage* categoryIcon = [UIImage imageNamed:[mainCategory objectForKey:@"icon"]];
    [categoryImageView setImage:categoryIcon];
    [titleLabel setText:[[MyUtils shared] convertMainCategoryToString: [[mainCategory objectForKey:@"type"] integerValue] ]];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.mSubCategoryPickerFirst.hidden = NO;
    self.mSubCategoryPickerSecond.hidden = NO;
    self.mSubCategoryPickerThird.hidden = NO;
    
    if(_selectedMainCategoryIndex == indexPath.item && _isPanelMoved)
    {
        [self moveBackCategoryPanel:YES];
        return;
    }
    _selectedMainCategoryIndex = (int)indexPath.item;
    [_mMainCategoryCollectionView reloadData];
    
    switch ([self selectedMainCategory]) {
        case TPMainCategory_DINING:
            [self showDiningSubCategories];
            break;
        case TPMainCategory_ACTIVITIES:
            [self showActivitiesSubCategories];
            break;
        case TPMainCategory_HEALTH:
            [self showHealthSubCategories];
            break;
        case TPMainCategory_NIGHTLIFE:
            [self showNightlifeSubCategories];
            break;
        case TPMainCategory_SERVICES:
            [self showServicesSubCategories];
            break;
        case TPMainCategory_SHOPPING:
            [self showShoppingSubCategories];
            break;
        case TPMainCategory_TRANSPORT:
            [self showTransportSubCategories];
            break;
        case TPMainCategory_TOURISM:
            [self showTourismSubCategories];
            break;
        case TPMainCategory_EVENTS:
            [self showEventsSubCategories];
            break;
        default:
            break;
    }

    [self.mMainCategoryCollectionView reloadData];
    
    [_mSubCategoryPickerFirst reloadAllComponents];
    [_mSubCategoryPickerSecond reloadAllComponents];
    [_mSubCategoryPickerThird reloadAllComponents];

    if ([MyUtils shared].user.mainCategory != indexPath.item) {
        [self.mSubCategoryPickerFirst selectRow:0 inComponent:0 animated:YES];
        [self.mSubCategoryPickerSecond selectRow:0 inComponent:0 animated:YES];
        [self.mSubCategoryPickerThird selectRow:0 inComponent:0 animated:YES];
    }
    
    
    [self moveCategoryPanel: YES];
    
    if (!self.lockMoving) {
        [self setCategories];
    }
    
    [self onSelectCategory:self];
}


-(void) moveCategoryPanel:(BOOL) isAnimated
{
    if (_isPanelMoved || self.lockMoving) {
        return;
    }
    if(self.localBusinessView && self.selectedMainCategoryIndex != TPMainCategory_NONE)
    {
        self.lockMoving = YES;
        [self collectionView:self.mMainCategoryCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:self.localBusinessView.selectedMainCategory inSection:0]];
        
        if (!self.localBusinessView.selectedSubCategories) {
            [self.mSubCategoryPickerFirst selectRow:0 inComponent:0 animated:NO];
            [self.mSubCategoryPickerSecond selectRow:0 inComponent:0 animated:NO];
            [self.mSubCategoryPickerThird selectRow:0 inComponent:0 animated:NO];
        }
        else{
            [self.mSubCategoryPickerFirst selectRow:[[self.localBusinessView.selectedSubCategories objectAtIndex:0] integerValue] inComponent:0 animated:NO];
            [self.mSubCategoryPickerSecond selectRow:[[self.localBusinessView.selectedSubCategories objectAtIndex:1] integerValue] inComponent:0 animated:NO];
            [self.mSubCategoryPickerThird selectRow:[[self.localBusinessView.selectedSubCategories objectAtIndex:2] integerValue] inComponent:0 animated:NO];
        }
        self.lockMoving = NO;
    }
    [self.view layoutIfNeeded];
    
    if (isAnimated) {
        self.mCategoryPanelTopSpacingConstant.constant = -self.view.frame.size.height + self.featuredImageView.frame.size.height;
        /*
        self.mSubCategoryViewTopSpacingConstant.constant = self.featuredImageView.frame.size.height;
        self.mSubCategoryViewHeightConstant.constant = self.mBottomView.frame.origin.y - self.featuredImageView.frame.size.height;*/
        
        _isPanelMoved = YES;
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        
        self.mCategoryPanelTopSpacingConstant.constant = -self.view.frame.size.height + self.featuredImageView.frame.size.height;
        
        _isPanelMoved = YES;
       [self.view layoutIfNeeded];
    }
    
}

-(void) moveBackCategoryPanel:(BOOL) isAnimated
{
    if (!_isPanelMoved || self.lockMoving) {
        return;
    }
    
    
    if (isAnimated) {
        self.mCategoryPanelTopSpacingConstant.constant = 0;
        _isPanelMoved = NO;
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        self.mCategoryPanelTopSpacingConstant.constant = 0;
        _isPanelMoved = NO;
       [self.view layoutIfNeeded];
    }
    
}

-(TPMainCategory)selectedMainCategory
{
    if (_selectedMainCategoryIndex < 0) {
        return TPMainCategory_NONE;
    }
    
    NSDictionary* categoryDic = [_mMainCategoryArray objectAtIndex:_selectedMainCategoryIndex];
    return [[categoryDic objectForKey:@"type"] integerValue];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view==self.mCategoryPanel ) {
        return YES;
    }
    else if (touch.view == self.mIputPanel || touch.view == self.mSubCategoryView)
    {
        return YES;
    }
    return NO;

}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer*)recognizer
{
    [self moveBackCategoryPanel:YES];
}

- (IBAction)onSelectCategory:(id)sender {
    [self moveBackCategoryPanel:YES];
    if (self.localBusinessView) {
        self.localBusinessView.selectedMainCategory = [self selectedMainCategory];
        self.localBusinessView.selectedSubCategories = @[ @([self.mSubCategoryPickerFirst selectedRowInComponent:0]), @([self.mSubCategoryPickerSecond selectedRowInComponent:0]), @([self.mSubCategoryPickerThird selectedRowInComponent:0]) ];
        [self.localBusinessView refresh];
    }

}

- (IBAction)onClickLogout:(id)sender {
    
    [[Preferences sharedInstance] clear];
    [MyUtils shared].user = [[User alloc] init];
    [MyUtils shared].tempUser = [[User alloc] init];
    [AppDelegateAccessor.locationManager stopMonitoringSignificantLocationChanges];
    [AppDelegateAccessor disconnect];
    [self performSegueWithIdentifier:@"BackToLogin" sender:self];

    
}

-(void) setCategories
{
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma -UIPickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerView == _mSubCategoryPickerFirst) {
        return [_mSubCategoryArrayForFirst count];
    }
    else if(pickerView == _mSubCategoryPickerSecond)
    {
        return [_mSubCategoryArrayForSecond count];
    }
    else if(pickerView == _mSubCategoryPickerThird)
    {
        return [_mSubCategoryArrayForThird count];
    }
    
    return 0;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 37;
}

- (UIView *)pickerView:(__unused UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(__unused NSInteger)component reusingView:(UIView *)view
{
    NSDictionary* dic;
    if (pickerView == _mSubCategoryPickerFirst) {
        dic =  [_mSubCategoryArrayForFirst objectAtIndex:row];
    }
    else if(pickerView == _mSubCategoryPickerSecond)
    {
        dic =  [_mSubCategoryArrayForSecond objectAtIndex:row];
    }
    else if(pickerView == _mSubCategoryPickerThird)
    {
        dic =  [_mSubCategoryArrayForThird objectAtIndex:row];
    }
    
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, pickerView.frame.size.width , 24)];
        label.font = [UIFont systemFontOfSize: LABEL_FONTSIZE];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        [view addSubview:label];
    }
    
    ((UILabel *)[view viewWithTag:1]).text = [dic objectForKey:@"title"];
    return view;
}

#pragma mark - TPUserViewControllerDelegate
-(void)showCategoryView
{
    [self moveCategoryPanel:YES];
}

#pragma mark - SubCategories
-(void) showDiningSubCategories
{
    _mSubCategoryArrayForFirst = [diningSubCategories() objectAtIndex:0];
    _mSubCategoryArrayForSecond = [diningSubCategories() objectAtIndex:1];
    _mSubCategoryArrayForThird = [diningSubCategories() objectAtIndex:2];
    
}

-(void)showActivitiesSubCategories
{
    _mSubCategoryArrayForFirst = [activitiesSubCategories() objectAtIndex:0];
    _mSubCategoryArrayForSecond = [activitiesSubCategories() objectAtIndex:1];
    _mSubCategoryArrayForThird = [activitiesSubCategories() objectAtIndex:2];
    
}

-(void)showHealthSubCategories
{
    _mSubCategoryArrayForFirst = [healthSubCategories() objectAtIndex:0];
    _mSubCategoryArrayForSecond = [healthSubCategories() objectAtIndex:1];
    _mSubCategoryArrayForThird = [healthSubCategories() objectAtIndex:2];
}
-(void)showServicesSubCategories
{
    _mSubCategoryArrayForFirst = [servicesSubCategories() objectAtIndex:0];
    _mSubCategoryArrayForSecond = [servicesSubCategories() objectAtIndex:1];
    _mSubCategoryArrayForThird = [servicesSubCategories() objectAtIndex:2];
}

-(void)showNightlifeSubCategories
{
    _mSubCategoryArrayForFirst = [nightlifeSubCategories() objectAtIndex:0];
    _mSubCategoryArrayForSecond = [nightlifeSubCategories() objectAtIndex:1];
    _mSubCategoryArrayForThird = [nightlifeSubCategories() objectAtIndex:2];
}

-(void)showShoppingSubCategories
{
    _mSubCategoryArrayForFirst = [shoppingSubCategories() objectAtIndex:0];
    
    _mSubCategoryArrayForSecond =[shoppingSubCategories() objectAtIndex:1];
    _mSubCategoryArrayForThird = [shoppingSubCategories() objectAtIndex:2];
}

-(void)showTransportSubCategories
{
    _mSubCategoryArrayForFirst = [transportSubCategories() objectAtIndex:0];
    _mSubCategoryArrayForSecond =[transportSubCategories() objectAtIndex:1];
    _mSubCategoryArrayForThird = [transportSubCategories() objectAtIndex:2];
}

-(void)showTourismSubCategories{
    _mSubCategoryArrayForFirst = [tourismSubCategories() objectAtIndex:0];
    _mSubCategoryArrayForSecond = [tourismSubCategories() objectAtIndex:1];
    _mSubCategoryArrayForThird = [tourismSubCategories() objectAtIndex:2];
}

-(void)showEventsSubCategories{
    _mSubCategoryArrayForFirst = [eventsSubCategories() objectAtIndex:0];
    _mSubCategoryArrayForSecond = [eventsSubCategories() objectAtIndex:1];
    _mSubCategoryArrayForThird = [eventsSubCategories() objectAtIndex:2];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end

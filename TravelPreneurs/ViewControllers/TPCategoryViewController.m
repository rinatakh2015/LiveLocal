//
//  TPCategoryViewController.m
//  TravelPreneurs
//
//  Created by CGH on 12/16/14.
//  Copyright (c) 2014 Jay. All rights reserved.
//

#import "TPCategoryViewController.h"
#import "AsyncImageView.h"
#import "MyEnums.h"
#import "MyUtils.h"
#import "defs.h"
#import "global_functions.h"
#import <QuartzCore/QuartzCore.h>
#import "MyUtils.h"

@interface TPCategoryViewController ()
@property BOOL lockMoving;
@end

@implementation TPCategoryViewController

-(void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    singleTapGestureRecognizer.delegate = self;
    singleTapGestureRecognizer.numberOfTapsRequired =1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];

    [self initialize];
    
    [[MyUtils shared] applyTranslation:self.view];    
}

-(void)viewWillDisappear:(BOOL)animated
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)unwindToCategory:(UIStoryboardSegue *)unwindSegue
{
}

-(void) initialize
{
    _mMainCategoryArray = mainCategories();
    
    _mSubCategoryArrayForFirst = @[];
    _mSubCategoryArrayForSecond = @[];
    _mSubCategoryArrayForThird = @[];
    
    _selectedMainCategoryIndex = 0;
    
    self.lockMoving = YES;
    [self collectionView:self.mMainCategoryCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:[MyUtils shared].tempUser.mainCategory inSection:0]];
    if (![MyUtils shared].tempUser.subCategories) {
        [self.mSubCategoryPickerFirst selectRow:0 inComponent:0 animated:NO];
        [self.mSubCategoryPickerSecond selectRow:0 inComponent:0 animated:NO];
        [self.mSubCategoryPickerThird selectRow:0 inComponent:0 animated:NO];
    }
    else{
        [self.mSubCategoryPickerFirst selectRow:[[[MyUtils shared].tempUser.subCategories objectAtIndex:0] integerValue] inComponent:0 animated:NO];
        [self.mSubCategoryPickerSecond selectRow:[[[MyUtils shared].tempUser.subCategories objectAtIndex:1] integerValue] inComponent:0 animated:NO];
        [self.mSubCategoryPickerThird selectRow:[[[MyUtils shared].tempUser.subCategories objectAtIndex:2] integerValue] inComponent:0 animated:NO];
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
  
    
    if(_selectedMainCategoryIndex == indexPath.item && _isPanelMoved)
    {
        [self moveBackCategoryPanel:YES Completion:nil];
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


    
    [_mSubCategoryPickerFirst reloadAllComponents];
    [_mSubCategoryPickerSecond reloadAllComponents];
    [_mSubCategoryPickerThird reloadAllComponents];
    
    if ([MyUtils shared].tempUser.mainCategory != indexPath.item) {
        [self.mSubCategoryPickerFirst selectRow:0 inComponent:0 animated:YES];
        [self.mSubCategoryPickerSecond selectRow:0 inComponent:0 animated:YES];
        [self.mSubCategoryPickerThird selectRow:0 inComponent:0 animated:YES];
    }
    
    
    [self moveCategoryPanel: YES];
    
    if (!self.lockMoving) {
        [self setCategories];
    }
    
}


-(void) moveCategoryPanel:(BOOL) isAnimated
{
    self.mSubCategoryViewHeightConstant.constant = self.mBottomView.frame.origin.y -  self.mFeaturedImageView.frame.size.height;
    [self.view layoutIfNeeded];
    
    if (_isPanelMoved || self.lockMoving) {
        return;
    }
  
    
    if (isAnimated) {
        self.mInputPanelTopSpacingConstant.constant = -self.mFeaturedImageView.frame.size.height;
        self.mMainCategoryCollectionViewTopSpacingConstant.constant = (self.mFeaturedImageView.frame.size.height - self.mMainCategoryCollectionView.frame.size.height) / 2;
        self.mSubCategoryViewTopSpacingConstant.constant = 0;
        _isPanelMoved = YES;
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {

        }];
    }
    else{
        
        self.mInputPanelTopSpacingConstant.constant = -self.mFeaturedImageView.frame.size.height;
        self.mMainCategoryCollectionViewTopSpacingConstant.constant = (self.mFeaturedImageView.frame.size.height - self.mMainCategoryCollectionView.frame.size.height) / 2;
        self.mSubCategoryViewTopSpacingConstant.constant = 0;
        
        _isPanelMoved = YES;
       [self.view layoutIfNeeded];
    }

}

-(void) moveBackCategoryPanel:(BOOL) isAnimated Completion:(void(^)())completion
{
    if (!_isPanelMoved || self.lockMoving) {
        return;
    }

    
    if (isAnimated) {
        self.mInputPanelTopSpacingConstant.constant = 0;
        self.mMainCategoryCollectionViewTopSpacingConstant.constant = 0;
        self.mSubCategoryViewTopSpacingConstant.constant = 300;
        //self.mSubCategoryViewBottomSpacingConstant.constant = 300;
        _isPanelMoved = NO;
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if(finished && completion)
                completion();
        }];
    }
    else{
        self.mInputPanelTopSpacingConstant.constant = 0;
        self.mMainCategoryCollectionViewTopSpacingConstant.constant = 0;
        self.mSubCategoryViewTopSpacingConstant.constant = 300;
        //self.mSubCategoryViewBottomSpacingConstant.constant = 300;
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
    if (touch.view==self.view ) {
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
    [self moveBackCategoryPanel:YES Completion:nil];
}

-(void) setCategories
{
    [MyUtils shared].tempUser.mainCategory = self.selectedMainCategoryIndex;
    [MyUtils shared].tempUser.subCategories = @[@([self.mSubCategoryPickerFirst selectedRowInComponent:0]), @([self.mSubCategoryPickerSecond selectedRowInComponent:0]), @([self.mSubCategoryPickerThird selectedRowInComponent:0])];
    
    [MyUtils shared].tempUser.firstSubCategoryText = [[self.mSubCategoryArrayForFirst objectAtIndex: [[[MyUtils shared].tempUser.subCategories objectAtIndex:0] integerValue]] objectForKey:@"title"];
    [MyUtils shared].tempUser.secondSubCategoryText = [[self.mSubCategoryArrayForSecond objectAtIndex: [[[MyUtils shared].tempUser.subCategories objectAtIndex:1] integerValue]] objectForKey:@"title"];
    [MyUtils shared].tempUser.thirdSubCategoryText = [[self.mSubCategoryArrayForThird objectAtIndex: [[[MyUtils shared].tempUser.subCategories objectAtIndex:2] integerValue]] objectForKey:@"title"];
    
}
- (IBAction)onOk:(id)sender {
    
    [self setCategories];
    
    if (self.isPanelMoved) {
        [self moveBackCategoryPanel:YES Completion:^{
            [self performSegueWithIdentifier:@"ViewSecurity" sender:self];
        }];
        [self.view endEditing:YES];
    }
    else
        [self performSegueWithIdentifier:@"ViewSecurity" sender:self];
}

- (IBAction)onClickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];    
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
    [self setCategories];
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

#pragma - SubCategories
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
@end

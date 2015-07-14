//
//  TPLocalBusinessView.h
//  TravelPreneurs
//
//  Created by CGH on 1/16/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPUserViewControllerDelegate.h"
#import "User.h"
@interface TPLocalBusinessView : UIView <UICollectionViewDelegate , UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray* mUsersArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *lineSeparator;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineSeparatorHeightConstraint;
@property (strong, nonatomic) id<TPUserViewControllerDelegate> delegate;

@property (strong, nonatomic) User* user;
@property NSArray* mainCategories;
@property  TPMainCategory selectedMainCategory;
@property (strong, nonatomic) NSArray* selectedSubCategories;

@property int lastLoadedCount;
@property int lastLoadedPage;
@property int page;

-(void) initialize:(User*)user;
-(void) refresh;
@end

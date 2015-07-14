//
//  TPFavouriteTableViewCell.h
//  TravelPreneurs
//
//  Created by CGH on 1/29/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AsyncImageView.h"
@interface TPFavouriteTableViewCell : SWTableViewCell
@property (nonatomic, strong) IBOutlet AsyncImageView* avatarImageView;
@property (nonatomic, strong) IBOutlet UILabel* businessNameLabel;
@property (nonatomic, strong) IBOutlet UILabel* managerNameLabel;
@property (nonatomic, strong) IBOutlet UIButton* chatButton;
@end

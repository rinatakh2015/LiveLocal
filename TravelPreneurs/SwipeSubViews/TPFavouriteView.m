//
//  TPFavouriteView.m
//  TravelPreneurs
//
//  Created by CGH on 1/17/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPFavouriteView.h"
#import "UIButton+Custom.h"
#import "MyUtils.h"
#import "User.h"
#import "defs.h"
#import "TPFavouriteTableViewCell.h"
#import "MBProgressHUD.h"
#import "global_functions.h"
#import "APIClient.h"
#import "TPTravelerViewController.h"
#import "AppDelegate.h"
@implementation TPFavouriteView

-(void)initialize:(User*)user{
    self.user = user;
    
    self.lineSeparatorHeightConstraint.constant = 0.5;
    self.mFavouriteArray = [[NSMutableArray alloc] init];
    
    //[self sampleData];

    _lastLoadedCount = 0;
    _page = 0;
    _lastLoadedPage = -1;
    [self.tableView reloadData];
    
    [[MyUtils shared] applyTranslation:self];
    
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self loadData];

}

-(void)sampleData
{
    User* user1 = [User userFromDic:@{kUserId:@(1), kUserName:@"Tester1", kFullname:@"Matin1" , kBusinessName:@"BusinessName1", kManagerName:@"ManagerName1"}];
    User* user2 = [User userFromDic:@{kUserId:@(2), kUserName:@"Tester2", kFullname:@"Matin2" , kBusinessName:@"BusinessName2", kManagerName:@"ManagerName2"}];
    User* user3 = [User userFromDic:@{kUserId:@(3), kUserName:@"Tester3", kFullname:@"Matin3" , kBusinessName:@"BusinessName3", kManagerName:@"ManagerName3"}];
    User* user4 = [User userFromDic:@{kUserId:@(4), kUserName:@"Tester4", kFullname:@"Matin4" , kBusinessName:@"BusinessName4", kManagerName:@"ManagerName4"}];
    
    [self.mFavouriteArray addObject:user1];
    [self.mFavouriteArray addObject:user2];
    [self.mFavouriteArray addObject:user3];
    [self.mFavouriteArray addObject:user4];

}

-(void)loadData
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [APIClient getFavouriteUsers:COUNTS_PER_PAGE Page:_page completionHandler:^(NSMutableArray *passedResponse, NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:NO];
        if (!error) {
            
            //If it is already loaded data, ignore it
            if (_page <= _lastLoadedPage) {
                return;
            }
            
            if(_page == 0)
            {
                [self.mFavouriteArray removeAllObjects];
            }
            
            _lastLoadedCount = [passedResponse count];
            _lastLoadedPage = _page;
            
            if (_lastLoadedCount > 0) {
                [self.mFavouriteArray addObjectsFromArray:passedResponse];
                [self.tableView reloadData];

            }
            
        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }
    }];

}
-(void)onChatButtonClick:(id)sender
{
    UIButton* chatButton = (UIButton*)sender;
    User* user = [self.mFavouriteArray objectAtIndex:chatButton.tag ];

    self.chatViewController = [[TPChatViewController alloc] initWithUser:user];

    UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    [nav pushViewController:self.chatViewController animated:YES];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.mFavouriteArray )
        return self.mFavouriteArray.count;
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FavouriteTableViewCell";
    TPFavouriteTableViewCell *cell = (TPFavouriteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = (TPFavouriteTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"TPFavouriteTableViewCell" owner:self options:nil] objectAtIndex:0];
    }

    User* user = [self.mFavouriteArray objectAtIndex:indexPath.row];

    if (user.avatarImageURL)
        [cell.avatarImageView loadImageFromURL:[NSURL URLWithString:user.avatarImageURL]];
    else
        [cell.avatarImageView setImage:[UIImage imageNamed:@"icon_defaultavatar.png"]];
    
    [[MyUtils shared] makeCircleView:cell.avatarImageView];
    
    if (user.accountType == TPAccountType_TRAVELER) {
        if (user.fullName)
            [cell.businessNameLabel setText:user.fullName];
        else
            cell.businessNameLabel.text = @"";
        
        if (user.country) {
            [cell.managerNameLabel setText:user.country];
        }
        else
            cell.managerNameLabel.text = @"";
    }
    else{
        if (user.businessName)
            [cell.businessNameLabel setText:user.businessName];
        else
            cell.businessNameLabel.text = @"";
        
        if (user.managerName) {
            [cell.managerNameLabel setText:user.managerName];
        }
        else
            cell.managerNameLabel.text = @"";
    }

    // Red Flag for new message
    NSMutableDictionary* dic = [MyUtils shared].chatRedFlagDic;
    NSNumber* chatFlag = [dic valueForKey:[NSString stringWithFormat:@"%ld", user.identifier]];
    int flag = !chatFlag || [chatFlag integerValue] == 0 ? 0 : 1;
    if (flag) {
        [cell.chatButton setImage:[UIImage imageNamed:@"icon_chatred_big"] forState:UIControlStateNormal];
    }
    else{
        [cell.chatButton setImage:[UIImage imageNamed:@"icon_chat_gray_big"] forState:UIControlStateNormal];
    }

    [cell.chatButton setTag:indexPath.row];
    [cell.chatButton addTarget:self action:@selector(onChatButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    [cell setRightUtilityButtons:[self rightUtilityButtons] WithButtonWidth:45.0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = (id)self;
    
    
    if (indexPath.item == [self.mFavouriteArray count] -1 && _lastLoadedCount == COUNTS_PER_PAGE && _page <= _lastLoadedPage ) {
        _page++;
        [self loadData];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User* user = [self.mFavouriteArray objectAtIndex:indexPath.row];
    if (user.accountType != TPAccountType_TRAVELER) {
        TPTravelerViewController* travelerViewController =(TPTravelerViewController* )[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TPTravelerViewController"];
        travelerViewController.user = user;
        
        UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
        [nav pushViewController:travelerViewController animated:YES];
    }
}
#pragma mark - SWTableViewCell Delegate

- (NSArray *)rightUtilityButtons
{
    NSMutableArray *buttons = [NSMutableArray new];
    [buttons addObject:[UIButton tableCellDeleteButton]];
    return buttons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    User* user = [self.mFavouriteArray objectAtIndex:index];
    
    [APIClient disFavouriteUser:user.identifier completionHandler:^(NSDictionary *passedResponse, NSError *error) {
        if (!error) {
            [self.mFavouriteArray removeObjectAtIndex:index];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
                [self.tableView endUpdates];

                [[MyUtils shared].user.favouriteIds removeObject:[NSString stringWithFormat:@"%ld", user.identifier]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chatFlagChecked" object:nil];
                
            });

        }
        else{
            ShowErrorAlert(error.localizedDescription);
        }
    }];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

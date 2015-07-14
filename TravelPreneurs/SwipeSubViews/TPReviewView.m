//
//  TPReviewView.m
//  TravelPreneurs
//
//  Created by CGH on 1/16/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPReviewView.h"
#import "StarRatingControl.h"
#import "defs.h"
#import "APIClient.h"
#import "MyUtils.h"
#import "global_functions.h"
#import "MBProgressHUD.h"
#import "NSString+Translate.h"

@implementation TPReviewView
{
    int countsOfTotalReviews;
    int countsOfFiveStars;
    int countsOfFourStars;
    int countsOfThreeStars;
    int countsOfTwoStars;
    int countsOfOneStar;
}
-(void)initialize:(User*)user
{
    self.user = user;
    
    self.lineSeparatorHeightConstraint.constant = 0.5;
    self.mReviewArray = [[NSMutableArray alloc] init];

    if (self.user.identifier == [MyUtils shared].user.identifier) {
        self.writeReviewButton.hidden = YES;
    }
    else{
        self.writeReviewButton.hidden = NO;
    }
    //[self sampleData];
    
    _lastLoadedCount = 0;
    _page = 0;
    _lastLoadedPage = -1;
    
    [[MyUtils shared] applyTranslation:self];
    
    [self loadData];
    
}

int barMaximumWidth = 0;
-(void) showAnalysis
{
    if (!barMaximumWidth) {
        barMaximumWidth = self.mFiveBarView.frame.size.width ;
    }
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.mFiveCountsLabel.text = [formatter stringForObjectValue:@(countsOfFiveStars)];
    self.mFourCountsLabel.text = [formatter stringForObjectValue:@(countsOfFourStars)];
    self.mThreeCountsLabel.text = [formatter stringForObjectValue:@(countsOfThreeStars)];
    self.mTwoCountsLabel.text = [formatter stringForObjectValue:@(countsOfTwoStars)];
    self.mOneCountsLabel.text = [formatter stringForObjectValue:@(countsOfOneStar)];
    
    if (countsOfTotalReviews) {
        
        self.mTotalReviews.text = [NSString stringWithFormat:@"(%d)", countsOfTotalReviews];
        [self.mAverageRatingControl setRating:(int)round((countsOfFiveStars * 5+ countsOfFourStars * 4+ countsOfThreeStars * 3 + countsOfTwoStars * 2 + countsOfOneStar)/((float)countsOfTotalReviews))];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
        [formatter setMaximumFractionDigits:2];
        NSString *temp = [formatter stringFromNumber:[NSNumber numberWithFloat:(countsOfFiveStars * 5 + countsOfFourStars * 4 + countsOfThreeStars * 3 + countsOfTwoStars * 2 + countsOfOneStar)/((float)countsOfTotalReviews)]];
        
        self.mAverageRatingLabel.text = [NSString stringWithFormat:@"%@ / 5 %@",  temp, [@"Stars" translate]];

        
        self.mFiveBarTrailingConstant.constant = barMaximumWidth *( 1 -  (((float)countsOfFiveStars) / countsOfTotalReviews));
        self.mFourBarTrailingConstant.constant = barMaximumWidth *( 1 -  (((float)countsOfFourStars) / countsOfTotalReviews));
        self.mThreeBarTrailingConstant.constant = barMaximumWidth *( 1 -  (((float)countsOfThreeStars) / countsOfTotalReviews));
        self.mTwoBarTrailingConstant.constant = barMaximumWidth *( 1 -  (((float)countsOfTwoStars) / countsOfTotalReviews));
        self.mOneBarTrailingConstant.constant = barMaximumWidth *( 1 -  (((float)countsOfOneStar) / countsOfTotalReviews));
        [self layoutIfNeeded];

    }
    else{
        [self.mAverageRatingControl setRating:0];
        self.mTotalReviews.text = @"(0)";
        self.mAverageRatingLabel.text = [NSString stringWithFormat:@"0 / 5 %@", [@"Stars" translate] ];
        self.mFiveBarTrailingConstant.constant = barMaximumWidth;//self.mFiveBarView.frame.size.width ;
        self.mFourBarTrailingConstant.constant = barMaximumWidth;//self.mFourBarView.frame.size.width ;
        self.mThreeBarTrailingConstant.constant = barMaximumWidth;//self.mThreeBarView.frame.size.width ;
        self.mTwoBarTrailingConstant.constant = barMaximumWidth;//self.mTwoBarView.frame.size.width ;
        self.mOneBarTrailingConstant.constant = barMaximumWidth;//self.mOneBarView.frame.size.width ;
        [self layoutIfNeeded];
    }
}


-(void)loadData
{
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [APIClient getUserReviews:self.user.identifier Count:COUNTS_PER_PAGE Page:_page completionHandler:^(NSDictionary *passedResponse, NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:NO];
        if (!error) {
            
            countsOfTotalReviews = [[passedResponse objectForKey:kTotalReviews] integerValue];
            countsOfFiveStars = [[passedResponse objectForKey:kCountsOfFiveStars] integerValue];
            countsOfFourStars = [[passedResponse objectForKey:kCountsOfFourStars] integerValue];
            countsOfThreeStars = [[passedResponse objectForKey:kCountsOfThreeStars] integerValue];
            countsOfTwoStars = [[passedResponse objectForKey:kCountsOfTwoStars] integerValue];
            countsOfOneStar = [[passedResponse objectForKey:kCountsOfOneStar] integerValue];

            NSArray* data = [passedResponse objectForKey:kData];
            //If it is already loaded data, ignore it
            if (_page <= _lastLoadedPage) {
                return;
            }
            
            if(_page == 0)
            {
                [self.mReviewArray removeAllObjects];
            }
            
            _lastLoadedCount = [data count];
            _lastLoadedPage = _page;
            
            if (_lastLoadedCount > 0) {
                [self.mReviewArray addObjectsFromArray:data];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAnalysis];
                [self.tableView reloadData];
            });
            
        }
        else{
            ShowErrorAlert([error localizedDescription]);
        }

    }];
}


- (IBAction)onClickWriteReview:(id)sender {

    self.reviewWriteViewController = [[TPReviewWriteViewController alloc] initWithUser:self.user];
    UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    [nav pushViewController:self.reviewWriteViewController animated:YES];
    
}

-(CGSize) getSizeOfLabelForGivenText:(NSString*)text Font:(UIFont*)fontForLabel Size:  (CGSize) constraintSize{
    CGRect labelRect = [text boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:fontForLabel} context:nil];
    return (labelRect.size);
}

#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.mReviewArray) {
        return self.mReviewArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = (NSDictionary*)[self.mReviewArray objectAtIndex:indexPath.row];
    NSString* text = [NSString stringWithFormat:@"                        %@", [dic objectForKey:@"text"]];
    CGSize size = CGSizeMake(self.tableView.frame.size.width - 30, 9999);
    int height = [self getSizeOfLabelForGivenText:text Font:[UIFont fontWithName:@"Helvetica Neue" size:14] Size:size].height + 10;
    return height <= 55 ? 55 : height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReviewTableViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = (UITableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"TPReviewTableViewCell" owner:self options:nil] objectAtIndex:0];
    }

    NSDictionary* dic = (NSDictionary*)[self.mReviewArray objectAtIndex:indexPath.row];
    int stars = [[dic objectForKey:kRating] integerValue];
    NSString* text = [dic objectForKey:kText];
    
    UITextView* textView = (UITextView*) [cell viewWithTag:1];
    StarRatingControl* ratingControl = (StarRatingControl*) [cell viewWithTag:2];
    
    textView.text = [NSString stringWithFormat:@"                       %@", text];
    [textView setContentInset:UIEdgeInsetsZero];
    [ratingControl setRating:stars];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.item == [self.mReviewArray count] -1 && _lastLoadedCount == COUNTS_PER_PAGE && _page <= _lastLoadedPage ) {
        _page++;
        [self loadData];
    }
    
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

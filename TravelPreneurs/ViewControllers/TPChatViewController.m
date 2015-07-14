//
//  TPChatViewController.m
//  TravelPreneurs
//
//  Created by CGH on 1/18/15.
//  Copyright (c) 2015 Jay. All rights reserved.
//

#import "TPChatViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSDate+Custom.h"
#import "NSString+Custom.h"

#import "MyUtils.h"
#import "AppDelegate.h"
#import "defs.h"
#import "global_functions.h"
#import "SMMessageViewTableCell.h"

#define IncomingMessageTableViewCell @"IncomingMessageTableViewCell"
#define OutgoingMessageTableViewCell @"OutgoingMessageTableViewCell"

@interface TPChatViewController ()
@end

@implementation TPChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MyUtils shared] makeCircleViewWithBorder:self.userAvatarImageView BorderWidth:1 BorderColor:[UIColor blackColor]];
    [[MyUtils shared] makeCircleViewWithBorder:self.myAvatarImageView BorderWidth:1 BorderColor:[UIColor blackColor]];
    
    self.lineSeparatorHeightConstraint.constant = 0.5;
    self.bottomLineSeparatorHeightConstraint.constant = 0.5;
    [self initialize];
    
    [self registerForKeyboardNotifications];
    
    //[AppDelegateAccessor createGroup:[[MyUtils shared] getChattingRoomIdentifierWith:self.user.identifier] invites:nil];
    
    self.pklChatGroup = [[PKLChatGroup alloc] init];
    self.pklChatGroup.identifier = [[MyUtils shared] getChattingRoomIdentifierWith:self.user.identifier];
    self.pklChatGroup.name = [[MyUtils shared] getChattingRoomIdentifierWith:self.user.identifier];

    if (![[MyUtils shared].chatMessages objectForKey:[[MyUtils shared] getChattingRoomIdentifierWith:self.user.identifier]]) {
        messages = [[NSMutableArray alloc ] init];
        [[MyUtils shared].chatMessages setObject:messages forKey:[[MyUtils shared] getChattingRoomIdentifierWith:self.user.identifier]];
    }
    else
    {
        messages = [[MyUtils shared].chatMessages objectForKey:[[MyUtils shared] getChattingRoomIdentifierWith:self.user.identifier]];
        [self.tableView reloadData];
        
        if (messages.count > 0) {
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
                                                           inSection:0];
            [self.tableView scrollToRowAtIndexPath:topIndexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle
                                          animated:YES];
        }
        
    }
    
    [[MyUtils shared].chatRedFlagDic setValue:@(0) forKey:[NSString stringWithFormat:@"%ld", self.user.identifier]];
    [self postChatFlagCheckedNofification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:@"newMessageReceived" object:nil];
    
    [[MyUtils shared] applyTranslation:self.view];
    [self.tableView registerNib:[UINib nibWithNibName:IncomingMessageTableViewCell bundle:nil] forCellReuseIdentifier:IncomingMessageTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:OutgoingMessageTableViewCell bundle:nil] forCellReuseIdentifier:OutgoingMessageTableViewCell];
}

-(id)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

-(void) initialize
{
    mediaPicker = nil;
    
    if (self.user) {
        if(self.user.accountType == TPAccountType_TRAVELER)
            self.userNameLabel.text = self.user.fullName;
        else
            self.userNameLabel.text = self.user.managerName;
        
        if (self.user.avatarImageURL) {
            [self.userAvatarImageView loadImageFromURL:[NSURL URLWithString:self.user.avatarImageURL]];
        }
        else
        {
            //[self.userAvatarImageView setImage:[UIImage imageNamed:@"icon_useravatar_black"]];
            [self.userAvatarImageView setImage:[UIImage imageNamed:@"icon_defaultavatar"]];
        }
    }
    
    if ([MyUtils shared].user.avatarImageURL) {
        [self.myAvatarImageView loadImageFromURL:[NSURL URLWithString:[MyUtils shared].user.avatarImageURL]];
    }
    else{
        //[self.myAvatarImageView setImage:[UIImage imageNamed:@"icon_useravatar_black"]];
        [self.myAvatarImageView setImage:[UIImage imageNamed:@"icon_defaultavatar"]];
    }
    
    [self.view layoutIfNeeded];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickBack:(id)sender {
    UINavigationController* nav = (UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    [nav popViewControllerAnimated:YES];
}

-(void) postChatFlagCheckedNofification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chatFlagChecked" object:self.pklChatGroup.identifier];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillDisappear:(BOOL)animated
{
     // save last time
    if (messages.count > 0) {
        NSDictionary *lastMessage = [messages objectAtIndex:messages.count - 1];
        NSString *time = [lastMessage valueForKey:@"time"];
        NSString *key;
        
        key = [NSString stringWithFormat:@"%ld_Group_%@", [MyUtils shared].user.identifier, self.pklChatGroup.identifier];
        [self.pklChatGroup.unreadMessages removeAllObjects];
        
        [[NSUserDefaults standardUserDefaults] setObject:time forKey:key];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupListChanged" object:nil];
        
    }
    
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
- (IBAction)onClickSend:(id)sender {
    
    NSString *messageStr = [_messageField text];
    
    if (messageStr == nil ||
        [[messageStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        return;
    }
    
    if([messageStr length] > 0) {
        
        // send
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        
        NSXMLElement *groupid = [NSXMLElement elementWithName:@"GroupId"];
        [groupid setStringValue:self.pklChatGroup.identifier];
        
        NSXMLElement *mType = [NSXMLElement elementWithName:@"messageType"];
        [mType setStringValue:PKL_MESSAGE_TYPE_TEXT];
 
        XMPPMessage* xmppMessage = [XMPPMessage message];
        NSXMLElement *x = [NSXMLElement elementWithName:@"groupchat" xmlns:XMPPMUCNamespace];
        [xmppMessage addAttributeWithName:@"type" stringValue:@"groupchat"];
        [xmppMessage addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@", self.pklChatGroup.identifier, [NSString stringWithFormat: @"conference.%@", PKL_XMPP_DOMAIN_NAME] ]];
        [xmppMessage addChild:body];
        [xmppMessage addChild:groupid];
        [xmppMessage addChild:mType];
        [xmppMessage addChild:x];
        
        if (!AppDelegateAccessor.xmppChatRoom) {
            return;
        }
        
        [AppDelegateAccessor.xmppChatRoom sendMessage:xmppMessage];
        
        
        // initialize
        self.messageField.text = @"";
        self.mMessageContainerHeightConstraint.constant = 37;
        [self.view layoutIfNeeded];

    }
    
    if (messages.count > 0) {
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
                                                       inSection:0];
        [self.tableView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }
    
    [_messageField resignFirstResponder];
}

#pragma mark - photo uploading
- (IBAction)onClickTakePhoto:(id)sender {
    
    //camera setting
    mediaPicker = [UIImagePickerController new];
    [mediaPicker setDelegate:self];
    mediaPicker.allowsEditing = YES;
    
    [self takePhoto];
}

/**************************Photo Take*****************************************/
- (void)takePhoto {
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString( @"Cancel", nil )
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString( @"Take photo", nil ), NSLocalizedString( @"Choose from Library", nil ), nil];
        [actionSheet setTag:1000];
        [actionSheet showInView:self.view];
        
    } else {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        mediaPicker.mediaTypes = @[(NSString *) kUTTypeImage];
        [viewCamera presentViewController:mediaPicker animated:YES completion:nil];
    }
    
}


#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if (buttonIndex == 1) {
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    
    [self performSelector:@selector(showCamera) withObject:nil afterDelay:0.3];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if (buttonIndex == 1) {
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    else{
        actionSheet.hidden = YES;
        return;
    }
    
    [self performSelector:@selector(showCamera) withObject:nil];
    
}

-(void) showCamera{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:mediaPicker animated:YES completion:nil];
    }];
    
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    /*chosenImage = [chosenImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(PHOTO_WIDTH, PHOTO_HEIGHT) interpolationQuality:100];*/
    
    //save photo to file.
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *fileName = PHOTO_FILE_NAME;
    NSString *filePath = [documentsPath stringByAppendingPathComponent: fileName]; //Add the file name
    
    //[_m_AvatarImageView setImage:chosenImage];
    //Write the file
    if ([pngData writeToFile:filePath atomically:YES]) {
    }
    else{
        ShowErrorAlert(NSLocalizedString( @"Can not save photo", nil ));
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self onUpload];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*************************Photo File Upload onto Server*********************************************/
- (void) onUpload {
    
    
    
    [self sendFilenameViaXMPP:@"test.png"];
    [self performSelectorOnMainThread:@selector(postUploadImage) withObject:nil waitUntilDone:NO];
    /*
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     NSArray *dirPaths;
     NSString *docsDir;
     dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     docsDir = [dirPaths objectAtIndex:0];
     NSString *photoFilePath = [docsDir stringByAppendingPathComponent:PHOTO_FILE_NAME];
     NSData* photoData = [NSData dataWithContentsOfFile:photoFilePath];
     
     if (photoData) {
     NSString *    photoFilename = [self uploadPhotoFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] withData:photoData];
     
     [self sendFilenameViaXMPP:photoFilename];
     [self performSelectorOnMainThread:@selector(postUploadImage) withObject:nil waitUntilDone:NO];
     
     }
     
     });
     
     */
}

- (void)postUploadImage {
    [self.tableView reloadData];
    
    if (messages.count > 0) {
        NSInteger count = messages.count;
        
        self.pklChatGroup.lastMsgReceivedUsername = @"you";
        
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:count - 1
                                                       inSection:0];
        [self.tableView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }
}

- (void)sendFilenameViaXMPP:(NSString *)filename {
  
    // send
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:filename];
    
    NSXMLElement *groupid = [NSXMLElement elementWithName:@"GroupId"];
    [groupid setStringValue:self.pklChatGroup.identifier];
    
    NSXMLElement *mType = [NSXMLElement elementWithName:@"messageType"];
    [mType setStringValue:PKL_MESSAGE_TYPE_PHOTO];
    
    
    XMPPMessage* xmppMessage = [XMPPMessage message];
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"groupchat" xmlns:XMPPMUCNamespace];
    [xmppMessage addAttributeWithName:@"type" stringValue:@"groupchat"];
    [xmppMessage addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@", self.pklChatGroup.identifier, [NSString stringWithFormat: @"conference.%@", PKL_XMPP_DOMAIN_NAME] ]];
    [xmppMessage addChild:body];
    [xmppMessage addChild:groupid];
    [xmppMessage addChild:mType];
    [xmppMessage addChild:x];
    
    [AppDelegateAccessor.xmppChatRoom sendMessage:xmppMessage];
    
    // add message to list
    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    [m setObject:filename forKey:@"msg"];
    [m setObject:PKL_MESSAGE_TYPE_PHOTO forKey:@"type"];
    [m setObject:@"you" forKey:@"sender"];
    [m setObject:[NSDate getCurrentTime] forKey:@"time"];
    [messages addObject:m];
    
    //[[LyphyNetworkClient sharedInstance] saveGroupImage:chatViewController.group.gid filename:filename];
    
}



#pragma mark - UIKeyboard events
// Called when UIKeyboardWillShowNotification is sent
- (void)keyboardWillShown:(NSNotification*)notification
{
    
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardFrameInWindow;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameInWindow];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    
    _mMessageContainerBottomVerticalSpace.constant += keyboardFrameInWindow.size.height;
    
    [UIView commitAnimations];
    
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardFrameInWindow;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameInWindow];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    
    _mMessageContainerBottomVerticalSpace.constant -= keyboardFrameInWindow.size.height;
    _messageField.text = @"";
    _mMessageContainerHeightConstraint.constant = 49;
    
    [UIView commitAnimations];
}


#pragma mark TextView delegate method

- (CGFloat)measureHeight
{
    if ([self.messageField respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        return ceilf([self.messageField sizeThatFits:self.messageField.frame.size].height);
    }
    else {
        return self.messageField.contentSize.height;
    }
    
}


- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    float messageFieldHeight = [self measureHeight];
    
    if (messageFieldHeight > 115)
        messageFieldHeight = 115;
    
    if (messageFieldHeight - _messageField.frame.size.height > 15) {
        _mMessageContainerHeightConstraint.constant +=  messageFieldHeight - _messageField.frame.size.height;
    }
    
    
    
}


/*************************XMPP**************************/

- (void)addChatHistory:(id)sender {
    NSMutableArray *chatHistoryArray = (NSMutableArray *)sender;
    
    if (chatHistoryArray.count > 0) {
        int num_rows = [chatHistoryArray count];
        for (int i = 0; i < num_rows; i++) {
            [messages addObject:[chatHistoryArray objectAtIndex:i]];
        }
        
        [self.tableView reloadData];
        
        if (messages.count > 0) {
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
                                                           inSection:0];
            [self.tableView scrollToRowAtIndexPath:topIndexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle
                                          animated:YES];
        }
    }
}


- (void) reloadAllData {
    [messages removeAllObjects];
    
    /*
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     NSMutableArray *chatHistoryArray;
     chatHistoryArray = [[LyphyNetworkClient sharedInstance] getGroupChatHistoryWithSender:[LyphySettings sharedInstance].userName groupid:self.group.gid];
     
     [self performSelectorOnMainThread:@selector(addChatHistory:) withObject:chatHistoryArray waitUntilDone:NO];
     
     LyphyPhotoUploadViewController *photoUploadViewController = (LyphyPhotoUploadViewController *)self.revealViewController.rearViewController;
     [photoUploadViewController getAllImages];
     });
     */
}


#pragma mark - Chat delegates

- (void)newMessageReceived:(NSNotification *)note {
    
    UINavigationController* nav = (UINavigationController*)[AppDelegateAccessor window].rootViewController;
    if (self == [nav topViewController]) {
        [[MyUtils shared].chatRedFlagDic setValue:@(0) forKey:[NSString stringWithFormat:@"%ld", self.user.identifier]];
        [self postChatFlagCheckedNofification];
    }
    
    NSMutableDictionary *messageContent = [note object];
    NSString *sender = [messageContent objectForKey:@"sender"];
    NSString *groupid = [messageContent objectForKey:@"groupid"];
    NSString *chatType = [messageContent objectForKey:@"type"];
    NSString *messageType = [messageContent objectForKey:@"messageType"];

    NSMutableDictionary* dd = [MyUtils shared].chatRedFlagDic;
    
    if (![chatType isEqualToString:@"groupchat"] || ![groupid isEqualToString:self.pklChatGroup.identifier]) {
        return;
    }
    
    
    /*NSString *m = [messageContent objectForKey:@"msg"];
    [messageContent setObject:m forKey:@"msg"];
    [messageContent setObject:messageType forKey:@"type"];
    [messageContent setObject:[NSDate getCurrentTime] forKey:@"time"];
    [messages addObject:messageContent];*/
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        if (messages.count > 0) {
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
                                                           inSection:0];
            [self.tableView scrollToRowAtIndexPath:topIndexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle
                                          animated:YES];
        }

    });
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.messageField resignFirstResponder];
}

#pragma mark - UITableView Deleagate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *s = (NSDictionary *) [messages objectAtIndex:indexPath.row];
    
    NSString *message = [s objectForKey:@"msg"];
    NSString *time = [s objectForKey:@"time"];
    NSString *msgType = [s objectForKey:@"messageType"];

    time = [NSDate getLocaleTimeStr:time];

    CGSize  textSize = { 200, 10000.0 };
    /*CGSize size = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]
                      constrainedToSize:textSize
                          lineBreakMode:NSLineBreakByWordWrapping];*/
    
    UIFont *fontText = [UIFont fontWithName:@"Helvetica" size:18];
    
    CGRect rect = [message boundingRectWithSize:textSize
                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                               attributes:@{NSFontAttributeName:fontText}
                                  context:nil];
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[vComp objectAtIndex:0] intValue] >= 7) {
        rect.size.height = rect.size.height + 20;
    }
    
    rect.size.height += 50;
    
    CGFloat height = rect.size.height;

    return height;

    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *s = (NSDictionary *) [messages objectAtIndex:indexPath.row];
    
    NSString *sender = [s objectForKey:@"sender"];
    NSString *message = [s objectForKey:@"msg"];
    NSString *time = [s objectForKey:@"time"];
    NSString *msgType = [s objectForKey:@"messageType"];
    NSString *type = [s objectForKey:@"type"];
    time = [NSDate getLocaleTimeStr:time];
    
    UITableViewCell * cell;
    
    if ([sender isEqualToString:[NSString stringWithFormat:@"%ld", [MyUtils shared].user.identifier]])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:OutgoingMessageTableViewCell];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:IncomingMessageTableViewCell];
    }
    
    UILabel* messageLabel = (UILabel*)[cell viewWithTag:1];
    UILabel* timeLabel = (UILabel*)[cell viewWithTag:2];
    
    [messageLabel setText:message];
    [timeLabel setText:time];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /*static NSString *CellIdentifier = @"MessageCellIdentifier";
    
    SMMessageViewTableCell *cell = (SMMessageViewTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SMMessageViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.bgImageView setImage:nil];
    [cell.bgImageView setHidden:NO];
    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@", time];
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];

    
    if ([msgType isEqualToString:PKL_MESSAGE_TYPE_TEXT]) {
        
        CGSize  textSize = { 200, 10000.0 };
        CGSize size = [message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0]
                          constrainedToSize:textSize
                              lineBreakMode:NSLineBreakByWordWrapping];
        
        size.width += (padding/2);
        
        [cell.photoImageView setHidden:YES];
        [cell.messageContentView setHidden:NO];
        
        cell.messageContentView.text = message;
        [cell.messageContentView setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *bgImage = nil;
        
        
        if ([sender isEqualToString:[NSString stringWithFormat:@"%ld", [MyUtils shared].user.identifier]]) { // right aligned
            cell.messageContentView.textColor = [UIColor whiteColor];
            cell.senderAndTimeLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
            if ([[vComp objectAtIndex:0] intValue] >= 7) {
                [cell.messageContentView setFrame:CGRectMake(cell.frame.size.width - padding - 200,
                                                             additionalPadding,
                                                             200,
                                                             size.height + 25)];
                
                CGRect tmpRect = cell.messageContentView.frame;
                [cell.messageContentView setFrame:tmpRect];
                [cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
                                                      cell.messageContentView.frame.origin.y - padding/2,
                                                      200 + padding,
                                                      size.height + padding + 30 + 10)];
            }
            else{
                [cell.messageContentView setFrame:CGRectMake(cell.frame.size.width - padding - 200,
                                                             padding+10,
                                                             200,
                                                             size.height + 25)];
                CGRect tmpRect = cell.messageContentView.frame;
                [cell.messageContentView setFrame:tmpRect];
                [cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
                                                      cell.messageContentView.frame.origin.y - padding/2,
                                                      200 + padding,
                                                      size.height + padding + 30  + 10)];
            }
            
            CGRect frame = CGRectMake(cell.messageContentView.frame.origin.x + 5, cell.messageContentView.frame.origin.y + cell.messageContentView.frame.size.height, cell.messageContentView.frame.size.width - 10, 20);
            cell.senderAndTimeLabel.frame = frame;
            
            bgImage = [[UIImage imageNamed:@"outcomming_message_bg"] resizableImageWithCapInsets: UIEdgeInsetsMake(20, 20,cell.bgImageView.frame.size.width - 40, cell.bgImageView.frame.size.height - 40)];
            
        } else {
            cell.messageContentView.textColor = [UIColor blackColor];
            cell.senderAndTimeLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            if ([[vComp objectAtIndex:0] intValue] >= 7) {
                // iOS-7 code[current] or greater
                [cell.messageContentView setFrame:CGRectMake(padding, additionalPadding, 200, size.height + 25)];
                CGRect tmpRect = cell.messageContentView.frame;
                [cell.messageContentView setFrame:tmpRect];
                [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                                                      cell.messageContentView.frame.origin.y - padding/2,
                                                      200 + padding,
                                                      size.height + padding + 30)];
            } else {
                [cell.messageContentView setFrame:CGRectMake(padding, additionalPadding, 200, size.height + 25)];
                CGRect tmpRect = cell.messageContentView.frame;
                [cell.messageContentView setFrame:tmpRect];
                [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                                                      cell.messageContentView.frame.origin.y - padding/2,
                                                      200+padding,
                                                      size.height + padding + 30)];
            }
            
            CGRect frame = CGRectMake(cell.messageContentView.frame.origin.x + 5, cell.messageContentView.frame.origin.y + cell.messageContentView.frame.size.height, cell.messageContentView.frame.size.width - 10, 20);
            cell.senderAndTimeLabel.frame = frame;
            
            bgImage = [[UIImage imageNamed:@"incomming_message_bg"] resizableImageWithCapInsets: UIEdgeInsetsMake(20 , 20,cell.bgImageView.frame.size.width - 40, cell.bgImageView.frame.size.height - 40)];
        }
        
        cell.bgImageView.image = bgImage;
        
        
    }*/
    
    return cell;
}

@end

//
//  ChatVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 25/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ChatVC_Old.h"
#import "ContentManager.h"
#import "Message.h"
#import "CustonTabBarController.h"
#import "AppHelper.h"
#import "Defines.h"
#import "AppDelegate.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "ProactiveLiving-Swift.h"

@interface ChatVC_Old ()
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@end

@implementation ChatVC_Old
{
    CustonTabBarController *bottomBar;
    NSTimer* theTimer;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    ChatListVC *vc=[ChatListVC new];
    [vc viewDidLoad];
    // Do any additional setup after loading the view.
    [self.screenTitle setText:[self.partnerDict[@"userDetails"] objectForKey:@"firstName"]];
    //self.myImage      = [UIImage imageNamed:@"drev.jpg"];
    //self.partnerImage = [UIImage imageNamed:@"me.jpg"];
    
    //My image from server
    //http://im.rediff.com/news/2015/dec/24tpoty20.jpg
    NSURLRequest *req1=[NSURLRequest requestWithURL:[NSURL URLWithString:[AppHelper userDefaultsForKey:uImage]]];
    AFHTTPRequestOperation *requestOperation1 = [[AFHTTPRequestOperation alloc] initWithRequest:req1];
    requestOperation1.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.myImage  = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        self.myImage = [UIImage imageNamed:@"ic_booking_profilepic"];
    }];
    [requestOperation1 start];
    
    //Partner's image from server
    NSURLRequest *req2=[NSURLRequest requestWithURL:[NSURL URLWithString:[self.partnerDict[@"userDetails"] objectForKey:@"imgUrl"]]];
    AFHTTPRequestOperation *requestOperation2 = [[AFHTTPRequestOperation alloc] initWithRequest:req2];
    requestOperation2.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.partnerImage = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        self.partnerImage = [UIImage imageNamed:@"ic_booking_profilepic"];
    }];
    [requestOperation2 start];
    
    [self getMessagesFromServer];
    
    theTimer=[NSTimer scheduledTimerWithTimeInterval:12.0
                                     target:self
                                   selector:@selector(handleTimer:)
                                   userInfo:@{@"parameter1": @9}
                                    repeats:YES];
    
    bottomBar=(CustonTabBarController *)self.tabBarController;

}



- (void)handleTimer:(NSTimer *)timer {
    //NSInteger parameter1 = [[[timer userInfo] objectForKey:@"parameter1"] integerValue];
    
    //push message to server
    [self refreshMessageWithReceiver:[self.partnerDict[@"userDetails"] valueForKey:@"mobilePhone"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [bottomBar setTabBarVisible:NO animated:YES completion:^(BOOL finished) {
        NSLog(@"finished chat old vc ");
    }];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //invalidate timer
    [theTimer invalidate];
    
    [bottomBar setTabBarVisible:YES animated:YES completion:^(BOOL finished) {
        NSLog(@"finished");
    }];
}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the light color of status bar
    return UIStatusBarStyleLightContent;
}


#pragma mark- service calls
-(void)getMessagesFromServer{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        //[parameters setObject:@"9645454545" forKey:@"senderPhone"];
        [parameters setObject:[AppHelper userDefaultsForKey:cellNum] forKey:@"senderPhone"];
        [parameters setObject:[self.partnerDict[@"userDetails"] valueForKey:@"mobilePhone"] forKey:@"recieverPhone"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceGetMessages withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     //reverse chat array
                     NSArray* reversedChatArray = [[[responseDict objectForKey:@"result"] reverseObjectEnumerator] allObjects];
                     [self loadMessagesWithResponse:reversedChatArray];
                 }
                 else
                 {
                     [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                 }
                 
             }
             else
                 [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             
         } failure:^(NSError *error)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         }];
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}

-(void)sendMessage:(NSString *)message toReceiver:(NSString *) reveiver{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        //[AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        [parameters setObject:[AppHelper userDefaultsForKey:cellNum] forKey:@"senderPhone"];
        [parameters setObject:reveiver forKey:@"recieverPhone"];
        [parameters setObject:message forKey:@"text"];
        
        //call global web service class
        [Services serviceCallWithPath:ServiceSendMessage withParam:parameters success:^(NSDictionary *responseDict)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     /*
                     for (NSDictionary *msg in [responseDict objectForKey:@"result"]) {
                         Message *msgObj = [[Message alloc] init];
                         msgObj.text = msg[@"text"];
                         msgObj.fromMe = NO;
                         msgObj.dateString=msg[@"createdDate"];
                         [self receiveMessage:msgObj];
                     }*/
                 }
                 else
                 {
                     [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                 }
                 
             }
             else
                 [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             
         } failure:^(NSError *error)
         {
             [AppDelegate dismissProgressHUD];//dissmiss indicator
             [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         }];
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}


-(void)refreshMessageWithReceiver:(NSString *) reveiver{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        //[AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        for (Message *lastMsg in self.dataSource.reverseObjectEnumerator) {
            
            if(!lastMsg.fromMe)
            {
                NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
                [parameters setValue:AppKey forKey:@"AppKey"];
                [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
                [parameters setObject:[AppHelper userDefaultsForKey:cellNum] forKey:@"senderPhone"];
                [parameters setObject:reveiver forKey:@"recieverPhone"];
                [parameters setObject:lastMsg.dateString forKey:@"refreshDate"];
                //call global web service class
                [Services serviceCallWithPath:ServiceRefreshMessages withParam:parameters success:^(NSDictionary *responseDict)
                 {
                     [AppDelegate dismissProgressHUD];//dissmiss indicator
                     
                     if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
                     {
                         if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                             
                             //[self loadMessagesWithResponse:[responseDict objectForKey:@"result"]];
                             
                             for (NSDictionary *msg in [responseDict objectForKey:@"result"]) {
                                 Message *msgObj = [[Message alloc] init];
                                 msgObj.text = msg[@"text"];
                                 msgObj.fromMe = NO;
                                 msgObj.dateString=msg[@"createdDate"];
                                 [self receiveMessage:msgObj];
                             }
                         }
                         else
                         {
                             [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                         }
                         
                     }
                     else
                         [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
                     
                 } failure:^(NSError *error)
                 {
                     [AppDelegate dismissProgressHUD];//dissmiss indicator
                     [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
                 }];
                
                return;
            }
           
            }
        }
        else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
    
}

- (void)loadMessagesWithResponse:(NSArray *)data
{
    self.dataSource = [[[ContentManager sharedManager] generateConversationWithArray:data] mutableCopy];
    [self refreshMessages];
}

#pragma mark - SOMessaging data source
- (NSMutableArray *)messages
{
    return self.dataSource;
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    // Return 0 for disableing grouping
    return (24/24 * 60 * 60);
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    Message *message = self.dataSource[index];
    
    // Adjusting content for 3pt. (In this demo the width of bubble's tail is 3pt)
    if (!message.fromMe) {
        cell.contentInsets = UIEdgeInsetsMake(0, 3.0f, 0, 0); //Move content for 3 pt. to right
        cell.textView.textColor = [UIColor blackColor];
    } else {
        cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 3.0f); //Move content for 3 pt. to left
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.userImageView.layer.cornerRadius = self.userImageSize.width/2;
    
    // Fix user image position on top or bottom.
    cell.userImageView.autoresizingMask = message.fromMe ? UIViewAutoresizingFlexibleTopMargin : UIViewAutoresizingFlexibleBottomMargin;
    
    // Setting user images
    cell.userImage = message.fromMe ? self.myImage : self.partnerImage;
    
    [self generateUsernameLabelForCell:cell];
}

- (void)generateUsernameLabelForCell:(SOMessageCell *)cell
{
    static NSInteger labelTag = 666;
    
    Message *message = (Message *)cell.message;
    UILabel *label = (UILabel *)[cell.containerView viewWithTag:labelTag];
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:8];
        label.textColor = [UIColor grayColor];
        label.tag = labelTag;
        [cell.containerView addSubview:label];
    }
    label.text = message.fromMe ? @"Me" : [self.partnerDict[@"userDetails"] objectForKey:@"firstName"];
    [label sizeToFit];
    
    CGRect frame = label.frame;
    
    CGFloat topMargin = 2.0f;
    if (message.fromMe) {
        frame.origin.x = cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width/2 - frame.size.width/2;
        frame.origin.y = cell.containerView.frame.size.height + topMargin;
        
    } else {
        frame.origin.x = cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width/2 - frame.size.width/2;
        frame.origin.y = cell.userImageView.frame.origin.y + cell.userImageView.frame.size.height + topMargin;
    }
    label.frame = frame;
}

- (CGFloat)messageMaxWidth
{
    return 140;
}

- (CGSize)userImageSize
{
    return CGSizeMake(40, 40);
}

- (CGFloat)messageMinHeight
{
    return 0;
}

#pragma mark - SOMessaging delegate

- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
    // Show selected media in fullscreen
    [super didSelectMedia:media inMessageCell:cell];
}

- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    
    [self sendMessage:msg];
    //push message to server
    [self sendMessage:message toReceiver:[self.partnerDict[@"userDetails"] valueForKey:@"mobilePhone"]];
}

- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
    Message *msg = [[Message alloc] init];
    msg.text = @"aSKSAKJKJKASKJKSJAJKLDSJKLDJSLJKL";
    msg.type=SOMessageTypePhoto;
    UIImage *image=[UIImage imageNamed:@"bubble"];
    NSData* imageData = UIImagePNGRepresentation(image); // PNG conversion
    msg.media=imageData;
    msg.fromMe = YES;
    
    //[self sendMessage:msg];
    //TODO-push message to server
}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

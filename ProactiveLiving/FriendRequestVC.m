//
//  FriendRequestVC.m
//  ProactiveLiving
//
//  Created by Affle on 30/01/2017.
//  Copyright © 2017 appstudioz. All rights reserved.
//

#import "FriendRequestVC.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "AppHelper.h"
#import "UIImageView+WebCache.h"
#import "ProactiveLiving-Swift.h"

@interface FriendRequestVC ()

@end

@implementation FriendRequestVC{
    
    NSMutableArray *requestArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getAllRequestAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onClickAcceptBtn:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    [self acceptOrIgnoreAPI:YES indexPath:indexPath];
    
}



- (IBAction)onClickIgnoreBtn:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    [self acceptOrIgnoreAPI:NO indexPath:indexPath];
}





#pragma mark- service calls
-(void)getAllRequestAPI{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"userId"];
        
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        [Services postRequest:ServiceGetAllRequest parameters:parameters completionHandler:^(NSString *error, NSDictionary *responseDict) {
            
            [AppDelegate dismissProgressHUD];//dissmiss indicator
            
            if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
            {
                if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                    requestArr = [[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"result"]];
                    
                    [self.tableView reloadData];
                }
                else
                {
                    [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                }
                
            }
            else
                [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
            
            
        }];
        
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}


-(void)acceptOrIgnoreAPI:(Boolean)isAccept indexPath:(NSIndexPath *)indexPath{
    
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"userId"];
        
        [parameters setValue:[[requestArr objectAtIndex:indexPath.row][@"friendId"] valueForKey:@"_id"] forKey:@"friendId"];
        
        
        if (isAccept) {
            [parameters setValue:[NSNumber numberWithInt:1] forKey:@"status"];
        }else
            [parameters setValue:[NSNumber numberWithInt:2] forKey:@"status"];
        
        [AppDelegate showProgressHUDWithStatus:@"Please wait.."];
        
        [Services postRequest:ServiceFriendRequestAction parameters:parameters completionHandler:^(NSString *error, NSDictionary *responseDict) {
            
            [AppDelegate dismissProgressHUD];//dissmiss indicator
            
            if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
            {
                if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                   // requestArr = [responseDict objectForKey:@"result"];
                    
                    [requestArr  removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                    
                    if (isAccept) {
                        [AppHelper showAlertWithTitle:AppName message:@"Friend request is accepted." tag:0 delegate:nil cancelButton:ok otherButton:nil];
                    }else{
                        
                        [AppHelper showAlertWithTitle:AppName message:@"Friend request is declined." tag:0 delegate:nil cancelButton:ok otherButton:nil];
                        
                    }
                    
                }
                else
                {
                    [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                }
                
            }
            else
                [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
            
            
        }];
        
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}



-(void)goToProfilePage:(NSString *) userId{
    
    ProfileContainerVC *PFVC = [[AppHelper getProfileStoryBoard] instantiateViewControllerWithIdentifier:@"ProfileContainerVC"];
    PFVC.viewerUserID = userId;
    
    
    [self.navigationController pushViewController:PFVC animated:false];
    
}



- (void)tapGestureTapProfileIcon:(UITapGestureRecognizer *)sender {
    
    CGPoint location = [sender locationInView:self.view];
    
    if (CGRectContainsPoint([self.view convertRect:self.tableView.frame fromView:self.tableView.superview], location))
    {
        CGPoint locationInTableview = [self.tableView convertPoint:location fromView:self.view];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:locationInTableview];
        
        if (indexPath){
            
            NSString *friendID = [[requestArr objectAtIndex:indexPath.row][@"friendId"] valueForKey:@"_id"];
            
            [self goToProfilePage:friendID];
            
        }
        
        
        
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return requestArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FrRequestCell" forIndexPath:indexPath];
    
    UIImageView *iv_profile = (UIImageView *) [cell viewWithTag:1];
    UILabel *lbl_name = (UILabel *) [cell viewWithTag:2];
    UILabel *lbl_time = (UILabel *) [cell viewWithTag:3];
    UILabel *lbl_desc = (UILabel *) [cell viewWithTag:4];

    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapProfileIcon:)];
    gesture.delegate = self;
    iv_profile.userInteractionEnabled = true;
    [iv_profile addGestureRecognizer:gesture];
    
    
    iv_profile.layer.borderWidth = 1.0;
  //  iv_profile.contentMode = ScaleAspectFill;
    iv_profile.layer.masksToBounds = false;
    iv_profile.layer.borderColor = [UIColor lightGrayColor].CGColor;    iv_profile.layer.cornerRadius = iv_profile.frame.size.height/2;
    iv_profile.clipsToBounds = true;
    
    
    NSURL *url = [NSURL URLWithString:[[requestArr objectAtIndex:indexPath.row][@"friendId"] valueForKey:@"imgUrl"]];
    
    
    UIImage *placeholderImage = [UIImage imageNamed:@"ic_booking_profilepic"];
    [iv_profile sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error == nil) {
            iv_profile.image = image;
        }
    }];
    
    
    lbl_name.text = [NSString stringWithFormat:@"%@ %@",[[requestArr objectAtIndex:indexPath.row][@"friendId"] valueForKey:@"firstName"], [[requestArr objectAtIndex:indexPath.row][@"friendId"] valueForKey:@"lastName"]];
    
    lbl_desc.text = [NSString stringWithFormat:@"Has sent you a friend request."];

    lbl_time.text = [HelpingClass convertDateFormat:@"yyyy-MM-dd HH:mm:ss" desireFormat:@"dd MMM hh:mm a" dateStr:[[requestArr objectAtIndex:indexPath.row] valueForKey:@"createdDate"]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

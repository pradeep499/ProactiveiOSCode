//
//  PACircleVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 11/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PACircleVC.h"
#import "CollectionHeaderView.h"
#import "ExpertsDetailVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "ActivitiesVC.h"
#import "ProactiveLiving-Swift.h"



@interface PACircleVC (){
    
    PACContainerViewController *pACContainerViewController;
    
    
}
@property (nonatomic, strong) NSMutableDictionary *data;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic)NSString * menuItemId;
@property (strong, nonatomic)NSString *menuItemName;

- (IBAction)btnBackClick:(id)sender;

@end

@implementation PACircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.menuCollection.collectionViewLayout;
    //collectionViewLayout.sectionInset = UIEdgeInsetsMake(10,10, 10,10);//top left bottom right
    
    // Service Hit Call
   // self.getAppointmentListingData;
    
    [self getAllCategoriesListing];
    
    
}

#pragma mark:-  Service Hit Api


// MARK:- Service Hit
-(void)getAllCategoriesListing
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        NSString * menuListID = @"users/getAllCategoriesListing/";
        
        if (_menuItemId != nil )
        {
            menuListID = [menuListID stringByAppendingString:self.menuItemId];
            NSLog(@"Test 2%@",menuListID);
           
        }
        else {
            
            menuListID = [menuListID stringByAppendingString:@"1b24e5f9-5318-4838-b81a-85d2ee7dc403"];
             NSLog(@"TEST 1%@",menuListID);
        }
       
        //call global web service class
        [Services getRequest:menuListID parameters:parameters completionHandler:^(NSString *err, NSDictionary *responseDict) {
            
            [AppDelegate dismissProgressHUD];//dissmiss indicator
            
            if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
            {
                if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                    
              
                    self.dataArray=[responseDict objectForKey:@"result"];
                    NSLog(@"$#$#$# %@",self.dataArray);
                   
                    
                    
                    
                    if (_menuItemId != nil ){
                        
                        if([self.dataArray count] !=0){
                            
                            NSLog(@"When Array has data %lu",(unsigned long)[self.dataArray count]);
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PAC" bundle:nil];
                            pACContainerViewController  = [storyboard instantiateViewControllerWithIdentifier:@"PACContainerViewController"];
                            pACContainerViewController.menuArr = self.dataArray;
                            pACContainerViewController.strActivityName = self.menuItemName;

                            [self.navigationController pushViewController:pACContainerViewController animated:YES];
                        }
                        
                        else{
                            
                            NSLog(@"Redirection to the Find");
                            PacContainerVC *vc = [[AppHelper getPacStoryBoard] instantiateViewControllerWithIdentifier:@"PacContainerVC"];
                            vc.strActivityID = self.menuItemId;
                            vc.strActivityName =self.menuItemName;
                            vc.title = @"title";
                            
                            [self.navigationController pushViewController:vc animated:YES];

                            
                        }
                        
                        self.menuItemId = nil;
                        self.menuItemName = nil;
                        
                    }
                    else{
                         [self.menuCollection reloadData];
                    }
                    
                   // [self.menuCollection reloadData];
                    
                }
                else
                {
                    [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:0 delegate:nil cancelButton:ok otherButton:nil];
                    
                }
                
            }
            else
                [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
            
        } ];
        
        
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
     [self getAllCategoriesListing];
}

#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    // to set the light color of status bar
    return UIStatusBarStyleLightContent;
}

#pragma mark collection view cell layout / size
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize mElementSize = CGSizeMake((SCREEN_WIDTH-30)/3, (SCREEN_WIDTH-30)/3);
    return mElementSize;    // if the width is higher, only one cell will be shown in a line
}

#pragma mark collection view section wise paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];     //[self.arrMenueImages count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MenuCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
  //  recipeImageView.image = [UIImage imageNamed:[self.arrMenueImages objectAtIndex:indexPath.row]];
    
    NSDictionary *dicResult =  self.dataArray[indexPath.row];
    NSString *strImage = dicResult[@"image"];
    [recipeImageView sd_setImageWithURL:[NSURL URLWithString:strImage]];
    //recipeImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strImage]]];
   
   
    
    
    //  view_Image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img_FULL]]];
    
    
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionHeaderView *header = nil;
    
    if ([kind isEqual:UICollectionElementKindSectionHeader])
    {
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:@"HeaderView"
                                                           forIndexPath:indexPath];
        
        CGRect headerBounds=header.bounds;
        if([self.menuTitle isEqualToString:@""])
        {
            headerBounds.size.height=0;
            header.frame=headerBounds;
        }
        else
            header.lblHeader.text = self.menuTitle;
    }
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if([self.menuTitle isEqualToString:@""])
        return CGSizeMake(0.,0.);
    
    return CGSizeMake(0.,30.);
    
}

#pragma mark collection view dataSource

-(void)collectionView:(UICollectionView*)collectionview didSelectItemAtIndexPath:(NSIndexPath*) indexPath
{
    NSLog(@"%d",(int)indexPath.item);
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        
        
        NSDictionary *dicResult =  self.dataArray[indexPath.row];
        self.menuItemId = dicResult[@"_id"];
        self.menuItemName = dicResult[@"name"];
        NSLog(@"HAHAHA%@",self.menuItemId);
        [self getAllCategoriesListing];  // service hit
        
    }
    
    
    
    
    
    
//    switch ((int)indexPath.item) {
//        case 0:
//             if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
//                 
//                 
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PAC" bundle:nil];
//            pACContainerViewController  = [storyboard instantiateViewControllerWithIdentifier:@"PACContainerViewController"];
//
////             vc.menuTitle=@"";
////             vc.arrMenueImages=[NSArray arrayWithObjects:
////             @"ic_activities_badminton",
////             @"ic_activities_baseball",
////             @"ic_activities_basketball",
////             @"ic_activities_flagfootball",
////             @"ic_activities_football",
////             @"ic_activities_golf",
////             @"ic_activities_hockey",
////             @"ic_activities_kickball",
////             @"ic_activities_softball",
////             @"ic_activities_soccer",
////             @"ic_activities_skiing",
////             @"ic_activities_swimming",
////             @"ic_activities_tennis",
////             @"ic_activities_volleyball",
////             @"ic_activities_more", nil];
//             [self.navigationController pushViewController:pACContainerViewController animated:YES];
//             }
//            break;
//        case 1:
////            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
////                ActivitiesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivitiesVC"];
////                vc.menuTitle=@"";
////                vc.arrMenueImages=[NSArray arrayWithObjects:
////                                   @"ic_activities_badminton",
////                                   @"ic_activities_baseball",
////                                   @"ic_activities_basketball",
////                                   @"ic_activities_flagfootball",
////                                   @"ic_activities_football",
////                                   @"ic_activities_golf",
////                                   @"ic_activities_hockey",
////                                   @"ic_activities_kickball",
////                                   @"ic_activities_softball",
////                                   @"ic_activities_soccer",
////                                   @"ic_activities_skiing",
////                                   @"ic_activities_swimming",
////                                   @"ic_activities_tennis",
////                                   @"ic_activities_volleyball",
////                                   @"ic_activities_more", nil];
////                [self.navigationController pushViewController:vc animated:YES];
////            }
//            break;
//        case 2:
////            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
////                ActivitiesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivitiesVC"];
////                vc.menuTitle=@"";
////                vc.arrMenueImages=[NSArray arrayWithObjects:
////                                   @"ic_activities_badminton",
////                                   @"ic_activities_baseball",
////                                   @"ic_activities_basketball",
////                                   @"ic_activities_flagfootball",
////                                   @"ic_activities_football",
////                                   @"ic_activities_golf",
////                                   @"ic_activities_hockey",
////                                   @"ic_activities_kickball",
////                                   @"ic_activities_softball",
////                                   @"ic_activities_soccer",
////                                   @"ic_activities_skiing",
////                                   @"ic_activities_swimming",
////                                   @"ic_activities_tennis",
////                                   @"ic_activities_volleyball",
////                                   @"ic_activities_more", nil];
////                [self.navigationController pushViewController:vc animated:YES];
////            }
//            break;
//        
//        default:
//            break;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}

@end

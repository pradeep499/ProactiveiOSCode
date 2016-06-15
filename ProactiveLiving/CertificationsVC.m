//
//  CertificationsVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 22/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "CertificationsVC.h"
#import "CollectionHeaderView.h"
#import "CertDetailsVC.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "Defines.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface CertificationsVC ()
{
}
@property (strong, nonatomic) NSArray *dataArray;
- (IBAction)btnBackClick:(id)sender;

@end

@implementation CertificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.menuCollection.collectionViewLayout;
    //collectionViewLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);//top left bottom right
    [self getCertificationsData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)getCertificationsData
{
    //check internet before hitting web service
    if ([AppDelegate checkInternetConnection]) {
        
        //show indicator on screen
        [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        [parameters setValue:AppKey forKey:@"AppKey"];
        [parameters setValue:[AppHelper userDefaultsForKey:uId] forKey:@"UserID"];
        
        //web service call
        [Services serviceCallWithPath:ServiceGetCertifications withParam:parameters success:^(NSDictionary *responseDict)
         {
             [SVProgressHUD dismiss];//dissmiss indicator
             
             if (![[responseDict objectForKey:@"error"] isKindOfClass:[NSNull class]] && [responseDict objectForKey:@"error"])
             {
                 if ([[responseDict objectForKey:@"error"] intValue] == 0) {
                     
                     self.dataArray=[responseDict objectForKey:@"result"];
                     [self.menuCollection reloadData];
                 }
                 else
                 {
                     [AppHelper showAlertWithTitle:[responseDict objectForKey:@"errorMsg"] message:@"" tag:111 delegate:self cancelButton:ok otherButton:nil];
                 }
                 
             }
             else
                 [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
             
         } failure:^(NSError *error)
         {
             //[SVProgressHUD dismiss];
             [AppHelper showAlertWithTitle:@"" message:serviceError tag:0 delegate:nil cancelButton:ok otherButton:nil];
         }];
        
    }
    else
        //show internet not available
        [AppHelper showAlertWithTitle:netError message:netErrorMessage tag:0 delegate:nil cancelButton:ok otherButton:nil];
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

#pragma mark collection view cell paddings
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
    //return [self.arrMenueImages count];
    return [self.dataArray count];

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MenuCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:100];
    //recipeImageView.image = [UIImage imageNamed:[self.arrMenueImages objectAtIndex:indexPath.row]];
    [cellImageView setImageWithURL:[NSURL URLWithString:[[self.dataArray objectAtIndex:indexPath.item] valueForKey:@"image"]] placeholderImage:nil];
    
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
        CertDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CertDetailsVC"];
        vc.menuTitle=[[self.dataArray objectAtIndex:indexPath.item] valueForKey:@"name"];
        vc.arrMenueImages=[[self.dataArray objectAtIndex:indexPath.item] valueForKey:@"types"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    /*
    switch ((int)indexPath.item) {
        case 0:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                CertDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CertDetailsVC"];
                vc.menuTitle=@"Exercise and Fitness";
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_certifications_nept",
                                   @"ic_certifications_nationalacademy",
                                   @"ic_certifications_sportsmedicine",
                                   @"ic_certifications_americalcouncil",
                                   @"ic_certifications_nationalstrentht",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 1:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                CertDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CertDetailsVC"];
                vc.menuTitle=@"Diet and Nutrition";
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_certifications_nationalgourment",
                                   @"ic_certifications_rouxbe",
                                   @"ic_certifications_culinary",
                                   @"ic_certifications_integrativenutrition",nil];
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 2:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                CertDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CertDetailsVC"];
                vc.menuTitle=@"Corporate Wellness";
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_certifications_wellnesscouncil",
                                   @"ic_certifications_nationalwellness",
                                   @"ic_certifications_wellnessasociation",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 3:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                CertDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CertDetailsVC"];
                vc.menuTitle=@"Psychosocial Wellness";
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_certifications_physycologyofeating" ,nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 4:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                CertDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CertDetailsVC"];
                vc.menuTitle=@"Sustainable Food";
                //vc.arrMenueImages=[NSArray arrayWithObjects:
                                   //@"ic_improve_activities.png",
                                   //@"ic_improve_certification",
                                   //@"ic_improve_city",
                                   //@"ic_improve_communityprograme",
                                   //@"ic_improve_device",
                                   //@"ic_improve_dietplans",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 5:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                CertDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CertDetailsVC"];
                vc.menuTitle=@"Holistic Health";
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_certifications_nationalcommisiion",
                                   @"ic_certifications_acehealthcoach",
                                   @"ic_certifications_wellcoaches",
                                   @"ic_certifications_dukeuniversity",
                                   @"ic_certifications_healthyscience",
                                   @"ic_certifications_mayoclinic",
                                   @"ic_certifications_realbalance",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        default:
            break;
    }
     */
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

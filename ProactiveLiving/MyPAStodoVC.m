//
//  MyPAStodoVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 24/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "MyPAStodoVC.h"
#import "AppHelper.h"
#import "CurrentPASVC.h"
#import "ImproveVC.h"
#import "PASInviteMainVC.h"
#import "PASShareVC.h"
#import "AppointmentDetailsVC.h"
#import "ValidationCentersVC.h"
#import "Defines.h"
#import "ValidationCentersVC.h"
#import "CollectionHeaderView.h"

@implementation MyPAStodoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // self.menuTitle=@"";
    self.arrMenueImages=[NSArray arrayWithObjects:
                       @"ic_pasodo_current",
                       @"ic_pasodo_improve",
                       @"ic_pasodo_update",
                       @"ic_pasodo_pasinvite",
                       @"ic_pasodo_gift",
                       @"ic_pasodo_share",
                       @"ic_pasodo_biometrics",
                       @"ic_pasodo_history",
                       @"ic_pasodo_analytics",
                       @"ic_pasodo_appointment",
                       @"ic_pasodo_validationcenter",
                       @"ic_pasodo_qrcode",
                       @"ic_pasodo_videos",
                       @"ic_pasodo_faq",
                       @"ic_pasodo_more",nil];
    
    
    
    //UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.menuCollection.collectionViewLayout;
    //collectionViewLayout.sectionInset = UIEdgeInsetsMake(10,10, 10,10);//top left bottom right
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
    return [self.arrMenueImages count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MenuCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageNamed:[self.arrMenueImages objectAtIndex:indexPath.row]];
    
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
    //NSLog(@"%d",(int)indexPath.item);
    
    switch ((int)indexPath.item) {
        case 0:
            
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                CurrentPASVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentPASVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ImproveVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImproveVC"];
                vc.menuTitle=@"";
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_improve_experts",
                                   @"ic_improve_webinars",
                                   @"ic_improve_webcasts",
                                   @"ic_improve_event",
                                   @"ic_improve_PAccircle",
                                   @"ic_improve_PASduel",
                                   @"ic_improve_education",
                                   @"ic_improve_prevention",
                                   @"ic_improve_volunteer",
                                   @"ic_improve_eatingguide",
                                   @"ic_improve_dietplans",
                                   @"ic_improve_healthymeals",
                                   @"ic_improve_wellnessapps",
                                   @"ic_improve_device",
                                   @"ic_improve_workout",
                                   @"ic_improve_inspotstionalvideos",
                                   @"ic_improve_inspirationalmessage",
                                   @"ic_improve_gratitudejournal",
                                   @"ic_improve_city",
                                   @"ic_improve_communityprograme",
                                   @"ic_improve_specialized",
                                   @"ic_improve_kids",
                                   @"ic_improve_youthprograms",
                                   @"ic_improve_seniorprograms",nil];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 2:
            
            break;
        case 3:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                PASInviteMainVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASInviteMainVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 4:
            
            break;
        case 5:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                PASShareVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PASShareVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                AppointmentDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentDetailsVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 10:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                vc.orgType=@"Validation Centers";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        default:
            break;
    }
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

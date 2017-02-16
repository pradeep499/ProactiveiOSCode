//
//  ActivitiesVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 27/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ActivitiesVC.h"
#import "CollectionHeaderView.h"
#import "ActivityDetailVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "ProactiveLiving-Swift.h"

@interface ActivitiesVC ()

- (IBAction)btnBackClick:(id)sender;

@end

@implementation ActivitiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.menuCollection.collectionViewLayout;
    //collectionViewLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    
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
    NSLog(@"%d",(int)indexPath.item);
    

    PacContainerVC *vc = [[AppHelper getPacStoryBoard] instantiateViewControllerWithIdentifier:@"PacContainerVC"];
    vc.title = @"title";
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    if (indexPath.row == 0) {
        
    }
    
    
    /*
    switch ((int)indexPath.item) {
        case 0:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"Physicians";
                //vc.arrMenueImages=[NSArray arrayWithObjects:
                //@"ic_certifications_nept",
                //@"ic_certifications_nationalacademy",
                //@"ic_certifications_sportsmedicine",
                //@"ic_certifications_americalcouncil",
                //@"ic_certifications_nationalstrentht",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 1:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"Personal Trainers";
                //vc.arrMenueImages=[NSArray arrayWithObjects:
                //@"ic_certifications_nationalgourment",
                //@"ic_certifications_rouxbe",
                //@"ic_certifications_culinary",
                //@"ic_certifications_integrativenutrition",nil];
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 2:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"Dietitians";
                //vc.arrMenueImages=[NSArray arrayWithObjects:
                //@"ic_improve_communityprograme",
                //@"ic_improve_device",
                //@"ic_improve_dietplans",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 3:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"Health Wellness Coaches";
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_expert_chip",
                                   @"ic_expert_wellness" ,nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 4:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"Health Education Specialists";
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
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"Nutritionists";
                //                vc.arrMenueImages=[NSArray arrayWithObjects:
                //                                   @"ic_certifications_nationalcommisiion",
                //                                   @"ic_certifications_acehealthcoach",
                //                                   @"ic_certifications_wellcoaches",
                //                                   @"ic_certifications_dukeuniversity",
                //                                   @"ic_certifications_healthyscience",
                //                                   @"ic_certifications_mayoclinic",
                //                                   @"ic_certifications_realbalance",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 6:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"Professional Organizers";
                //                vc.arrMenueImages=[NSArray arrayWithObjects:
                //                                   @"ic_certifications_nationalcommisiion",
                //                                   @"ic_certifications_acehealthcoach",
                //                                   @"ic_certifications_wellcoaches",
                //                                   @"ic_certifications_dukeuniversity",
                //                                   @"ic_certifications_healthyscience",
                //                                   @"ic_certifications_mayoclinic",
                //                                   @"ic_certifications_realbalance",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 7:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"Psychologists";
                //                vc.arrMenueImages=[NSArray arrayWithObjects:
                //                                   @"ic_certifications_nationalcommisiion",
                //                                   @"ic_certifications_acehealthcoach",
                //                                   @"ic_certifications_wellcoaches",
                //                                   @"ic_certifications_dukeuniversity",
                //                                   @"ic_certifications_healthyscience",
                //                                   @"ic_certifications_mayoclinic",
                //                                   @"ic_certifications_realbalance",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 8:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"Corp Wellness Specialists ";
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_expert_corporatewellness",
                                   @"ic_expert_worksite",nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 9:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ActivityDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailVC"];
                vc.menuTitle=@"More";
                //                vc.arrMenueImages=[NSArray arrayWithObjects:
                //                                   @"ic_certifications_nationalcommisiion",
                //                                   @"ic_certifications_acehealthcoach",
                //                                   @"ic_certifications_wellcoaches",
                //                                   @"ic_certifications_dukeuniversity",
                //                                   @"ic_certifications_healthyscience",
                //                                   @"ic_certifications_mayoclinic",
                //                                   @"ic_certifications_realbalance",nil];
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

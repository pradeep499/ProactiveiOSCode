//
//  ExpertsVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 14/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ExpertsVC.h"
#import "CollectionHeaderView.h"
#import "ExpertsDetailVC.h"
#import "AppHelper.h"
#import "Defines.h"
#import "ValidationCentersVC.h"

@interface ExpertsVC ()
- (IBAction)btnBackClick:(id)sender;

@end

@implementation ExpertsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    NSLog(@"%d",(int)indexPath.item);
    
    switch ((int)indexPath.item) {
        case 0:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                
                if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                    ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                    vc.orgType=@"Physicians";
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            break;
        case 1:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                    ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                    vc.orgType=@"Personal Trainers";
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            break;
        case 2:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                    ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                    vc.orgType=@"Dietitians";
                    [self.navigationController pushViewController:vc animated:YES];
                }

            }
            break;
        case 3:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                    ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                    vc.orgType=@"Health Wellness Coaches";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            break;
        case 4:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                    ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                    vc.orgType=@"Health Education Specialists";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            break;
        case 5:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                    ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                    vc.orgType=@"Nutritionists";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            break;
        case 6:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                    ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                    vc.orgType=@"Professional Organizers";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            break;
        case 7:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                    ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                    vc.orgType=@"Psychologists";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            break;
        case 8:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                
                if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                    ValidationCentersVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ValidationCentersVC"];
                    vc.orgType=@"Corp Wellness Specialists";
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            break;
        case 9:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                ExpertsDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpertsDetailVC"];
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

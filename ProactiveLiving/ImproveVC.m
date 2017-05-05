//
//  ImproveVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 14/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ImproveVC.h"
#import "AppHelper.h"
#import "ExpertsVC.h"
#import "AllPACirclesVC.h"
#import "EducationVC.h"
#import "CertificationsVC.h"
#import "Defines.h"
#import "ValidationCentersVC.h"
#import "CollectionHeaderView.h"

@interface ImproveVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)btnBackClick:(id)sender;

@end

@implementation ImproveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.menuCollection.collectionViewLayout;
    //collectionViewLayout.sectionInset = UIEdgeInsetsMake(10,10, 10,10);//top left bottom right
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.btnBack.hidden =  NO;// YES; // chenged as per client request
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
                ExpertsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpertsVC"];
                vc.menuTitle=@"";
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_expert_physicians",
                                   @"ic_expert_personaltrainers",
                                   @"ic_expert_dieticians",
                                   @"ic_expert_healthwellness",
                                   @"ic_expert_healtheducation",
                                   @"ic_expert_nutritionists",
                                   @"ic_expert_professionalorganisations",
                                   @"ic_expert_psycologists",
                                   @"ic_expert_corpwellness",
                                   @"ic_expert_more", nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                AllPACirclesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllPACirclesVC"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 5:
            
            break;
        case 6:
            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
                EducationVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EducationVC"];
                vc.arrMenuTitles=[NSArray arrayWithObjects:
                                  @"Format",
                                  @"By",
                                  @"For", nil];
                vc.arrMenueImages=[NSArray arrayWithObjects:
                                   @"ic_expert_physicians",
                                   @"ic_expert_personaltrainers",
                                   @"ic_expert_dieticians",
                                   @"ic_expert_healthwellness",
                                   @"ic_expert_healtheducation",
                                   @"ic_expert_nutritionists",
                                   @"ic_expert_professionalorganisations",
                                   @"ic_expert_psycologists",
                                   @"ic_expert_corpwellness",
                                   @"ic_expert_more", nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        default:
            break;
    }
}

- (IBAction)btnCertificationClick:(id)sender {
    
    if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
        CertificationsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CertificationsVC"];
        vc.menuTitle=@"";
        vc.arrMenueImages=[NSArray arrayWithObjects:
                           @"ic_certifications_exercise",
                           @"ic_certifications_diet",
                           @"ic_certifications_corporatewellness",
                           @"ic_certifications_psycosocial",
                           @"ic_certifications_sustainable",
                           @"ic_certifications_holistic", nil];
        [self.navigationController pushViewController:vc animated:YES];
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

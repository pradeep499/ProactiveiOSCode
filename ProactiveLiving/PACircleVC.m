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
- (IBAction)btnBackClick:(id)sender;

@end

@implementation PACircleVC

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
                 
                 
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PAC" bundle:nil];
            pACContainerViewController  = [storyboard instantiateViewControllerWithIdentifier:@"PACContainerViewController"];

//             vc.menuTitle=@"";
//             vc.arrMenueImages=[NSArray arrayWithObjects:
//             @"ic_activities_badminton",
//             @"ic_activities_baseball",
//             @"ic_activities_basketball",
//             @"ic_activities_flagfootball",
//             @"ic_activities_football",
//             @"ic_activities_golf",
//             @"ic_activities_hockey",
//             @"ic_activities_kickball",
//             @"ic_activities_softball",
//             @"ic_activities_soccer",
//             @"ic_activities_skiing",
//             @"ic_activities_swimming",
//             @"ic_activities_tennis",
//             @"ic_activities_volleyball",
//             @"ic_activities_more", nil];
             [self.navigationController pushViewController:pACContainerViewController animated:YES];
             }
            break;
        case 1:
//            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
//                ActivitiesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivitiesVC"];
//                vc.menuTitle=@"";
//                vc.arrMenueImages=[NSArray arrayWithObjects:
//                                   @"ic_activities_badminton",
//                                   @"ic_activities_baseball",
//                                   @"ic_activities_basketball",
//                                   @"ic_activities_flagfootball",
//                                   @"ic_activities_football",
//                                   @"ic_activities_golf",
//                                   @"ic_activities_hockey",
//                                   @"ic_activities_kickball",
//                                   @"ic_activities_softball",
//                                   @"ic_activities_soccer",
//                                   @"ic_activities_skiing",
//                                   @"ic_activities_swimming",
//                                   @"ic_activities_tennis",
//                                   @"ic_activities_volleyball",
//                                   @"ic_activities_more", nil];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
            break;
        case 2:
//            if (![[AppHelper userDefaultsForKey:uId] isKindOfClass:[NSNull class]] && [AppHelper userDefaultsForKey:uId]) {
//                ActivitiesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivitiesVC"];
//                vc.menuTitle=@"";
//                vc.arrMenueImages=[NSArray arrayWithObjects:
//                                   @"ic_activities_badminton",
//                                   @"ic_activities_baseball",
//                                   @"ic_activities_basketball",
//                                   @"ic_activities_flagfootball",
//                                   @"ic_activities_football",
//                                   @"ic_activities_golf",
//                                   @"ic_activities_hockey",
//                                   @"ic_activities_kickball",
//                                   @"ic_activities_softball",
//                                   @"ic_activities_soccer",
//                                   @"ic_activities_skiing",
//                                   @"ic_activities_swimming",
//                                   @"ic_activities_tennis",
//                                   @"ic_activities_volleyball",
//                                   @"ic_activities_more", nil];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
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

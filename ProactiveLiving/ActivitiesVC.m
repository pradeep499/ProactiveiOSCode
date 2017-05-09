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
#pragma mark:- Outlets
- (IBAction)btnBackClick:(id)sender;
/*
 @property (copy, nonatomic) NSString *menuTitle;
 @property (copy, nonatomic) NSArray *arrMenueImages
 */



@end

@implementation ActivitiesVC

#pragma mark:- View Life Cycle

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

#pragma mark cellForItemAtIndexPath
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MenuCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    NSDictionary *dicResult =  self.arrMenueImages[indexPath.row];
    
    NSString *strImage = dicResult[@"image"];
   // [recipeImageView sd_setImageWithURL:[NSURL URLWithString:strImage]];

    [recipeImageView sd_setImageWithURL:[NSURL URLWithString:strImage] placeholderImage:[UIImage imageNamed:@"pac_listing_no_preview"]];
    
   // recipeImageView.image = [UIImage imageNamed:[self.arrMenueImages objectAtIndex:indexPath.row]];
    
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

#pragma mark collection view delegate

-(void)collectionView:(UICollectionView*)collectionview didSelectItemAtIndexPath:(NSIndexPath*) indexPath
{
    //NSLog(@"%d",(int)indexPath.item);
    

    PacContainerVC *vc = [[AppHelper getPacStoryBoard] instantiateViewControllerWithIdentifier:@"PacContainerVC"];
    vc.title = @"title";
    
   
    NSDictionary *dicResult =  self.arrMenueImages[indexPath.row];
    NSString *strName = dicResult[@"name"];
    NSString *strID = dicResult[@"_id"];
  //  vc.arrMenuListData = self.arrMenueImages[indexPath.row];
    vc.strActivityID = strID;
    vc.strActivityName = strName;
    
    NSString *valueToSave = strID;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"categoryID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:- Button Actions

- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}

@end

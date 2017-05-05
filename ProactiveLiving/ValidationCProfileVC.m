//
//  ValidationCProfileVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ValidationCProfileVC.h"
#import "ProfileVCTableCell.h"
#import "ProfileVCTableCell2.h"
#import "Defines.h"
#import "AppHelper.h"

@interface ValidationCProfileVC ()
{
    float rowHeight;
    NSUInteger indentation;
    NSMutableArray *nodes;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *screentitle;
@property (nonatomic, retain) NSMutableArray *displayArray;

@end

@implementation ValidationCProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screentitle.text=[self.allData valueForKey:@"name"];
    rowHeight=390;
    //[self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [AppHelper setBorderOnView:self.tableView];
    
    [self fillNodesArray];
    
    // add extra padding to table footer
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    self.tableView.tableFooterView = footerView;
    [self.tableView reloadData];
    
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

-(void)viewDidAppear:(BOOL)animated
{
    /*CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0.5, 0.5);
    sublayer.shadowRadius = 1.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.5;
    sublayer.cornerRadius = 1.0;
    sublayer.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
    [self.view.layer addSublayer:sublayer];
    [self.view.layer addSublayer:self.tableView.layer];*/

}

//These two functions are used to fill the nodes array with the tree nodes
- (void)fillNodesArray
{
    nodes = [NSMutableArray new];

    for (int i=0; i<[self.allData[@"facility"] count]; i++) {
       
    if([[[self.allData[@"facility"]objectAtIndex:i]allKeys]containsObject:@"subfacility"])
    {
    TreeNode *node = [[TreeNode alloc]init];
    node.nodeLevel = 0;
    node.nodeObject = [[self.allData[@"facility"]objectAtIndex:i]valueForKey:@"name"];
    node.isExpanded = YES;
    node.nodeChildren = [self fillChildrenForNodeWithArray:[[self.allData[@"facility"] objectAtIndex:i]valueForKey:@"subfacility"]];
    [nodes addObject:node];
    }
    }
    
    [self fillDisplayArray];
}

- (NSMutableArray *)fillChildrenForNodeWithArray:(NSArray *)subChild
{
    NSMutableArray *childNodes = [NSMutableArray new];
    
    for (int i=0; i<[subChild count]; i++) {
        
        TreeNode *node = [[TreeNode alloc]init];
        node.nodeLevel = 1;
        node.nodeObject = [subChild objectAtIndex:i];
        node.isExpanded = YES;
        [childNodes addObject:node];
    }
    
    return childNodes;
}

//This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (TreeNode *node in nodes) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}


//TableView delegates and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *CellIdentifier = @"SectionHeader";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (headerView == nil)
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    
    UIImageView *imageView = (UIImageView *)[headerView viewWithTag:111];
    UILabel *labelTitle = (UILabel *)[headerView viewWithTag:222];
    
    switch (section) {
       
        case 1:
            imageView.image=[UIImage imageNamed:@"ic_profile_service"];
            labelTitle.text=@"Services";
            break;
        case 2:
            imageView.image=[UIImage imageNamed:@"ic_profile_facility"];
            labelTitle.text=@"Facility";
            break;
        case 3:
            imageView.image=[UIImage imageNamed:@"ic_profile_otherservices"];
            labelTitle.text=@"Other Services";
            break;
            
        default:
            break;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0.0;
            break;
        case 1:
            if([[self.allData[@"service"]valueForKey:@"name"]count]>0)
                return 50.0;
            else
                return 0;
            break;
        case 2:
            if([[self.allData[@"facility"]valueForKey:@"name"]count]>0)
                return 50.0;
            else
                return 0;
            break;
        case 3:
            if([[self.allData[@"otherservices"]valueForKey:@"name"]count]>0)
                return 50.0;
            else
                return 0;
            break;
            
        default:
            break;
    }
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"SectionNumber: %ld",(long)section);
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [[self.allData[@"service"]valueForKey:@"name"] count];
            break;
        case 2:
            //return [[self.allData[@"facility"]valueForKey:@"name"] count];
            return [self.displayArray count];
            break;
        case 3:
            return [[self.allData[@"otherservices"]valueForKey:@"name"] count];
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return rowHeight;
            break;
        case 1:
            return 16.0;
            break;
        case 2:
            return 16.0;
            break;
        case 3:
            return 16.0;
            break;
            
        default:
            break;
    }
    return 0.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *kCustomCellID1 = @"ProfileVCTableCell";
    static NSString *kCustomCellID2 = @"ProfileVCTableCell2";
    
    switch (indexPath.section) {
        case 0:
            {
            ProfileVCTableCell *cell1 = [tableView dequeueReusableCellWithIdentifier:kCustomCellID1];
            if (cell1 == nil)
                cell1 = [[ProfileVCTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID1];
                cell1.separatorInset = UIEdgeInsetsMake(0.f, cell1.bounds.size.width, 0.f, 0.f);

                cell1.lblTitle.text=[self.allData valueForKey:@"name"];
                cell1.ratingView.rating=[[self.allData valueForKey:@"rating"] floatValue];
                cell1.ratingView.canEdit=NO;
                cell1.txtDetails.text=[self.allData valueForKey:@"description"];

                [cell1.btnShowMore setTag:indexPath.row];
                [cell1.btnShowMore addTarget:self action:@selector(showMoreClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                
                NSString *rawHTML=[NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\"><script type=\"text/javascript\" src=\"http://maps.google.com/maps/api/js?sensor=true\"></script><script type=\"text/javascript\">function initialize() {var latlng = new google.maps.LatLng(%f, %f);var myOptions = {zoom: 15,center: latlng,mapTypeId: google.maps.MapTypeId.ROADMAP};var map = new google.maps.Map(document.getElementById(\"map_canvas\"), myOptions);}</script></head><body onload=\"initialize()\"><div id=\"map_canvas\" style=\"width:100%%; height:100%%\"></body></html>",[[[self.allData valueForKey:@"location"] objectAtIndex:1] floatValue],[[[self.allData valueForKey:@"location"] objectAtIndex:0] floatValue]];
                
                //NSArray *geoLocation = [NSArray arrayWithObjects:@"43.661383", @"-79.390862", nil];
                //NSString *searchString = [geoLocation componentsJoinedByString:@","];
                //NSString *google = @"https://maps.google.com/maps?q=";
                //NSString *URL = [google stringByAppendingString:searchString];
                //NSURL *urlMap = [NSURL URLWithString:URL];
                //[cell1.mapWebView loadRequest:[NSURLRequest requestWithURL:urlMap]];
                
                [cell1.mapWebView loadHTMLString:rawHTML baseURL:nil];
                [cell1.mapWebView setBackgroundColor:[UIColor whiteColor]];
                [cell1.mapWebView setScalesPageToFit:YES];
            return cell1;
            }
            break;

        case 1:
            {
            ProfileVCTableCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:kCustomCellID2];
            if (cell2 == nil)
                cell2 = [[ProfileVCTableCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID2];
            cell2.separatorInset = UIEdgeInsetsMake(0.f, cell2.bounds.size.width, 0.f, 0.f);

            if([[self.allData[@"service"]valueForKey:@"name"] count]>0)
            cell2.lblDetail.text=[[self.allData[@"service"]valueForKey:@"name"] objectAtIndex:indexPath.row];
            return cell2;
            }
            break;
        case 2:
        {
            ProfileVCTableCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:kCustomCellID2];
            if (cell2 == nil)
                cell2 = [[ProfileVCTableCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID2];
            cell2.separatorInset = UIEdgeInsetsMake(0.f, cell2.bounds.size.width, 0.f, 0.f);

            //if([[self.allData[@"facility"]valueForKey:@"name"] count]>0)
            //cell2.lblDetail.text=[[self.allData[@"facility"]valueForKey:@"name"] objectAtIndex:indexPath.row];
            
            if(self.displayArray.count>0)
            {
            TreeNode *node = [self.displayArray objectAtIndex:indexPath.row];
            cell2.treeNode = node;
            cell2.lblDetail.text = node.nodeObject;
            }
            
            return cell2;
        }
            break;
        case 3:
        {
            ProfileVCTableCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:kCustomCellID2];
            if (cell2 == nil)
                cell2 = [[ProfileVCTableCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID2];
            cell2.separatorInset = UIEdgeInsetsMake(0.f, cell2.bounds.size.width, 0.f, 0.f);

            if([[self.allData[@"otherservices"]valueForKey:@"name"] count]>0)
                cell2.lblDetail.text=[[self.allData[@"otherservices"]valueForKey:@"name"] objectAtIndex:indexPath.row];
            
            return cell2;
        }
            break;
        default:
            break;
    }
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForGroupInSection:(NSUInteger)section
{
    static NSString *CellIdentifier = @"GroupCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat: @"Group %d ", (int)section];
    
    return cell;
}

-(void)showMoreClicked:(UIButton*)sender
{
    if(sender.selected)
    {
        [sender setSelected:NO];
        rowHeight=390;
    }
    else
    {
        [sender setSelected:YES];
    
    CGSize sizeOfText = [[self.allData valueForKey:@"description"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, CGFLOAT_MAX)
                                                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                             attributes: [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Roboto-Light" size:14]
                                                                                                                     forKey:NSFontAttributeName]
                                                                                context: nil].size;
        rowHeight=sizeOfText.height+300;
    }
    
    //NSMutableArray *modifiedRows = [NSMutableArray array];
    //[modifiedRows addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    //[self.tableView reloadRowsAtIndexPaths:modifiedRows withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)btnBackClick:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  FilterVC4.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 04/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "FilterVC4.h"
#import "FilterFourCell.h"
#import "AppHelper.h"
#import "Defines.h"

@interface FilterVC4 ()
{
    NSMutableArray *arrayForBool;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FilterVC4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedRowsArray=[NSMutableArray arrayWithArray:[AppHelper userDefaultsForKey:@"arrTypes"]];
    [AppHelper setBorderOnView:self.tableView];
    
    
     CGFloat dummyViewHeight = 50;
     UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
     self.tableView.tableHeaderView = dummyView;
     self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
   
    if (!arrayForBool) {
        arrayForBool    = [NSMutableArray array];
        for (int i=0; i<[self.dataArray count]; i++) {
            [arrayForBool addObject:[NSNumber numberWithBool:NO]];
        }
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor whiteColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20-50, 50)];
    headerString.font               = [UIFont fontWithName:FONT_REGULAR size:17];
    headerString.textAlignment      = NSTextAlignmentCenter;
    headerString.textColor          = UIColorFromRGB(81, 81, 81);
    [headerView addSubview:headerString];

    headerString.text=[[self.dataArray objectAtIndex:section] valueForKey:@"name"];

    BOOL manyCells = [[arrayForBool objectAtIndex:section] boolValue];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    
    //up or down arrow depending on the bool
    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_filterservice_arrow"] ];
    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    upDownArrow.frame               = CGRectMake(SCREEN_WIDTH-34, 19, 7, 12);
    [headerView addSubview:upDownArrow];

    [UIView animateWithDuration:0.3f animations:^{
        if (manyCells)
            upDownArrow.transform = CGAffineTransformMakeRotation(M_PI_2);
        else
            upDownArrow.transform = CGAffineTransformMakeRotation(0);
    }];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 50;
            break;
        case 1:
            return 50;
            break;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 50;
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        
        return [[[self.dataArray objectAtIndex:section] objectForKey:@"Types"]count];

    }
    return 1;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kCustomCellID = @"FilterFourCell";
    FilterFourCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil)
        cell = [[FilterFourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    switch (indexPath.section) {
            
        case 0:
            cell.lblTitle.text = [[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"Types"]objectAtIndex:indexPath.row]valueForKey:@"name"];
            
            if ([self.selectedRowsArray containsObject:[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"Types"]objectAtIndex:indexPath.row]])
            {
                [cell.btnBox setImage:[UIImage imageNamed:@"ic_filterservice_check.png"] forState:UIControlStateNormal];
            }
            else {
                [cell.btnBox setImage:[UIImage imageNamed:@"ic_filterservice_uncheck.png"] forState:UIControlStateNormal];
            }
            [cell.btnBox setTag:indexPath.row];
            [cell.btnBox addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        case 1:
            cell.lblTitle.text = [[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"Types"]objectAtIndex:indexPath.row]valueForKey:@"name"];
            
            if ([self.selectedRowsArray containsObject:[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"Types"]objectAtIndex:indexPath.row]])
            {
                [cell.btnBox setImage:[UIImage imageNamed:@"ic_filterservice_check.png"] forState:UIControlStateNormal];
            }
            else {
                [cell.btnBox setImage:[UIImage imageNamed:@"ic_filterservice_uncheck.png"] forState:UIControlStateNormal];
            }
            [cell.btnBox setTag:indexPath.row];
            [cell.btnBox addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        default:
            break;
    }

    
    
    return cell;
}


- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        if ([self.selectedRowsArray containsObject:[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"Types"]objectAtIndex:indexPath.row]]) {
            [self.selectedRowsArray removeObject:[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"Types"]objectAtIndex:indexPath.row]];
        }
        else
        {
            [self.selectedRowsArray addObject:[[[self.dataArray objectAtIndex:indexPath.section] objectForKey:@"Types"]objectAtIndex:indexPath.row]];
        }
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationNone];
    }

}

#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end

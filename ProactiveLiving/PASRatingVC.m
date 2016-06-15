//
//  PASRatingVC.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 19/04/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASRatingVC.h"
#import "AppHelper.h"

@interface PASRatingVC ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnInstClick:(id)sender;

@end

@implementation PASRatingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [AppHelper setBorderOnView:self.tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnInstClick:(id)sender {
}
@end

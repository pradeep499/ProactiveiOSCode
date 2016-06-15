//
//  ContactsCell.h
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/05/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPerson;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@end

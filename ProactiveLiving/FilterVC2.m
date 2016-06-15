//
//  FilterVC2.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 04/02/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "FilterVC2.h"
#import "AppHelper.h"

@interface FilterVC2 ()<UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation FilterVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppHelper setBorderOnView:self.containerView];
    
    
    [self.datePicker setDate:[NSDate date] animated:YES];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate=[NSDate date];
    [self.datePicker addTarget:self action:@selector(dateChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    [self.timePicker setDate:[NSDate date] animated:YES];
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    //[self.timePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    [self.timePicker addTarget:self action:@selector(timeChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    
    /*
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, self.timePicker.frame.size.height / 2 - 15, 75, 30)];
    hourLabel.text = @"hr";
    [self.timePicker addSubview:hourLabel];
    
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + (self.timePicker.frame.size.width / 3), self.timePicker.frame.size.height / 2 - 15, 75, 30)];
    minsLabel.text = @"min";
    [self.timePicker addSubview:minsLabel];
    
    UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + ((self.timePicker.frame.size.width / 3) * 2), self.timePicker.frame.size.height / 2 - 15, 75, 30)];
    secsLabel.text = @"sec";
    [self.timePicker addSubview:secsLabel];
    
     */
   
    /*
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setValue:[UIColor colorWithRed:70/255.0f green:161/255.0f blue:174/255.0f alpha:1.0f] forKeyPath:@"textColor"];
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:self.datePicker];*/
    
}

- (void) dateChanged:(id)sender{
    // handle date changes and set in textField
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strdate = [dateFormatter stringFromDate:self.datePicker.date];
    NSLog(@"Date %@",strdate);
    self.selectedDate=[dateFormatter dateFromString:strdate];
}
- (void) timeChanged:(id)sender{
    // handle date changes and set in textField
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *strtime = [dateFormatter stringFromDate:self.timePicker.date];
    NSLog(@"Time %@",strtime);
    self.selectedTime=[dateFormatter dateFromString:strtime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50.0;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if(pickerView.tag==2) {
    }
    else {
        
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag==2) {
        return 10;
    }
    else {
       
    }
    return 0;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [NSString stringWithFormat:@"  %d", (int)row+1];
    return label;
}
 */


@end

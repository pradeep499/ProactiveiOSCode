//
//  PASSharePopUp.m
//  ProactiveLiving
//
//  Created by Mohd Asim on 15/06/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "PASSharePopUp.h"
#import "Defines.h"
#import "AppDelegate.h"

@implementation PASSharePopUp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString * textPAS;
    
    if([self.employers count]==1)
        textPAS=[NSString stringWithFormat:@"Share the PAS information you have selected with %@?",[self.employers objectAtIndex:0]];
    else if([self.employers count]==2)
        textPAS=[NSString stringWithFormat:@"Share the PAS information you have selected with %@ and %@?",[self.employers objectAtIndex:0],[self.employers objectAtIndex:1]];
    else
    {
        NSMutableArray *arrEmps=[self.employers copy];
        [arrEmps removeLastObject];
        NSString *strEmps=[arrEmps componentsJoinedByString:@","];
        textPAS=[NSString stringWithFormat:@"Share the PAS information you have selected with %@ and %@?",strEmps,[self.employers lastObject]];
    }

    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
                                       initWithString:textPAS];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor lightGrayColor]
                 range:[textPAS rangeOfString:textPAS]];
    
    [text addAttribute:NSFontAttributeName
                 value:[UIFont fontWithName:FONT_BOLD size:13]
                 range:[textPAS rangeOfString:@"PAS"]];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:[textPAS rangeOfString:@"PAS"]];
    
    for (int count=0; count<[self.employers count]; count++) {
        [text addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:FONT_BOLD size:13]
                     range:[textPAS rangeOfString:[self.employers objectAtIndex:count]]];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor blackColor]
                     range:[textPAS rangeOfString:[self.employers objectAtIndex:count]]];
    }
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSString *strInst=@"By clicking Share, I acknowledge that I have read and understood the Confidentiality and Consent information and am aware that once I select to share my PAS information, it is immediately sent to the selected entity.\n\n";
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:strInst
                                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                paragraphStyle, NSParagraphStyleAttributeName,
                                                                [NSNumber numberWithFloat:0],NSBaselineOffsetAttributeName,
                                                                [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                                                nil]];
    
    if(![text isKindOfClass:[NSNull class]] && text && text != NULL)
        [attString appendAttributedString:text] ;
    
    self.txtViewInst.attributedText = attString;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (IBAction)btnCancelClick:(id)sender {
    
    [self.dimView setAlpha:0.0f];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    if(touch.view==self.dimView){
        [self hidePopUp];
    }
}

-(void)hidePopUp
{
    [self.dimView setAlpha:0.0f];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        //[self showPopUp];
    }];
}

-(void)showPopUp
{
    // SetUp Popup view
    self.view.userInteractionEnabled = TRUE;
    [self.dimView setAlpha:0.0f];
    self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[AppDelegate getAppDelegate].window addSubview:self.view];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);;
    } completion:^(BOOL finished) {
        [self.dimView setAlpha:0.3f];
    }];
}

@end

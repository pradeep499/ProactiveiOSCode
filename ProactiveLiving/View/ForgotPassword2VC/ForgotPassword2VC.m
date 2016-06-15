//
//  ForgotPassword2VC.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/19/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ForgotPassword2VC.h"
#import "Defines.h"

@interface ForgotPassword2VC ()<UITextFieldDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *textFieldBackgroundImageView;//this imageview is used to show borderwidth and borderColor
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//Enter One Time Password(OTP)\nreceived in your Email
@property (weak, nonatomic) IBOutlet UITextField *cellNumberTextField;//enter cellnumber in this textfield
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;//table's headerview
@property (weak, nonatomic) IBOutlet UITableView *tableView;//tableview is used to manage view of the app
@property (weak, nonatomic) IBOutlet UIButton *sendAgainButton;//to resend the code

@end

@implementation ForgotPassword2VC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //add border to the textfieldbackgroundimageview
    self.textFieldBackgroundImageView.layer.borderColor = loginBorderColor.CGColor;
    self.textFieldBackgroundImageView.layer.borderWidth = 1.0f;
    
    //set text on titlelabel
    self.titleLabel.text = @"Enter One Time Password(OTP)\nreceived in your Email";
    
    //set height of tableheaderview
    CGRect frame = self.tableHeaderView.frame;
    frame.size.height = self.view.frame.size.height - 64;
    self.tableHeaderView.frame = frame;
    
    //add observer to get call in keyboardWillShow
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //add observer to get call in keyboardWillHide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //add a toolbarview on top of keyboard
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhonePad)], [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dontPhonePad)]];
    [numberToolbar sizeToFit];
    self.cellNumberTextField.inputAccessoryView = numberToolbar;
    
    //setting attributed text on sendAgainButton
    UIFont *font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Didn't get the code? Send Again"];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 20)];
    [attrString addAttribute:NSForegroundColorAttributeName value:signUpButtonColor range:NSMakeRange(0, 20)];
    
    [self.sendAgainButton setAttributedTitle:attrString forState:UIControlStateNormal];
}
#pragma mark - keyboardwillshow
-(void)keyboardWillShow:(NSNotification *)notification {
    //adjusting keyboard inset, to manage scrolling when keyboard is up
    CGSize keyBoardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = keyBoardSize.height + 20;
    self.tableView.contentInset = inset;
}
#pragma mark - keyboardwillhide
-(void)keyboardWillHide:(NSNotification *)notification {
    //reset inset when keyboard disappear
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark - cancelPhonePad
-(void)cancelPhonePad {
    //end editing
    [self.view endEditing:YES];
}
#pragma mark - dontPhonePad
-(void)dontPhonePad {
    //done editing
    [self.view endEditing:YES];
}
#pragma mark - back
- (IBAction)back:(id)sender {
    //back to previous view controller
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tapClosed
- (IBAction)tapClosed:(id)sender {
    //end editing
    [self.view endEditing:YES];
}
- (IBAction)sendAgain:(id)sender {
    [self.view endEditing:YES];
    //add functionality to resend the code
}
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //check if string does not start with a space
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if(str.length > 0 && [[str substringToIndex:1] isEqualToString:@" "]) {
        return NO;
    }
    
    //restrict text to maxPhoneLength
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > maxPhoneLength) ? NO : YES;
    
    return YES;
}
#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    //set status bar color
    return UIStatusBarStyleLightContent;
}
@end

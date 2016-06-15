//
//  ForgotPasswordVC.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/13/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "Defines.h"
#import "AppDelegate.h"
#import "Services.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ForgotPasswordVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *textBackgroundImageView;//to add borderwidth and bordercolor
@property (weak, nonatomic) IBOutlet UITableView *tableView;//tableview to manage view in the view controller
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;//table's headerview
@property (weak, nonatomic) IBOutlet UITextField *cellNumberTextField;//textfield to hold cellnumber
@property (strong, nonatomic) NSDictionary *detailDictionary;//holds all the details, when returned from the server
@end

@implementation ForgotPasswordVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //set background border width and color
    self.textBackgroundImageView.layer.borderWidth = 1.0f;
    self.textBackgroundImageView.layer.borderColor = loginBorderColor.CGColor;
    
    //adjust height of tableheaderview
    CGRect frame = self.tableHeaderView.frame;
    frame.size.height = self.view.frame.size.height - 64;
    self.tableHeaderView.frame = frame;
    
    //observer when keyboard will show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //observer when keyboard will hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //add toolbar above keyboard
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhonePad)], [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dontPhonePad)]];
    [numberToolbar sizeToFit];
    self.cellNumberTextField.inputAccessoryView = numberToolbar;
}
#pragma mark - cancelPhonePad
-(void)cancelPhonePad {
    //cancel editing
    [self.view endEditing:YES];
}
#pragma mark - dontPhonePad
-(void)dontPhonePad {
    //done editing
    [self.view endEditing:YES];
}
#pragma mark - keyboardwillshow
-(void)keyboardWillShow:(NSNotification *)notification {
    //adjust inset of tableview, so that when keyboard is up, scrolling is possible
    CGSize keyBoardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = keyBoardSize.height + 20;
    self.tableView.contentInset = inset;
}
#pragma mark - keyboardwillhide
-(void)keyboardWillHide:(NSNotification *)notification {
    //reset inset of keyboard
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark - back
- (IBAction)back:(id)sender {
    //back to previous view controller
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //end editing whenever touch on self.view
    [self.view endEditing:YES];
}
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //check if text does not start with a space
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if(str.length > 0 && [[str substringToIndex:1] isEqualToString:@" "]){
        return NO;
    }
    
    //restrict text to maxphonelength
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > maxPhoneLength) ? NO : YES;
    
    
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_MOBILE] invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    return [string isEqualToString:filtered];
    
    return YES;
}
#pragma mark - sendCode
- (IBAction)sendCode:(id)sender {
    [self.view endEditing:YES];
    
    if ([[self.cellNumberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        //show alert, email can't be empty
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:allMandatory delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 100;
        [alert show];
    }
    else {
        //check internet before hitting web service
        if ([AppDelegate checkInternetConnection]) {
            //show indicator on screen
            [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack];

            //create dictionary for parameters of web service
            NSDictionary *parameters;
            parameters = @{@"AppKey" : AppKey,
                           @"Phone" : [self.cellNumberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                           };
            
            //call global web service class
            [Services serviceCallWithPath:ServiceForgotPassword withParam:parameters success:^(NSDictionary *responseDict) {
                
                [SVProgressHUD dismiss];//dissmiss indicator
                
                self.detailDictionary = responseDict;//set dictionary
                
                if (![[self.detailDictionary objectForKey:@"error"] isKindOfClass:[NSNull class]] && [self.detailDictionary objectForKey:@"error"]) {
                    if ([[self.detailDictionary objectForKey:@"error"] intValue] == 0) {
                        // success login
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:pleaseLogin delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
                        [alert show];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else if ([[self.detailDictionary objectForKey:@"error"] intValue] == 1){
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:userNotExist delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else {
                        [self showAlert];
                    }
                }
                else {
                    [self showAlert];
                }
                
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",error);
                [self showAlert];
            }];
        }
        else {
            //show internet not available
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:netError message:netErrorMessage delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
#pragma mark - showAlert
-(void)showAlert {
    //common error message
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:serviceError delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - tapClose
- (IBAction)tapClose:(id)sender {
    //end editing
    [self.view endEditing:YES];
}
#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ForgotPassword2VC"]) {
        //move to forgotpassword2vc
    }
}
#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    //set status bar color
    return UIStatusBarStyleLightContent;
}
@end

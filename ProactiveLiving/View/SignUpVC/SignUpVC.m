//
//  SignUpVC.m
//  ProactiveLiving
//
//  Created by Hitesh on 1/13/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

#import "SignUpVC.h"
#import "SignUpCell.h"
#import "Defines.h"
#import "Services.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SignUpVC ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    
    //all fields to be field by user, middlename is optional, rest all mandatory
    NSString *firstName;
    NSString *middleName;
    NSString *lastName;
    NSString *cellNumber;
    NSString *emailId;
    NSString *password;
    NSString *confirmPassword;
    NSString *zipCode;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *termsAndConditionsButton;
@property (strong, nonatomic) NSDictionary *detailDictionary;

@end

@implementation SignUpVC
#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitialView];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark - setInitialView
-(void)setInitialView {
    
    //setup initial view
    
    firstName = @"";
    middleName = @"";
    lastName = @"";
    cellNumber = @"";
    emailId = @"";
    password = @"";
    confirmPassword = @"";
    zipCode = @"";
    
    //add keyboard observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //set attributed text
    UIFont *font = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"I agree with Terms and Conditions"];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [attrString addAttribute:NSForegroundColorAttributeName value:iAgreeColor range:NSMakeRange(0, 13)];
    [self.termsAndConditionsButton setAttributedTitle:attrString forState:UIControlStateNormal];
}
#pragma mark - keyboardwillshow
-(void)keyboardWillShow:(NSNotification *)notification {
    //set inset of tableview, for smooth scrolling when keyboard is shown
    CGSize keyBoardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = keyBoardSize.height + 20;
    self.tableView.contentInset = inset;
}
#pragma mark - keyboardwillhide
-(void)keyboardWillHide:(NSNotification *)notification {
    //reset inset
    self.tableView.contentInset = UIEdgeInsetsZero;
    
}
#pragma mark - back
- (IBAction)back:(id)sender {
    //back to previous view controller
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - uitableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //set height of cell
    return 55;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows in tableview
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SignUpCell";
    SignUpCell *cell = (SignUpCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.textField.text = @"";
    cell.imageView.image = nil;
    cell.leadingImageViewConstraint.constant = 30;
    [cell.textField setKeyboardType:UIKeyboardTypeDefault];
    [cell.textField setReturnKeyType:UIReturnKeyNext];
    cell.textField.inputAccessoryView = nil;
    cell.textField.secureTextEntry = NO;

    
    if (indexPath.row == 0) {
        cell.textField.placeholder = @"First Name";
        [cell.textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        cell.textField.text = firstName;
        cell.imageView.image = [UIImage imageNamed:@"signupName"];

    }
    else if (indexPath.row == 1) {
        cell.textField.placeholder = @"Middle Name";
        [cell.textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        cell.textField.text = middleName;
        cell.imageView.image = [UIImage imageNamed:@"signupName"];
    }
    else if (indexPath.row == 2) {
        cell.textField.placeholder = @"Last Name";
        [cell.textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        cell.textField.text = lastName;
        cell.imageView.image = [UIImage imageNamed:@"signupName"];
    }
    else if (indexPath.row == 3) {
        cell.textField.placeholder = @"Cell Number";
        cell.textField.text = cellNumber;
        cell.imageView.image = [UIImage imageNamed:@"signupCellNumber"];
        [cell.textField setKeyboardType:UIKeyboardTypePhonePad];
        
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        numberToolbar.barStyle = UIBarStyleDefault;
        numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPhonePad)], [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(donePhonePad)]];
        [numberToolbar sizeToFit];
        cell.textField.inputAccessoryView = numberToolbar;
    }
    else if (indexPath.row == 4) {
        cell.textField.placeholder = @"Email ID";
        cell.textField.text = emailId;
        cell.imageView.image = [UIImage imageNamed:@"signupMail"];
        [cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
    }
    else if (indexPath.row == 5) {
        cell.textField.placeholder = @"Password";
        cell.textField.text = password;
        cell.imageView.image = [UIImage imageNamed:@"signupPassword"];
        cell.textField.secureTextEntry = YES;
    }
    else if (indexPath.row == 6) {
        cell.textField.placeholder = @"Confirm Password";
        cell.textField.text = confirmPassword;
        cell.imageView.image = [UIImage imageNamed:@"signupConfirmPassword"];
        cell.leadingImageViewConstraint.constant = 33;
        cell.textField.secureTextEntry = YES;
    }
    else {
        cell.textField.placeholder = @"ZipCode";
        cell.textField.text = zipCode;
        cell.imageView.image = [UIImage imageNamed:@"signupLocation"];
        [cell.textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [cell.textField setReturnKeyType:UIReturnKeyDone];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}
#pragma mark - cancelPhonePad
-(void)cancelPhonePad {
    //cancel editing
    [self.view endEditing:YES];
}
#pragma mark - dontPhonePad
-(void)donePhonePad {
    //done editing
    NSIndexPath *indexPath;
    
    indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    SignUpCell *cell = (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}
#pragma mark - getCurrentRow
-(long)getCurrentRow:(UITextField*)textField {
    //get current row of textfield
    CGRect buttonFrameInTableView = [textField convertRect:textField.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    return indexPath.row;
}
#pragma mark - textfield
- (void)textFieldDidEndEditing:(UITextField *)textField{
    long rowNo = [self getCurrentRow:textField];
    
    //set content in respective field, when editing done
    if (rowNo == 0) {
        firstName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if (rowNo == 1) {
        middleName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if (rowNo == 2) {
        lastName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if (rowNo == 3) {
        cellNumber = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if (rowNo == 4) {
        emailId = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if (rowNo == 5) {
        password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if (rowNo == 6) {
        confirmPassword = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if (rowNo == 7) {
        zipCode = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSIndexPath *indexPath;
    
    long rowNo = [self getCurrentRow:textField];
    NSLog(@"Row number %ld",rowNo);

    indexPath = [NSIndexPath indexPathForRow:rowNo+1 inSection:0];
    SignUpCell *cell = (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    

    if (rowNo == 0) {
        //firstname
        [cell.textField becomeFirstResponder];
    }
    else if (rowNo == 1) {
        [cell.textField becomeFirstResponder];
    }
    else if (rowNo == 2) {
        [cell.textField becomeFirstResponder];
    }
    else if (rowNo == 3) {
        [cell.textField becomeFirstResponder];
    }
    else if (rowNo == 4) {
        [cell.textField becomeFirstResponder];
    }
    else if (rowNo == 5) {
        [cell.textField becomeFirstResponder];
    }
    else if (rowNo == 6) {
        [cell.textField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    
//    long rowNo = [self getCurrentRow:textField];
//    NSLog(@"%ld",rowNo);
//    if (rowNo == 0) {
//        //firstname
//        NSLog(@"%d",[string isEqualToString:filtered]);
//        return [string isEqualToString:filtered];
//    }
//    else if (rowNo == 1) {
//        //middlename
//        return [string isEqualToString:filtered];
//    }
//    else if (rowNo == 2) {
//        //lastname
//        return [string isEqualToString:filtered];
//    }
//    else if (rowNo == 3) {
//        //cellnumber
//        
//    }
//    else if (rowNo == 4) {
//        //email
//        
//    }
//    else if (rowNo == 5) {
//        //password
//        
//    }
//    else if (rowNo == 6) {
//        //confirm password
//        
//    }
//    else {
//        //zipcode
//        return [string isEqualToString:filtered];
//        
//    }
    
    //no spaces allowed in the start of text

    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if(str.length > 0 && [[str substringToIndex:1] isEqualToString:@" "]) {
        return NO;
    }
    
    //restrict text to maxlength
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > maxLength) ? NO : YES;

    return YES;
}
#pragma mark - alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            NSIndexPath *indexPath;
            SignUpCell *cell;
            if ([[firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                cell= (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.textField becomeFirstResponder];
            }
            else if ([[lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                cell= (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.textField becomeFirstResponder];
            }
            else if ([[cellNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                cell= (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.textField becomeFirstResponder];
            }
            else if ([[emailId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
                cell= (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.textField becomeFirstResponder];
            }
            else if ([[password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                cell= (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.textField becomeFirstResponder];
            }
            else if ([[confirmPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
                cell= (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.textField becomeFirstResponder];
            }
            else if ([[zipCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
                cell= (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.textField becomeFirstResponder];
            }
        }
    }
    else if (alertView.tag == 101 && buttonIndex == 0){
        password = @"";
        confirmPassword = @"";
        [self.tableView reloadData];
        
        NSIndexPath *indexPath;
        SignUpCell *cell;
        indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        cell = (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }
    else if (alertView.tag == 102 && buttonIndex == 0) {
        emailId = @"";
        [self.tableView reloadData];
        
        NSIndexPath *indexPath;
        SignUpCell *cell;
        indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        cell = (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }
    else if (alertView.tag == 103 && buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (alertView.tag == 104 && buttonIndex == 0){
        cellNumber = @"";
        [self.tableView reloadData];
        
        NSIndexPath *indexPath;
        SignUpCell *cell;
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        cell = (SignUpCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }
}
#pragma mark - checkAllFieldsFilled
-(BOOL)checkAllFieldsFilled {

    if ([[firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return NO;
    }
    else if ([[lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return NO;
    }
    else if ([[cellNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return NO;
    }
    else if ([[emailId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return NO;
    }
    else if ([[password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return NO;
    }
    else if ([[confirmPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return NO;
    }
    else if ([[zipCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return NO;
    }
    else {
        return YES;
    }
}
#pragma mark - email validation
-(BOOL)emailValidate:(NSString *)email1
{
    if([email1 rangeOfString:@"@"].location==NSNotFound || [email1 rangeOfString:@"."].location==NSNotFound)
    {
        return YES;
    }
    NSString *accountName=[email1 substringToIndex: [email1 rangeOfString:@"@"].location];
    email1=[email1 substringFromIndex:[email1 rangeOfString:@"@"].location+1];
    if([email1 rangeOfString:@"."].location==NSNotFound)
    {
        return YES;
    }
    NSString *domainName=[email1 substringToIndex:[email1 rangeOfString:@"."].location];
    NSString *subDomain=[email1 substringFromIndex:[email1 rangeOfString:@"."].location+1];
    
    NSString *unWantedInUName = @" ~!@#$^&*()={}[]|;':\"<>,?/`";
    NSString *unWantedInDomain = @" ~!@#$%^&*()={}[]|;':\"<>,+?/`";
    NSString *unWantedInSub = @" `~!@#$%^&*()={}[]:\";'<>,?/1234567890";
    if(subDomain.length < 2)
    {
        return YES;
    }
    if([accountName isEqualToString:@""] || [accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location!=NSNotFound || [domainName isEqualToString:@""] || [domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location!=NSNotFound || [subDomain isEqualToString:@""] || [subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location!=NSNotFound)
    {
        return YES;
    }
    return NO;
}

#pragma mark - signUp
- (IBAction)signUp:(id)sender {
    [self.view endEditing:YES];
    
    if (![self checkAllFieldsFilled]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:allMandatory delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 100;
        [alert show];
    }
    else if ([[cellNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < minimumPhoneLength){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:validCellNumber delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 104;
        [alert show];
    }
    else if ([self emailValidate:[emailId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:invalidEmail delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 102;
        [alert show];
    }
    else if (![[password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[confirmPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:passwordMismatch delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];
    }
    else if ([[password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < minimumPasswordLength){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:validPassword delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];
    }
    else if (!self.termsAndConditionsButton.isSelected){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:requiredTitle message:terms delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        if ([AppDelegate checkInternetConnection]) {
            [SVProgressHUD showWithStatus:@"Signing Up" maskType:SVProgressHUDMaskTypeBlack];
            NSDictionary *parameters;
            
            parameters = @{@"AppKey" : AppKey,
                           @"firstName" : firstName,
                           @"middleName" : middleName,
                           @"lastName" : lastName,
                           @"email" : emailId,
                           @"password" : password,
                           @"mobilePhone" : cellNumber,
                           @"zipCode" : zipCode};
            
            [Services serviceCallWithPath:ServiceRegister withParam:parameters success:^(NSDictionary *responseDict) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",responseDict);
                self.detailDictionary = responseDict;
                
                NSLog(@"%@",self.detailDictionary);
                
                if (![[self.detailDictionary objectForKey:@"error"] isKindOfClass:[NSNull class]] && [self.detailDictionary objectForKey:@"error"]) {
                    if ([[self.detailDictionary objectForKey:@"error"] intValue] == 0) {
                        // success signup
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:signUpSuccess delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil];
                        alert.tag = 103;
                        [alert show];
                    }
                    else if ([[self.detailDictionary objectForKey:@"error"] intValue] == 1){
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:userExist delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:netError message:netErrorMessage delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
            [alert show];
        }
    }
  
}
#pragma mark - showAlert
-(void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:serviceError delegate:nil cancelButtonTitle:ok otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - preferredStatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - termsAndConditions
- (IBAction)termsAndConditions:(id)sender {
    [self.termsAndConditionsButton setSelected:!self.termsAndConditionsButton.isSelected];
}

@end

//
//  RegistrationViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "RegistrationViewController.h"

@implementation RegistrationViewController
@synthesize registerBtn;
@synthesize agreeBtn;
@synthesize scrollView;
@synthesize registrationFieldsTableView;


#define kCellHeight		44.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.title=@"Registration";
//    self.registrationFieldsTableView.backgroundColor = [UIColor clearColor];
//	self.registrationFieldsTableView.sectionFooterHeight = 0;
//	self.registrationFieldsTableView.sectionHeaderHeight = 0;
//    self.registrationFieldsTableView.separatorColor=[UIColor clearColor];
    self.registrationFieldsTableView.scrollEnabled=YES;
    self.registrationFieldsTableView.backgroundColor = [UIColor clearColor];
    
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
	scrollView.scrollEnabled = FALSE;
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    regFlag=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTap:) name:@"scrollViewTouchEvent" object:nil];
    
    UIBarButtonItem *tempBtn = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleDone target:self action:@selector(continueBtnTouchUpInsideHandler:)];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0){
        [tempBtn setTintColor:[UIColor colorWithRed:60.0/255.0 green:144.0/255.0 blue:220.0/255.0 alpha:1]];
    }
    self.navigationItem.rightBarButtonItem = tempBtn;
    [tempBtn release];
    
    
    usernameTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 13, 280, 30)];
    usernameTF.adjustsFontSizeToFitWidth = YES;
    usernameTF.textColor = [UIColor blackColor];
    usernameTF.backgroundColor = [UIColor clearColor];
    usernameTF.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameTF.textAlignment = UITextAlignmentLeft;
    usernameTF.clearButtonMode = UITextFieldViewModeNever;
    usernameTF.delegate = self;
    usernameTF.placeholder = @"Full Name";
    usernameTF.keyboardType = UIKeyboardTypeDefault;
    usernameTF.returnKeyType = UIReturnKeyNext;
    usernameTF.tag = 1;
//    usernameTF.text = username;
    
    emailTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 13, 280, 30)];
    emailTF.adjustsFontSizeToFitWidth = YES;
    emailTF.textColor = [UIColor blackColor];
    emailTF.backgroundColor = [UIColor clearColor];
    emailTF.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailTF.textAlignment = UITextAlignmentLeft;
    emailTF.clearButtonMode = UITextFieldViewModeNever;
    emailTF.delegate = self;
    emailTF.placeholder = @"Email Address";
    emailTF.keyboardType = UIKeyboardTypeEmailAddress;
    emailTF.returnKeyType = UIReturnKeyNext;
    emailTF.tag = 2;
//    emailTF.text = email;
    
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 13, 280, 30)];
    passwordTF.adjustsFontSizeToFitWidth = YES;
    passwordTF.textColor = [UIColor blackColor];
    passwordTF.backgroundColor = [UIColor clearColor];
    passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTF.textAlignment = UITextAlignmentLeft;
    passwordTF.clearButtonMode = UITextFieldViewModeNever;
    passwordTF.delegate = self;
    passwordTF.placeholder = @"Password";
    passwordTF.keyboardType = UIKeyboardTypeDefault;
    passwordTF.returnKeyType = UIReturnKeyNext;
    passwordTF.secureTextEntry = YES;
    passwordTF.tag = 3;
//    passwordTF.text = password;
    
    confirmPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 13, 280, 30)];
    confirmPasswordTF.adjustsFontSizeToFitWidth = YES;
    confirmPasswordTF.textColor = [UIColor blackColor];
    confirmPasswordTF.backgroundColor = [UIColor clearColor];
    confirmPasswordTF.autocorrectionType = UITextAutocorrectionTypeNo;
    confirmPasswordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    confirmPasswordTF.textAlignment = UITextAlignmentLeft;
    confirmPasswordTF.clearButtonMode = UITextFieldViewModeNever;
    confirmPasswordTF.delegate = self;
    confirmPasswordTF.placeholder = @"Confirm Password";
    confirmPasswordTF.keyboardType = UIKeyboardTypeDefault;
    confirmPasswordTF.returnKeyType = UIReturnKeyNext;
    confirmPasswordTF.secureTextEntry = YES;
    confirmPasswordTF.tag = 4;
//    confirmPasswordTF.text = confirmPassword;

    zipcodeTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 13, 280, 30)];
    zipcodeTF.adjustsFontSizeToFitWidth = YES;
    zipcodeTF.textColor = [UIColor blackColor];
    zipcodeTF.backgroundColor = [UIColor clearColor];
    zipcodeTF.autocorrectionType = UITextAutocorrectionTypeNo;
    zipcodeTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    zipcodeTF.textAlignment = UITextAlignmentLeft;
    zipcodeTF.clearButtonMode = UITextFieldViewModeNever;
    zipcodeTF.delegate = self;
    zipcodeTF.placeholder = @"Zip or Postal Code";
    zipcodeTF.keyboardType = UIKeyboardTypeDefault;
    zipcodeTF.returnKeyType = UIReturnKeyNext;
    zipcodeTF.tag = 6;
//    zipcodeTF.text = zipcode;

    mobileNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 13, 280, 30)];
    mobileNumberTF.adjustsFontSizeToFitWidth = YES;
    mobileNumberTF.textColor = [UIColor blackColor];
    mobileNumberTF.backgroundColor = [UIColor clearColor];
    mobileNumberTF.autocorrectionType = UITextAutocorrectionTypeNo;
    mobileNumberTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mobileNumberTF.textAlignment = UITextAlignmentLeft;
    mobileNumberTF.clearButtonMode = UITextFieldViewModeNever;
    mobileNumberTF.delegate = self;
    mobileNumberTF.placeholder = @"Phone Number";
    mobileNumberTF.keyboardType = UIKeyboardTypeDefault;
    mobileNumberTF.returnKeyType = UIReturnKeyDone;
    mobileNumberTF.tag = 5;
//    mobileNumberTF.text = mobileNumber;

}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    //if you want to dismiss the controller presented, you can do that here or the method btnBackClicked
    return NO;
}

- (void)viewDidUnload
{
    [self setRegistrationFieldsTableView:nil];
    [self setScrollView:nil];
    [self setAgreeBtn:nil];
    [self setRegisterBtn:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    [registrationFieldsTableView release];
    [scrollView release];
    [networkManager release];
    [agreeBtn release];
    [registerBtn release];
    [scrollView release];
    [super dealloc];
    NSLog(@"In dealloc of RegistrationViewController");
}


#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return 1;
    }
    else if(section == 2){
        return 2;
    }
    else if(section == 3){
        return 1;
    }
    else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Personal Information";
    if(section == 4)
        return @"Mobile Phone Information";
    else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RegCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
        if(indexPath.section == 0){
            [usernameTF setEnabled:YES];
            [cell addSubview:usernameTF];
        }
        else if(indexPath.section == 1){
            [emailTF setEnabled:YES];
            [cell addSubview:emailTF];
        }
        else if(indexPath.section == 2){
            if(indexPath.row == 0){
                [passwordTF setEnabled:YES];
                [cell addSubview:passwordTF];
            }
            else {
                [confirmPasswordTF setEnabled:YES];
                [cell addSubview:confirmPasswordTF];
            }
        }
        else if(indexPath.section == 3){
            [zipcodeTF setEnabled:YES];
            [cell addSubview:zipcodeTF];
        }
        else if(indexPath.section == 4){
            [mobileNumberTF setEnabled:YES];
            [cell addSubview:mobileNumberTF];
        }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self dismissKeyboard];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods Implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0.0, 88.0) animated:YES];
    scrollView.contentSize = CGSizeMake(320, 700);
    scrollView.scrollEnabled = FALSE;
    
    if(textField.tag==3 ||textField.tag==4)
    {
        [self.registrationFieldsTableView setContentOffset:CGPointMake(0, 140) animated:YES];
    }
    else if(textField.tag==1 || textField.tag==2){
        [self.registrationFieldsTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(textField.tag==5 || textField.tag==6){
        [self.registrationFieldsTableView setContentOffset:CGPointMake(0, 240) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    CustomTextFieldCell *cell;
//    NSIndexPath *indexPath;
    
    if(textField.tag==1)
    {
//        indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
//        cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:indexPath];
//        [cell.valueTextField becomeFirstResponder];
        [emailTF becomeFirstResponder];
    }
    if(textField.tag==2)
    {
//        indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
//        cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:indexPath];
//        [cell.valueTextField becomeFirstResponder];
        [passwordTF becomeFirstResponder];
    }
    if(textField.tag==3)
    {
//        indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
//        cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:indexPath];
//        [cell.valueTextField becomeFirstResponder];
        [confirmPasswordTF becomeFirstResponder];
    }

    if(textField.tag==4)
    {
//        indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
//        cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:indexPath];
//        [cell.valueTextField becomeFirstResponder];
        [zipcodeTF becomeFirstResponder];
    }

    if(textField.tag==6)
    {
//        indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
//        cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:indexPath];
//        [cell.valueTextField becomeFirstResponder];
        [mobileNumberTF becomeFirstResponder];
    }
    if(textField.tag == 5){
        [self dismissKeyboard];
    }

    return TRUE;
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishSigningUp:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
    }
}

#pragma mark -

- (IBAction)termsAndConditionsTouchUpInsideHandler:(id)sender {
    [self dismissKeyboard];
    [self goToTermsAndConditionsView];
}

- (IBAction)agreeBtnTouchUpInsideHandler:(id)sender {
    if(regFlag==0)
    {
        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateNormal];
        regFlag=1;
    }
    else
    {
        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
        regFlag=0;
    }
}

- (IBAction)continueBtnTouchUpInsideHandler:(id)sender {
    [self dismissKeyboard];
    
    if([self validate])
    {
        [networkManager signUp:[self populate]];
    }
}

#pragma mark-

-(void)dismissKeyboard
{
    [usernameTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    [confirmPasswordTF resignFirstResponder];
    [emailTF resignFirstResponder];
    [zipcodeTF resignFirstResponder];
    [mobileNumberTF resignFirstResponder];
//    if(mobileNumberTF.isFirstResponder)
//        [mobileNumberTF resignFirstResponder];
    
    /*NSIndexPath *userNameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	CustomTextFieldCell *cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:userNameIndexPath];
    [cell.valueTextField resignFirstResponder];
    
    NSIndexPath *emailIdIndexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:emailIdIndexPath];
    [cell.valueTextField resignFirstResponder]; 
    
    NSIndexPath *confirmPasswordIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
	cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:confirmPasswordIndexPath];
    [cell.valueTextField resignFirstResponder];
    
    NSIndexPath *passwordIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
	cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:passwordIndexPath];
	[cell.valueTextField resignFirstResponder];
    
    NSIndexPath *mobileIndexPath=[NSIndexPath indexPathForRow:4 inSection:0];
    cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:mobileIndexPath];
    [cell.valueTextField resignFirstResponder];
    
    NSIndexPath *zipcodeIndexPath=[NSIndexPath indexPathForRow:5 inSection:0];
    cell = (CustomTextFieldCell *)[registrationFieldsTableView cellForRowAtIndexPath:zipcodeIndexPath];
    [cell.valueTextField resignFirstResponder];*/
    
    [self.registrationFieldsTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
	scrollView.scrollEnabled = FALSE;

}
-(Registration *)populate
{
    
    Registration *registrationDetails=[[DatabaseManager sharedInstance] getRegistrationObject];
    [registrationDetails setValue:usernameTF.text forKey:@"username"];
    [registrationDetails setValue:passwordTF.text forKey:@"password"];
    [registrationDetails setValue:confirmPasswordTF.text forKey:@"confirm_password"];
    [registrationDetails setValue:emailTF.text forKey:@"email"];
    [registrationDetails setValue:mobileNumberTF.text forKey:@"mobile"];
    [registrationDetails setValue:zipcodeTF.text forKey:@"zipcode"];
    return registrationDetails;
}

-(BOOL) validate
{
//    [self populateFields];
    if(usernameTF.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
        return NO;
    }
    if(emailTF.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Email Id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
        return NO;
    }
    if(emailTF.text.length!=0)
    {
        if(![self validateEmail:emailTF.text])
        {
            UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter valid Email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [logInAlert show];
            [logInAlert release];
            return NO;
        }
    }
    
    if(passwordTF.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
        return NO;
    }
    if(confirmPasswordTF.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Confirm Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
        return NO;
    }
    if(![passwordTF.text isEqualToString:confirmPasswordTF.text])
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Password and Confirm Password should be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
        return NO;
    }
    if(regFlag==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Please Accept the Terms and Conditions to Register" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
        return NO;
    }
    return YES;
}

- (BOOL) validateEmail: (NSString *) emailId
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	BOOL isValid = [emailTest evaluateWithObject:emailId];
	return isValid;
}

-(void)handleTap:(NSNotification *) notification
{
    [self dismissKeyboard];
}

#pragma mark-

-(void) goToTermsAndConditionsView
{
    TermsAndConditionsViewController *termsAndConditionsViewController = [[TermsAndConditionsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:termsAndConditionsViewController animated:YES];
    [termsAndConditionsViewController release];
}

@end

//
//  RegistrationViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "RegistrationViewController.h"
#import "User.h"
#import "Utilities.h"

@implementation RegistrationViewController
@synthesize scrollView;
@synthesize registrationFieldsTableView;

#define kCellHeight		44.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.title=@"Registration";
    self.registrationFieldsTableView.scrollEnabled=YES;
    self.registrationFieldsTableView.backgroundColor = [UIColor clearColor];
    
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
	scrollView.scrollEnabled = FALSE;
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTap:) name:@"scrollViewTouchEvent" object:nil];
    
    /*
    UIBarButtonItem *tempBtn = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleDone target:self action:@selector(continueBtnTouchUpInsideHandler:)];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        [tempBtn setTintColor:[UIColor colorWithRed:60.0/255.0 green:144.0/255.0 blue:220.0/255.0 alpha:1]];
    }
    self.navigationItem.rightBarButtonItem = tempBtn;
     */
    
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
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    //if you want to dismiss the controller presented, you can do that here or the method btnBackClicked
    return NO;
}

- (void)viewDidUnload
{
    [self setRegistrationFieldsTableView:nil];
    [self setScrollView:nil];
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

- (void)dealloc
{
    NSLog(@"In dealloc of RegistrationViewController");
}


#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        // Full name
        return 1;
    }
    else if(section == 1)
    {
        // Email
        return 1;
    }
    else if(section == 2)
    {
        // Passwords
        return 2;
    }
    else if(section == 3)
    {
        // Zip code
        return 1;
    }
    else
    {
        // Phone number
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Personal Information";
    }
    if(section == 4)
    {
        return @"Mobile Phone Information";
    }
    else
    {
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RegCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    if(indexPath.section == 0)
    {
        [usernameTF setEnabled:YES];
        [cell addSubview:usernameTF];
    }
    else if(indexPath.section == 1)
    {
        [emailTF setEnabled:YES];
        [cell addSubview:emailTF];
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            [passwordTF setEnabled:YES];
            [cell addSubview:passwordTF];
        }
        else
        {
            [confirmPasswordTF setEnabled:YES];
            [cell addSubview:confirmPasswordTF];
        }
    }
    else if(indexPath.section == 3)
    {
        [zipcodeTF setEnabled:YES];
        [cell addSubview:zipcodeTF];
    }
    else if(indexPath.section == 4)
    {
        [mobileNumberTF setEnabled:YES];
        [cell addSubview:mobileNumberTF];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
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
    else if(textField.tag==1 || textField.tag==2)
    {
        [self.registrationFieldsTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(textField.tag==5 || textField.tag==6)
    {
        [self.registrationFieldsTableView setContentOffset:CGPointMake(0, 240) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField.tag==1)
    {
        [emailTF becomeFirstResponder];
    }
    if(textField.tag==2)
    {
        [passwordTF becomeFirstResponder];
    }
    if(textField.tag==3)
    {
        [confirmPasswordTF becomeFirstResponder];
    }

    if(textField.tag==4)
    {
        [zipcodeTF becomeFirstResponder];
    }

    if(textField.tag==6)
    {
        [mobileNumberTF becomeFirstResponder];
    }
    if(textField.tag == 5)
    {
        [self dismissKeyboard];
    }

    return TRUE;
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishEmailSignup:(BOOL)success statusMessage:(NSString *)message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
    if(success)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
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
    }
}

#pragma mark -

- (IBAction)continueBtnTouchUpInsideHandler:(id)sender
{
    [self dismissKeyboard];
    
    if([self validate])
    {
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"Registering User";
        
        // Set the values into the User instance
        [User getInstance].username = usernameTF.text;
        [User getInstance].email = emailTF.text;
        [User getInstance].password = passwordTF.text;
        [User getInstance].phone = mobileNumberTF.text;
        [User getInstance].zipcode = zipcodeTF.text;
                                    
        //[networkManager signUp:[self populate]];
        [[User getInstance] registerUserWithEmail:self];
    }
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(BOOL)success, NSString* message
{
    NSLog(@"In didCompleteHttpCallback");
    [self didFinishEmailSignup:success statusMessage:message];
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
    
    [self.registrationFieldsTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
	scrollView.scrollEnabled = FALSE;

}

-(BOOL) validate
{
    if(usernameTF.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    if(emailTF.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Email Id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    if(emailTF.text.length!=0)
    {
        if(![Utilities validateEmail:emailTF.text])
        {
            UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter valid Email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [logInAlert show];
            return NO;
        }
    }
    
    if(passwordTF.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    if(confirmPasswordTF.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Confirm Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    if(![passwordTF.text isEqualToString:confirmPasswordTF.text])
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Password and Confirm Password should be same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    return YES;
}

-(void)handleTap:(NSNotification *) notification
{
    [self dismissKeyboard];
}

@end

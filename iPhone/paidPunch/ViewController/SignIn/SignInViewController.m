//
//  SignInViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "SignInViewController.h"
#import "AppDelegate.h"
#import "RegistrationViewController.h"

@implementation SignInViewController

@synthesize signInTableView;
@synthesize scrollView;

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
    self.title=@"Login";
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
	scrollView.scrollEnabled = FALSE;
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTap:) name:@"scrollViewTouchEvent" object:nil];
    
    signInTableView.bounces = NO;
    signInTableView.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    //[self requestAppIp];
}

- (void)viewDidUnload
{
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
    NSLog(@"In dealloc of SignInViewController");
}

#pragma mark -
#pragma mark TextFieldDelegate methods Implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.secureTextEntry == YES)
    {
        [self.scrollView setContentOffset:CGPointMake(0.0, 111.0) animated:YES];
        scrollView.contentSize = CGSizeMake(320, 600);
        scrollView.scrollEnabled = TRUE;
    }
    else {
        [self.scrollView setContentOffset:CGPointMake(0.0, 111) animated:YES];
        scrollView.contentSize = CGSizeMake(320, 600);
        scrollView.scrollEnabled = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.secureTextEntry == NO)
    {
        [passwordTextField becomeFirstResponder];
    }
    else {
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
        scrollView.scrollEnabled = FALSE;
        [textField resignFirstResponder];
        [passwordTextField resignFirstResponder];
    }
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self populateFields];
}


#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishLogin:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        [[DatabaseManager sharedInstance] deleteAllPunchCards];
        [[DatabaseManager sharedInstance] deleteBusinesses];
        
        // TODO: Replace with new login approach
        
        [self goToTabBarView];
    }
    else
    {
        signInBtn.enabled=YES;
        passwordTextField.text=@"";
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
    }
}

-(void) didFinishLoadingAppURL:(NSString *)url
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:url forKey:@"appUrl"];
    [ud synchronize];
}

-(void) didFinishSendingForgotPasswordRequest:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void) didConnectionFailed :(NSString *)responseStatus
{
    signInBtn.enabled=YES;
}

#pragma mark -

- (IBAction)forgotPasswordTouchUpInsideHandler:(id)sender {
    if (usernameTextField.text.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if(![self validateEmail:usernameTextField.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter valid Email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [self forgotPasswordRequest:usernameTextField.text];
        }
        
    }
}

- (IBAction)signInBtnTouchUpInsideHandler:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
	scrollView.scrollEnabled = FALSE;
    
    signInBtn.enabled=YES;
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    if([self validate])
    {
        [networkManager login:username loginPassword:password];
    }
    //[self goToTabBarView];
}

- (IBAction)signUpBtnTouchUpInsideHandler:(id)sender {
    [self goToSignUpView];
}

- (void)loginButtonTouched:(id)sender {
    if([self validate]) {
        [networkManager login:username loginPassword:password];
    }
}

#pragma mark -

-(void)populateFields
{
    username=usernameTextField.text;
    password=passwordTextField.text;
}

- (BOOL) validateEmail: (NSString *) emailId
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	BOOL isValid = [emailTest evaluateWithObject:emailId];
	return isValid;
}

-(BOOL)validate
{
    [self populateFields];
    if(username.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Enter Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    if(![self validateEmail:usernameTextField.text])
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter valid Email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    if(password.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Enter Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    return YES;
}

-(void) forgotPasswordRequest:(NSString *)emailId
{
    [networkManager forgotPassword:emailId];
}

-(void) requestAppIp
{
    [networkManager appIpRequest];
}

-(void)handleTap:(NSNotification *) notification
{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    scrollView.scrollEnabled = FALSE;
}


#pragma mark -

-(void) goToTabBarView
{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    PaidPunchTabBarController *tabBarViewController = [[PaidPunchTabBarController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController presentModalViewController:tabBarViewController animated:NO];
}

-(void) goToSignUpView
{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    RegistrationViewController *signUpViewController = [[RegistrationViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

#pragma mark -
#pragma mark UITableView Deelgate Method Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }
    else if(section == 1){
        return 1;
    }
    else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SignCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if(indexPath.section == 0){
        UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
        inputTextField.adjustsFontSizeToFitWidth = YES;
        inputTextField.textColor = [UIColor blackColor];
        inputTextField.backgroundColor = [UIColor clearColor];
        inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        inputTextField.textAlignment = UITextAlignmentLeft;
        inputTextField.clearButtonMode = UITextFieldViewModeNever;
        
        inputTextField.delegate = self;
        
        if(indexPath.row == 0){
            inputTextField.placeholder = @"example@example.com";
            inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
            inputTextField.returnKeyType = UIReturnKeyNext;
            [[cell textLabel] setText:@"Email"];
            
            usernameTextField = inputTextField;
        }
        else if(indexPath.row == 1){
            inputTextField.placeholder = @"your password";
            inputTextField.keyboardType = UIKeyboardTypeDefault;
            inputTextField.secureTextEntry = YES;
            inputTextField.returnKeyType = UIReturnKeyDone;
            [[cell textLabel] setText:@"Password"];
            
            passwordTextField = inputTextField;
        }
        
        [inputTextField setEnabled:YES];
        [cell addSubview:inputTextField];
    }
    else if(indexPath.section == 1){
        /*UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        loginButton.frame = CGRectMake(0, 0, 300, 44);
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        loginButton.titleLabel.textAlignment = UITextAlignmentCenter;
        loginButton.backgroundColor = [UIColor clearColor];
        [loginButton addTarget:self action:@selector(loginButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:loginButton];
        [loginButton release];*/
        cell.textLabel.text = @"Login";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    else if(indexPath.section == 2){
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row == 0){
            cell.textLabel.text = @"Sign Up";
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = @"Forgot Password?";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 && indexPath.row == 0){
        [self loginButtonTouched:nil];
        [usernameTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
        
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
        scrollView.scrollEnabled = FALSE;
    }
    if(indexPath.section == 2){
        if(indexPath.row == 0){
            //Sign Up
            [self goToSignUpView];
        }
        else {
            //Forgot Password
            [self forgotPasswordTouchUpInsideHandler:nil];
        }
    }
    
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES] ;
    scrollView.scrollEnabled = FALSE;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end

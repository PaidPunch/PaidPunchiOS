//
//  SettingsViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize usernameLbl;
@synthesize mobileNoTextField;
@synthesize emailTextField;
@synthesize emailLbl;
@synthesize mobileNoLbl;
@synthesize updateBtn;
@synthesize changePwdBtn;
@synthesize creditCardBtn;
@synthesize signOutBtn;
@synthesize myAccountsBg;

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
    self.navigationController.navigationBarHidden = YES;
    self.title = [NSString stringWithFormat:@"%@",@"My Account"];
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    self.usernameLbl.text=[[InfoExpert sharedInstance] username];
    emailTextField.enabled=NO;
    emailTextField.text=[[InfoExpert sharedInstance] email];
    mobileNoTextField.text=[[InfoExpert sharedInstance]mobileNumber];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *s=[defaults objectForKey:@"LoggedInFromFacebook"];
    
    if([s isEqualToString:@"YES"])
    {
        self.emailLbl.hidden=YES;
        self.emailTextField.hidden=YES;
        self.usernameLbl.hidden=YES;
        self.mobileNoLbl.hidden=YES;
        self.mobileNoTextField.hidden=YES;
        self.updateBtn.hidden=YES;
        self.changePwdBtn.hidden=YES;
        self.myAccountsBg.hidden=NO;
        self.creditCardBtn.frame=CGRectMake(8, 150, 305, 44);
        self.signOutBtn.frame = CGRectMake(8, 202, 305, 44);
    }
    else
    {
        self.myAccountsBg.hidden=YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidUnload
{
    [self setEmailTextField:nil];
    [self setMobileNoTextField:nil];
    [self setUsernameLbl:nil];
    [self setEmailLbl:nil];
    [self setMobileNoLbl:nil];
    [self setUpdateBtn:nil];
    [self setChangePwdBtn:nil];
    [self setCreditCardBtn:nil];
    [self setMyAccountsBg:nil];
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
    [emailTextField release];
    [mobileNoTextField release];
    [networkManager release];
    [usernameLbl release];
    [emailLbl release];
    [mobileNoLbl release];
    [updateBtn release];
    [changePwdBtn release];
    [creditCardBtn release];
    [myAccountsBg release];
    [super dealloc];
    NSLog(@"In dealloc of SettingsViewController");
}

#pragma mark -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mobileNoTextField resignFirstResponder];
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishLoggingOut:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        [ud setObject:@"NO" forKey:@"loggedIn"];
        [ud synchronize];
        
        [[DatabaseManager sharedInstance] deleteAllPunchCards];
        /*//clear the cache for images
        SDImageCache *imageCache=[SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache clearDisk];
        [imageCache cleanDisk];*/
        
        [self goToDualSignInView];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) didFinishUpdate:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
    }
    else
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        [logInAlert release];
    }
    
}

-(void) didFinishLoadingAppURL:(NSString *)url
{
    [[InfoExpert sharedInstance] setAppUrl:url];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:url forKey:@"appUrl"];
    [ud synchronize];
    
}

-(void) didConnectionFailed :(NSString *)responseStatus
{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable) 
	{		
        [self requestAppIp];
    }
}

-(void) didFinishGettingProfile:(NSString *)statusCode statusMessage:(NSString *)message withMaskedId:(NSString *)maskedId withPaymentId:(NSString *)paymentId
{
    if([statusCode isEqualToString:@"00"])
    {
        [self goToCreditCardSettingsView:maskedId];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

#pragma mark -

- (IBAction)changePwdBtnTouchUpInsideHandler:(id)sender {
    [self goToChangePasswordView];
}

- (IBAction)saveBtnTouchUpInsideHandler:(id)sender {
    [mobileNoTextField resignFirstResponder];
    [networkManager update:emailTextField.text withMobileNumber:mobileNoTextField.text loggedInUserId:[[InfoExpert sharedInstance]userId]];
}

- (IBAction)signOutBtnTouchUpInsideHandler:(id)sender {
    [networkManager logout:[[InfoExpert sharedInstance]userId]];
    //[self goToDualSignInView];
}

- (IBAction)creditCardBtnTouchUpInsideHandler:(id)sender {
    if([[InfoExpert sharedInstance] isProfileCreated])
    {
        [networkManager getProfileRequest:[[InfoExpert sharedInstance] userId] withName:@""];
    }
    else
    {
        [self goToCreditCardSettingsView:nil];
    }
}

#pragma mark -

-(void) goToDualSignInView
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initView];
}

-(void) goToChangePasswordView
{
    ChangePasswordViewController *changePasswordView = [[ChangePasswordViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:changePasswordView animated:YES];
    [changePasswordView release];
}

-(void) goToCreditCardSettingsView:(NSString *)maskedId
{
    CreditCardSettingsViewController *creditCardSettingsView = [[CreditCardSettingsViewController alloc] init:maskedId];
    [self.navigationController pushViewController:creditCardSettingsView animated:YES];
    [creditCardSettingsView release];
}

#pragma mark -

-(void) requestAppIp
{
    [networkManager appIpRequest];
}

@end

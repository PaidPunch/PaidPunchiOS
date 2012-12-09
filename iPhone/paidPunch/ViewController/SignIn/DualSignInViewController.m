//
//  DualSignInViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 14/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "DualSignInViewController.h"

@implementation DualSignInViewController
@synthesize highlyrecommendedLbl;

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
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;

    [[InfoExpert sharedInstance] setTotalMilesValue:[NSNumber numberWithInt:10]];
    popupHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:popupHUD];

}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [self requestAppIp];
}

- (void)viewDidUnload
{
    [self setHighlyrecommendedLbl:nil];
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


#pragma mark -
#pragma mark UIAlertViewDelegate methods Implementation

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
    }
    else
    {
        [self goToSignView];
    }
}

#pragma mark -
#pragma mark FBRequestDelegate methods Implementation

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response %@",response);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    
    NSString *name=nil;
    NSString *fbid=nil;
    NSString *email=nil;
    
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"])
    {
         name = [result objectForKey:@"name"];
        if([result objectForKey:@"uid"])
        {
            fbid =[result objectForKey:@"uid"];
        }
        if([result objectForKey:@"email"])
        {
            email=[result objectForKey:@"email"];
        }
        [self apiGraphUserPermissions];
        if(name!=nil && fbid!=nil && email!= nil)
        {
            [self removePopup];
            [networkManager fbLogin:name withEmailId:email withFBId:fbid];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"YES" forKey:@"LoggedInFromFacebook"];
        [defaults synchronize];
    }
    else {
        // Processing permissions information
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}
- (void)requestLoading:(FBRequest *)request
{
}
- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishWithFacebookLogin:(NSString *)statusCode statusMessage:(NSString *)message
{
    
    if([statusCode isEqualToString:@"00"])
    {
        [[DatabaseManager sharedInstance] deleteAllPunchCards];
        [[DatabaseManager sharedInstance] deleteBusinesses];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        [ud setObject:@"YES" forKey:@"loggedIn"];
        //[ud setObject:@"NO" forKey:@"isManualShown"];
        [ud setObject:[[InfoExpert sharedInstance]userId] forKey:@"userId"];
        [ud setObject:[[InfoExpert sharedInstance]email] forKey:@"email"];
        [ud setObject:[[InfoExpert sharedInstance]username] forKey:@"username"];
        [ud setObject:[[InfoExpert sharedInstance]zipcode] forKey:@"zipcode"];
        [ud setObject:[[InfoExpert sharedInstance]mobileNumber] forKey:@"mobileNumber"];
        [ud setObject:[[InfoExpert sharedInstance]password] forKey:@"password"];
        if([[InfoExpert sharedInstance] isProfileCreated])
        {
            [ud setObject:@"YES" forKey:@"isProfileCreated"];
        }
        else
        {
            [ud setObject:@"NO" forKey:@"isProfileCreated"];
        }
        [ud synchronize];
        [self goToTabBarView];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void) didFinishLoadingAppURL:(NSString *)url
{
    [[InfoExpert sharedInstance] setAppUrl:url];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:url forKey:@"appUrl"];
    [ud synchronize];
}

#pragma mark -

- (IBAction)signInWithFacebookBtnTouchUpInsideHandler:(id)sender {
    [[FacebookFacade sharedInstance] setDualSignInViewController:self];
    [[FacebookFacade sharedInstance] apiLogin];
}

- (IBAction)signInWithoutFacebookBtnTouchUpInsideHandler:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You really should sign in with Facebook. If you do, you'll have the ability to unlock free Punches, see what your friends are doing, and brag to friends when you win awesome prizes!" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:@"Continue" ,nil];
    [alert show];
}

- (IBAction)goBack:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark Facebook API Calls

- (void)getUserProfileInfo {
    
    [self showPopup];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name ,email FROM user WHERE uid=me()", @"query",
                                   nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

-(void)loggedIn
{
    [[FacebookFacade sharedInstance] setDualSignInViewController:nil];
    [self getUserProfileInfo];
}

- (void)apiGraphUserPermissions {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/permissions" andDelegate:self];
}

#pragma mark -

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

-(void) requestAppIp
{
    [networkManager appIpRequest];
}

#pragma mark -

-(void) showPopup
{
    /*NSArray *xibUIObjects =[[NSBundle mainBundle] loadNibNamed:@"NetworkActivity" owner:self options:nil];
    activityView= [xibUIObjects objectAtIndex:0];
    activityView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:activityView];
    
    [((UIActivityIndicatorView *)[activityView viewWithTag:2]) setHidden:YES];
    ((UITextView *)[activityView viewWithTag:1]).hidden=YES;*/

    [popupHUD show:YES];
}

-(void) removePopup
{
    // finished loading, hide the activity indicator in the status bar
    /*if([activityView respondsToSelector:@selector(viewWithTag:)])
	{
        [activityView removeFromSuperview];
    }*/
    [popupHUD hide:YES];
}

#pragma mark -

-(void) goToTabBarView
{
    PaidPunchTabBarController *tabBarViewController = [[PaidPunchTabBarController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController presentModalViewController:tabBarViewController animated:NO];
}

-(void) goToSignView
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"NO" forKey:@"LoggedInFromFacebook"];
    [ud synchronize];
    
    SignInViewController *signInViewController = [[SignInViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:signInViewController animated:YES];
}



@end

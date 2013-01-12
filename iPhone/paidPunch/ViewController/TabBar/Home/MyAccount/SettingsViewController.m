//
//  SettingsViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "FreeCreditViewController.h"
#import "InfoChangeViewController.h"
#import "Product.h"
#import "Products.h"
#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize usernameLbl;
@synthesize creditLbl;
@synthesize updateBtn;
@synthesize changePwdBtn;
@synthesize creditCardBtn;
@synthesize signOutBtn;
@synthesize product1Btn;
@synthesize product2Btn;
@synthesize product3Btn;
@synthesize product4Btn;

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
    
    if ([[User getInstance] isFacebookProfile])
    {
        // Hide changePwd button
        [changePwdBtn setHidden:true];
        [changePwdBtn setEnabled:false];
        
        // Centerize signoutbutton so it doesn't look offset
        CGRect newRectFrame = CGRectMake(self.view.frame.size.width/2 - signOutBtn.frame.size.width/2, signOutBtn.frame.origin.y, signOutBtn.frame.size.width, signOutBtn.frame.size.height);
        [signOutBtn setFrame:newRectFrame];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    [creditLbl setText:[[User getInstance] getCreditAsString]];
    [usernameLbl setText:[[User getInstance] username]];
    
    if ([[Products getInstance] needsRefresh])
    {
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"Retrieving Products";
        
        [[Products getInstance] retrieveProductsFromServer:self];
    }
    else
    {
        [self enableValidProductButtons];
    }
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
    NSLog(@"In dealloc of SettingsViewController");
}

#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishLoggingOut:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        // Clear current user on logout
        [[User getInstance] clearUser];
        
        [[DatabaseManager sharedInstance] deleteAllPunchCards];
        /*//clear the cache for images
        SDImageCache *imageCache=[SDImageCache sharedImageCache];
        [imageCache clearMemory];
        [imageCache cleanDisk];*/
        
        [self goToSignInView];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) didFinishUpdate:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
    }
    else
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
    }
    
}

-(void) didFinishLoadingAppURL:(NSString *)url
{
}

-(void) didConnectionFailed :(NSString *)responseStatus
{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable) 
	{		
        //[self requestAppIp];
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
    }
    
}

#pragma mark -

- (IBAction)changePwdBtnTouchUpInsideHandler:(id)sender
{
    [self goToChangePasswordView];
}

- (IBAction)changeInfoBtnTouchUpInsideHandler:(id)sender
{
    [self goToInfoChangeView];
}

- (IBAction)signOutBtnTouchUpInsideHandler:(id)sender
{
    [[User getInstance] clearUser];	
    [self goToSignInView];
}

- (IBAction)creditCardBtnTouchUpInsideHandler:(id)sender
{
    if([[User getInstance] isPaymentProfileCreated])
    {
        [networkManager getProfileRequest:[[User getInstance] userId] withName:@""];
    }
    else
    {
        [self goToCreditCardSettingsView:nil];
    }
}

- (IBAction)freeCreditBtnTouchUpInsideHandler:(id)sender
{
    FreeCreditViewController *freeCreditView = [[FreeCreditViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:freeCreditView animated:YES];
}

#pragma mark -

-(void) goToSignInView
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initView];
}

-(void) goToChangePasswordView
{
    ChangePasswordViewController *changePasswordView = [[ChangePasswordViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:changePasswordView animated:YES];
}

-(void) goToInfoChangeView
{
    InfoChangeViewController *infoChangeView = [[InfoChangeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:infoChangeView animated:YES];
}

-(void) goToCreditCardSettingsView:(NSString *)maskedId
{
    CreditCardSettingsViewController *creditCardSettingsView = [[CreditCardSettingsViewController alloc] init:maskedId];
    [self.navigationController pushViewController:creditCardSettingsView animated:YES];
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(BOOL)success, NSString* message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
    [self enableValidProductButtons];
}

#pragma mark - private
- (void) enableValidProductButtons
{
    NSMutableArray* productsArray = [[Products getInstance] productsArray];
    NSUInteger productsCount = [productsArray count];
    const NSUInteger maxProductsCount = 4;
    NSUInteger index = 0;
    
    // Maximum of 4 products
    while (index < maxProductsCount)
    {
        // Number of products might be less than the max allowed
        if (index < productsCount)
        {
            Product* current = [productsArray objectAtIndex:index];
            
            if (index == 0)
            {
                [product1Btn setTitle:[current desc] forState:UIControlStateNormal];
                product1Btn.hidden = FALSE;
                product1Btn.enabled = TRUE;
            }
            else if (index == 1)
            {
                [product2Btn setTitle:[current desc] forState:UIControlStateNormal];
                product2Btn.hidden = FALSE;
                product2Btn.enabled = TRUE;
            }
            else if (index == 2)
            {
                [product3Btn setTitle:[current desc] forState:UIControlStateNormal];
                product3Btn.hidden = FALSE;
                product3Btn.enabled = TRUE;
            }
            else if (index == 3)
            {
                [product4Btn setTitle:[current desc] forState:UIControlStateNormal];
                product4Btn.hidden = FALSE;
                product4Btn.enabled = TRUE;
            }
            
            index++;
        }
        else
        {
            break;
        }
    }
    
}

@end

//
//  SignUpViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/23/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "DatabaseManager.h"
#import "HiAccuracyLocator.h"
#import "InviteFriendsViewController.h"
#import "SignUpViewController.h"
#import "User.h"
#import "Utilities.h"

static NSString* termsURL = @"http://home.paidpunch.com/terms-of-use.jsp";

@implementation SignUpViewController

- (id)initWithInviteCode:(NSString*)inviteCode
{
    self = [super init];
    if (self)
    {
        _inviteCode = inviteCode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createMainView:[UIColor whiteColor]];
	
    // Create nav bar on top
    [self createNavBar:@"Back" rightString:nil middle:@"Sign Up" isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    // Create sign up buttons
    [self createSignInOrUpButtons:@"Sign Up" fbAction:@selector(didPressFacebookButton:) emailAction:@selector(didPressEmailButton:)];
    
    // Create terms label and link
    [self createTermsOfUse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private function

- (void)createTermsOfUse
{
    UIFont* termsFont = [UIFont fontWithName:@"Helvetica" size:13.0f];
    UIFont* termsLinkFont = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
    
    // Label for terms and conditions
    NSString* termsLabelString = @"By signing up, you agree to our ";
    CGSize sizeTermsLabelText = [termsLabelString sizeWithFont:termsFont
                                             constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                                 lineBreakMode:UILineBreakModeWordWrap];
    UILabel *termsLabel = [[UILabel alloc] initWithFrame:CGRectMake((stdiPhoneWidth - sizeTermsLabelText.width)/2, [self lowestYPos] + 10, sizeTermsLabelText.width, sizeTermsLabelText.height)];
    termsLabel.text = termsLabelString;
    termsLabel.backgroundColor = [UIColor clearColor];
    termsLabel.textColor = [UIColor blackColor];
    [termsLabel setNumberOfLines:1];
    [termsLabel setFont:termsFont];
    termsLabel.textAlignment = UITextAlignmentLeft;
    
    // Create link for terms and conditions
    UIButton* termsLink = [UIButton buttonWithType:UIButtonTypeCustom];
    [termsLink addTarget:self action:@selector(didPressTermsButton:) forControlEvents:UIControlEventTouchUpInside];
    NSString* termsLinkString = @"terms of use, privacy policy and return policy";
    CGSize sizeTermsLinkText = [termsLinkString sizeWithFont:termsLinkFont
                                           constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                               lineBreakMode:UILineBreakModeWordWrap];
    [termsLink setFrame:CGRectMake((stdiPhoneWidth - sizeTermsLinkText.width)/2, termsLabel.frame.origin.y + termsLabel.frame.size.height + 3, sizeTermsLinkText.width, sizeTermsLinkText.height)];
    [termsLink setTitle:termsLinkString forState:UIControlStateNormal];
    [termsLink setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    termsLink.titleLabel.font = termsLinkFont;
    
    [_scrollview addSubview:termsLabel];
    [_scrollview addSubview:termsLink];
}

-(BOOL) validate
{
    if(_emailTextField.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Email Id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    if(_emailTextField.text.length!=0)
    {
        if(![Utilities validateEmail:_emailTextField.text])
        {
            UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter valid Email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [logInAlert show];
            return NO;
        }
    }
    
    if(_passwordTextField.text.length==0)
    {
        UIAlertView *logInAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Error" message:@"Enter Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logInAlert show];
        return NO;
    }
    return YES;
}

#pragma mark - event actions

- (void)didPressFacebookButton:(id)sender
{
    [self dismissKeyboard];
    
    // Store the current referralCode
    [[User getInstance] setReferralCode:_inviteCode];
    
    // This indicates it's a facebook signup
    _emailSignup = FALSE;
    
    [[HiAccuracyLocator getInstance] setDelegate:self];
    [[HiAccuracyLocator getInstance] startUpdatingLocation];
}

- (void)didPressEmailButton:(id)sender
{
    [self dismissKeyboard];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Registering User";
    
    // Store the current referralCode
    [[User getInstance] setReferralCode:_inviteCode];
    
    if([self validate])
    {        
        // Set the values into the User instance
        [User getInstance].email = _emailTextField.text;
        
        _emailSignup = TRUE;
        
        [[HiAccuracyLocator getInstance] setDelegate:self];
        [[HiAccuracyLocator getInstance] startUpdatingLocation];
    }
}

- (void)didPressTermsButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:termsURL]];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // This is called on email registration success, where we take the use back to the main welcome screen
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initView];
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
    if(success)
    {
        if ([type compare:kKeyUsersFacebookPermission] == NSOrderedSame)
        {
            _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Registering User";
            
            [[User getInstance] registerUserWithFacebookToPaidPunch:self];
        }
        else
        {
            [[DatabaseManager sharedInstance] deleteAllPunchCards];
            [[DatabaseManager sharedInstance] deleteBusinesses];
            
            if ([type compare:kKeyUsersEmailRegister] == NSOrderedSame)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                InviteFriendsViewController *inviteFriendsViewController = [[InviteFriendsViewController alloc] init:FALSE duringSignup:TRUE];
                [self.navigationController pushViewController:inviteFriendsViewController animated:NO];
            }
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - HiAccuracyLocatorDelegate
- (void) locator:(HiAccuracyLocator *)locator didLocateUser:(BOOL)didLocateUser reason:(StopReason)reason
{
    if(didLocateUser)
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:[[HiAccuracyLocator getInstance] bestLocation] completionHandler:^(NSArray *placemarks, NSError *error)
         {
             NSLog(@"**reverseGeocodeLocation:completionHandler: Completion Handler called!");
             
             if (error)
             {
                 NSLog(@"**Geocode failed with error: %@", error);
                 return;
                 
             }
             
             if(placemarks && placemarks.count > 0)
                 
             {
                 //do something
                 CLPlacemark *topResult = [placemarks objectAtIndex:0];
                 NSLog(@"**Geocode successful; zip code: %@", [topResult postalCode]);
                 
                 [[User getInstance] setZipcode:[topResult postalCode]];
                 
                 if (_emailSignup)
                 {
                     [[User getInstance] registerUserWithEmail:self password:_passwordTextField.text];
                 }
                 else
                 {
                     [[User getInstance] registerUserWithFacebook:self];
                 }
             }
         }];
    }
    else
    {
        if (reason == kStopReasonDenied)
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Unable to locate!" message:@"We were not find your current location. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    }
}

@end

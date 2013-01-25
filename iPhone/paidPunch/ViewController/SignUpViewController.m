//
//  SignUpViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/23/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "DatabaseManager.h"
#import "SignUpViewController.h"
#import "User.h"
#import "Utilities.h"

static NSString* termsURL = @"http://home.paidpunch.com/terms-of-use.jsp";

@implementation SignUpViewController
@synthesize inviteCode = _inviteCode;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
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
    [User getInstance].referralCode = _inviteCode;
    
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Registering User";
    
    [[User getInstance] registerUserWithFacebook:self];
}

- (void)didPressEmailButton:(id)sender
{
    [self dismissKeyboard];
    
    // Store the current referralCode
    [User getInstance].referralCode = _inviteCode;
    
    if([self validate])
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"Registering User";
        
        // Set the values into the User instance
        [User getInstance].email = _emailTextField.text;
        
        // Register user
        [[User getInstance] registerUserWithEmail:self password:_passwordTextField.text];
    }
}

- (void)didPressTermsButton:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:termsURL]];
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type, BOOL success, NSString* message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
    if(success)
    {
        [[DatabaseManager sharedInstance] deleteAllPunchCards];
        [[DatabaseManager sharedInstance] deleteBusinesses];
        
        //PaidPunchTabBarController *tabBarViewController = [[PaidPunchTabBarController alloc] initWithNibName:nil bundle:nil];
        //[self.navigationController presentModalViewController:tabBarViewController animated:NO];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end

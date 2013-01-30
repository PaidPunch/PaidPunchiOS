//
//  LoginViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/24/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "LoginViewController.h"
#import "PaidPunchHomeViewController.h"
#import "User.h"
#import "Utilities.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        // Use old school NetworkManager for ForgetPassword call
        _networkManager=[[NetworkManager alloc] init];
        _networkManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createMainView:[UIColor whiteColor]];
	
    // Create nav bar on top
    [self createNavBar:@"Back" rightString:nil middle:@"Sign In" isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    // Create sign up buttons
    [self createSignInOrUpButtons:@"Sign In" fbAction:@selector(didPressFacebookButton:) emailAction:@selector(didPressEmailButton:)];
    
    // Forgot Password button
    [self createForgotPasswordButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createForgotPasswordButton
{
    UIFont* textFont = [UIFont fontWithName:@"ArialMT" size:14.0f];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"grey-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, _lowestYPos + 10, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:150 maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    
    forgotPasswordButton.frame = finalRect;
    [forgotPasswordButton setBackgroundImage:image forState:UIControlStateNormal];
    [forgotPasswordButton setTitle:@"Forgot Password" forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forgotPasswordButton.titleLabel.font = textFont;
    [forgotPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgotPasswordButton addTarget:self action:@selector(didPressForgotPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollview addSubview:forgotPasswordButton];
}

#pragma mark - event actions

- (void)didPressFacebookButton:(id)sender
{
    [self dismissKeyboard];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Logging in";
    
    [[User getInstance] loginUserWithFacebook:self];
}

- (void)didPressEmailButton:(id)sender
{
    [self dismissKeyboard];
    
    [User getInstance].email = _emailTextField.text;
    
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Logging in";
    
    [[User getInstance] loginUserWithEmail:self password:_passwordTextField.text];
}

- (void)didPressForgotPasswordButton:(id)sender
{
    [self dismissKeyboard];
    
    if (_emailTextField.text.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if(![Utilities validateEmail:_emailTextField.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter valid Email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Checking for password";
            
            [_networkManager forgotPassword:_emailTextField.text];
        }
        
    }
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type, BOOL success, NSString* message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
    if(success)
    {
        [[DatabaseManager sharedInstance] deleteAllPunchCards];
        [[DatabaseManager sharedInstance] deleteBusinesses];
        
        PaidPunchHomeViewController *homeViewController = [[PaidPunchHomeViewController alloc] init];
        [self.navigationController pushViewController:homeViewController animated:NO];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Callback delegate for forgot password request

-(void) didFinishSendingForgotPasswordRequest:(NSString *)statusCode statusMessage:(NSString *)message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
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

@end

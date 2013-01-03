//
//  LoginView.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/8/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "DatabaseManager.h"
#import "LoginView.h"
#import "User.h"
#import "Utilities.h"

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat distanceFromTop = 30;
        CGFloat textHeight = 50;
        CGFloat constrainedSize = 265.0f;
        UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
        UIFont* buttonFont = [UIFont systemFontOfSize:13];
        UIColor* separatorColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        CGFloat textFieldWidth = frame.size.width - 40;
        CGFloat leftSpacing = (frame.size.width - textFieldWidth)/2;
        
        // Create textfield for email
        CGRect emailFrame = CGRectMake(leftSpacing, distanceFromTop, textFieldWidth, textHeight);
        _emailTextField = [self initializeUITextField:emailFrame placeholder:@"Email: example@example.com" font:textFont];
        
        // Create textfield for password
        CGRect passwordFrame = CGRectMake(leftSpacing, emailFrame.size.height + emailFrame.origin.y + 5, textFieldWidth, textHeight);
        _passwordTextField = [self initializeUITextField:passwordFrame placeholder:@"Password" font:textFont];
        _passwordTextField.secureTextEntry = TRUE;
        
        // Create login button
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [loginButton addTarget:self action:@selector(didPressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        NSString* loginText = @"Sign In";
        CGSize sizeLoginText = [loginText sizeWithFont:buttonFont
                                     constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                         lineBreakMode:UILineBreakModeWordWrap];
        CGFloat loginButtonWidth = sizeLoginText.width + 30;
        CGFloat loginButtonHeight = sizeLoginText.height + 10;
        [loginButton setFrame:CGRectMake(frame.size.width - leftSpacing - loginButtonWidth, passwordFrame.size.height + passwordFrame.origin.y + 10, loginButtonWidth, loginButtonHeight)];
        [loginButton setTitle:loginText forState:UIControlStateNormal];
        loginButton.titleLabel.font = buttonFont;
        
        // Create forgot password button
        UIButton* forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [forgotPasswordButton addTarget:self action:@selector(didPressForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
        NSString* forgotPasswordText = @"Forgot Password";
        CGSize sizeforgotPasswordText = [forgotPasswordText sizeWithFont:buttonFont
                                                       constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                                           lineBreakMode:UILineBreakModeWordWrap];
        CGFloat forgotPasswordButtonWidth = sizeforgotPasswordText.width + 30;
        CGFloat forgotPasswordButtonHeight = sizeforgotPasswordText.height + 10;
        [forgotPasswordButton setFrame:CGRectMake(leftSpacing, passwordFrame.size.height + passwordFrame.origin.y + 10, forgotPasswordButtonWidth, forgotPasswordButtonHeight)];
        [forgotPasswordButton setTitle:forgotPasswordText forState:UIControlStateNormal];
        forgotPasswordButton.titleLabel.font = buttonFont;
        
        // Create OR label
        CGFloat orLabelYPos = forgotPasswordButton.frame.size.height + forgotPasswordButton.frame.origin.y + 20;
        NSString* lbtext = @" or ";
        CGSize sizeText = [lbtext sizeWithFont:textFont
                             constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                 lineBreakMode:UILineBreakModeWordWrap];
        UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - sizeText.width)/2, orLabelYPos, sizeText.width, sizeText.height)];
        orLabel.text = lbtext;
        orLabel.backgroundColor = [UIColor clearColor];
        orLabel.textColor = separatorColor;
        [orLabel setNumberOfLines:1];
        [orLabel setFont:textFont];
        orLabel.textAlignment = UITextAlignmentLeft;
        
        // Draw horizontal lines
        CGFloat hortLineYPos = orLabelYPos + (orLabel.frame.size.height/2);
        CGFloat hortLineWidth = (frame.size.width - leftSpacing*2 - orLabel.frame.size.width)/2;
        UIView *hortLine1 = [[UIView alloc] initWithFrame:CGRectMake(leftSpacing, hortLineYPos, hortLineWidth, 1.0)];
        UIView *hortLine2 = [[UIView alloc] initWithFrame:CGRectMake(leftSpacing + hortLineWidth + orLabel.frame.size.width, hortLineYPos, hortLineWidth, 1.0)];
        hortLine1.backgroundColor = separatorColor;
        hortLine2.backgroundColor = separatorColor;
        
        // Insert facebook signup/signin image        
        [self createFacebookButton:@"          Sign In With Facebook" framewidth:frame.size.width yPos:orLabel.frame.origin.y + orLabel.frame.size.height + 20 textFont:textFont action:@selector(didPressFacebookButton:)];
        
        [self addSubview:_emailTextField];
        [self addSubview:_passwordTextField];
        [self addSubview:orLabel];
        [self addSubview:hortLine1];
        [self addSubview:hortLine2];
        [self addSubview:loginButton];
        [self addSubview:forgotPasswordButton];
        
        // Use old school NetworkManager for ForgetPassword call
        _networkManager=[[NetworkManager alloc] init];
        _networkManager.delegate = self;
    }
    return self;
}

- (void) dismissKeyboard
{
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void) didPressFacebookButton:(id)sender
{
    [self dismissKeyboard];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Logging in";
    
    [[User getInstance] loginUserWithFacebook:self];
}

- (void) didPressLoginButton:(id)sender
{
    [self dismissKeyboard];
    
    [User getInstance].email = _emailTextField.text;
    [User getInstance].password = _passwordTextField.text;
    
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"Logging in";
    
    [[User getInstance] loginUserWithEmail:self];
}

- (void) didPressForgetPasswordButton:(id)sender
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
- (void) didCompleteHttpCallback:(BOOL)success, NSString* message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
    if(success)
    {
        [[DatabaseManager sharedInstance] deleteAllPunchCards];
        [[DatabaseManager sharedInstance] deleteBusinesses];
        
        PaidPunchTabBarController *tabBarViewController = [[PaidPunchTabBarController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController presentModalViewController:tabBarViewController animated:NO];
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

//
//  SignupView.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/8/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "SignupView.h"
#import "RegistrationViewController.h"
#import "TermsAndConditionsViewController.h"
#import "User.h"

static NSUInteger kMinReferralCodeSize = 5;
static NSUInteger kMaxReferralCodeSize = 10;

@implementation SignupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialize checkbox to not set
        checked = FALSE;
        
        CGFloat distanceFromTop = 30;
        CGFloat textHeight = 50;
        CGFloat constrainedSize = 265.0f;
        UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
        UIFont* termsFont = [UIFont fontWithName:@"Helvetica" size:12.0f];
        UIFont* termsLinkFont = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
        
        CGFloat textFieldWidth = frame.size.width - 40;
        CGFloat leftSpacing = (frame.size.width - textFieldWidth)/2;
        
        // Create textfield for referral code
        CGRect referralFrame = CGRectMake(leftSpacing, distanceFromTop, textFieldWidth, textHeight);
        referralTextField = [self initializeUITextField:referralFrame placeholder:@"Referral code: A1B2C" font:textFont];
        
        // Create checkbox for terms and conditions
        CGFloat termsYPos = referralFrame.size.height + referralFrame.origin.y + 10;
        checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkbox addTarget:self action:@selector(didPressCheckboxButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat loginButtonWidth = 25;
        CGFloat loginButtonHeight = 25;
        [checkbox setFrame:CGRectMake(leftSpacing, termsYPos, loginButtonWidth, loginButtonHeight)];
        NSString *uncheckedPath = [[NSBundle mainBundle] pathForResource:@"Unchecked" ofType:@"png"];
        NSData *uncheckedImageData = [NSData dataWithContentsOfFile:uncheckedPath];
        // Store up the different images for future use
        uncheckedImage = [[UIImage alloc] initWithData:uncheckedImageData];
        checkedImage = [UIImage imageNamed:@"Checked.png"];
        [checkbox setImage:uncheckedImage forState:UIControlStateNormal];
        
        // Label for terms and conditions
        NSString* termsLabelString = @"I Agree To PaidPunch";
        CGSize sizeTermsLabelText = [termsLabelString sizeWithFont:termsFont
                                                 constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                                     lineBreakMode:UILineBreakModeWordWrap];
        UILabel *termsLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkbox.frame.origin.x + checkbox.frame.size.width + 5, termsYPos, sizeTermsLabelText.width, loginButtonHeight)];
        termsLabel.text = termsLabelString;
        termsLabel.backgroundColor = [UIColor clearColor];
        termsLabel.textColor = [UIColor whiteColor];
        [termsLabel setNumberOfLines:1];
        [termsLabel setFont:termsFont];
        termsLabel.textAlignment = UITextAlignmentLeft;
        
        // Create link for terms and conditions
        UIButton* termsLink = [UIButton buttonWithType:UIButtonTypeCustom];
        [termsLink addTarget:self action:@selector(didPressTermsButton:) forControlEvents:UIControlEventTouchUpInside];
        NSString* termsLinkString = @"Terms & Conditions";
        CGSize sizeTermsLinkText = [termsLinkString sizeWithFont:termsLinkFont
                                               constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                                   lineBreakMode:UILineBreakModeWordWrap];
        [termsLink setFrame:CGRectMake(termsLabel.frame.origin.x + termsLabel.frame.size.width + 5, termsYPos, sizeTermsLinkText.width, loginButtonHeight+1)];
        [termsLink setTitle:termsLinkString forState:UIControlStateNormal];
        [termsLink setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        termsLink.titleLabel.font = termsLinkFont;
        
        // Draw horizontal line
        CGFloat hortLineYPos = termsLink.frame.origin.y + termsLink.frame.size.height + 10;
        CGFloat hortLineWidth = frame.size.width - (leftSpacing*2);
        UIView *hortLine = [[UIView alloc] initWithFrame:CGRectMake(leftSpacing, hortLineYPos, hortLineWidth, 1.0)];
        hortLine.backgroundColor = [UIColor whiteColor];
        
        // Insert facebook signup/signin image
        [self createFacebookButton:@"          Sign Up With Facebook" framewidth:frame.size.width yPos:hortLine.frame.origin.y + hortLine.frame.size.height + 20 textFont:textFont action:@selector(didPressFacebookButton:)];
        
        // Create Signup by Email button
        UIButton* emailSignupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [emailSignupButton addTarget:self action:@selector(didPressEmailSignupButton:) forControlEvents:UIControlEventTouchUpInside];
        NSString* emailSignupText = @"Sign Up With Email";
        CGSize sizeEmailSignupText = [emailSignupText sizeWithFont:textFont
                                                 constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                                     lineBreakMode:UILineBreakModeWordWrap];
        CGFloat emailSignupButtonWidth = sizeEmailSignupText.width + 30;
        CGFloat emailSignupButtonHeight = sizeEmailSignupText.height + 10;
        [emailSignupButton setFrame:CGRectMake(frame.size.width/2 - emailSignupButtonWidth/2, self.btnFacebook.frame.size.height + self.btnFacebook.frame.origin.y + 20, emailSignupButtonWidth, emailSignupButtonHeight)];
        [emailSignupButton setTitle:emailSignupText forState:UIControlStateNormal];
        emailSignupButton.titleLabel.font = textFont;
        
        [self addSubview:referralTextField];
        [self addSubview:termsLabel];
        [self addSubview:termsLink];
        [self addSubview:hortLine];
        [self addSubview:checkbox];
        [self addSubview:emailSignupButton];
    }
    return self;
}

- (void) dismissKeyboard
{
    // Dismiss keyboard for all textfields
    [referralTextField resignFirstResponder];
}

- (BOOL) validateInputs:(NSString*) referralCode
{
    BOOL success = FALSE;
    if (!checked)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Terms and Conditions"
                                                          message:@"Please accept PaidPunch Terms and Conditions before continuing."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else if (referralCode == nil || referralCode == @"" )
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Missing Referral Code"
                                                          message:@"Please enter a referral code before continuing."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else if (referralCode.length < kMinReferralCodeSize || referralCode.length > kMaxReferralCodeSize)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Referral Code Invalid"
                                                          message:@"Please enter a valid referral code before continuing."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else
    {
        success = TRUE;
    }
    return success;
}

- (void) didPressCheckboxButton:(id)sender
{
    // Toggle the checkbox image
    if(!checked)
    {
        [checkbox setImage:checkedImage forState:UIControlStateNormal];
        checked = TRUE;
    }
    else
    {
        [checkbox setImage:uncheckedImage forState:UIControlStateNormal];
        checked = FALSE;
    }
}

- (void) didPressTermsButton:(id)sender
{
    TermsAndConditionsViewController *termsAndConditionsViewController = [[TermsAndConditionsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:termsAndConditionsViewController animated:YES];
}

- (void) didPressFacebookButton:(id)sender
{
    [self dismissKeyboard];
    
    NSString* referralCode = [referralTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([self validateInputs:referralCode])
    {
        // Store the current referralCode
        [User getInstance].referralCode = referralCode;
        
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText = @"Registering User";
        
        [[User getInstance] registerUserWithFacebook:self];
    }
}

- (void) didPressEmailSignupButton:(id)sender
{
    [self dismissKeyboard];
    
    NSString* referralCode = [referralTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([self validateInputs:referralCode])
    {
        // Store the current referralCode
        [User getInstance].referralCode = referralCode;
        
        RegistrationViewController *signUpViewController = [[RegistrationViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:signUpViewController animated:YES];
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

@end

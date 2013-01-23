//
//  WelcomePageViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/22/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WelcomePageViewController.h"

static CGFloat const stdiPhoneWidth = 320.0;
static CGFloat const stdiPhoneHeight = 480.0;
static NSUInteger kMinInviteCodeSize = 5;
static NSUInteger kMaxInviteCodeSize = 10;

typedef enum
{
    leftJustify,
    centerJustify,
    rightJustify
} JustificationType;

@implementation WelcomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	
    [self createView];
    
    [self createInvitePopupView];
    
    _fadeTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (void)createView
{
    CGRect mainRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    _mainView = [[UIView alloc] initWithFrame:mainRect];
    _mainView.backgroundColor = [UIColor whiteColor];
    
    // Create logo image at top of view
    UIImageView* logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CompanyLogo.png"]];
    logoImage.frame = CGRectMake((stdiPhoneWidth - logoImage.frame.size.width)/2, 10.0, logoImage.frame.size.width, logoImage.frame.size.height);
    [_mainView addSubview:logoImage];
    
    // Create cross fading images in the middle
    _imageFiles = [NSArray arrayWithObjects:@"InformationPlacardThree.png", @"InformationPlacardTwo.png", @"InformationPlacardOne.png", nil];
    _currentIndex = 0;
    UIImage* currentImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [_imageFiles objectAtIndex:_currentIndex]]];
    CGRect imageRect = CGRectMake(0, logoImage.frame.origin.y + logoImage.frame.size.height + 20, stdiPhoneWidth, currentImage.size.height);
    _mainImageView = [[UIImageView alloc] initWithFrame:imageRect];
    [_mainImageView setImage:currentImage];
    [_mainView addSubview:_mainImageView];
    
    // Create white label across the images with upsell text
    CGFloat constrainedSize = 265.0f;
    UIFont* upsellFont = [UIFont fontWithName:@"Helvetica" size:18.0f];
    NSString* upsellString = @"  Save money every visit at ";
    CGSize sizeUpsellString = [upsellString sizeWithFont:upsellFont
                                       constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _mainImageView.frame.origin.y + 40, stdiPhoneWidth, sizeUpsellString.height + 20)];
    textLabel.text = upsellString;
    textLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    textLabel.textColor = [UIColor blackColor];
    [textLabel setNumberOfLines:1];
    [textLabel setFont:upsellFont];
    textLabel.textAlignment = UITextAlignmentLeft;
    [_mainView addSubview:textLabel];
    
    // Create clear label with business types in orange text
    _businessTypeTexts = [NSArray arrayWithObjects:@"spas", @"pizzerias", @"salons", nil];
    UIFont* businessTypeFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    _businessTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(sizeUpsellString.width, _mainImageView.frame.origin.y + 40, stdiPhoneWidth - sizeUpsellString.width, sizeUpsellString.height + 20)];
    _businessTypeLabel.text = [_businessTypeTexts objectAtIndex:_currentIndex];
    _businessTypeLabel.backgroundColor = [UIColor clearColor];
    _businessTypeLabel.textColor = [UIColor orangeColor];
    [_businessTypeLabel setNumberOfLines:1];
    [_businessTypeLabel setFont:businessTypeFont];
    _businessTypeLabel.textAlignment = UITextAlignmentLeft;
    [_mainView addSubview:_businessTypeLabel];
    
    // Create signup button
    CGFloat ypos = _mainImageView.frame.origin.y + _mainImageView.frame.size.height + 20;
    CGFloat xpos = 20;
    _signupButton = [self createButton:@"Sign Up" xpos:xpos ypos:ypos justification:leftJustify action:@selector(didPressSignupButton:)];
    [_mainView addSubview:_signupButton];
    
    // Create signin button
    _signinButton = [self createButton:@"Sign In" xpos:xpos ypos:ypos justification:rightJustify action:@selector(didPressSigninButton:)];
    [_mainView addSubview:_signinButton];
    
    // Create invisible label layer
    _greyoutLabel = [[UILabel alloc] initWithFrame:mainRect];
    [self toggleGreyoutLabel:FALSE];
    [_mainView addSubview:_greyoutLabel];
    
    self.view = _mainView;
}

- (void)createInvitePopupView
{
    CGFloat inviteViewWidth = stdiPhoneWidth - 40;
    CGFloat inviteViewHeight = stdiPhoneHeight - 160;
    CGRect inviteRect = CGRectMake((stdiPhoneWidth - inviteViewWidth)/2, (stdiPhoneHeight - inviteViewHeight)/2, inviteViewWidth, inviteViewHeight);
    _inviteView = [[UIView alloc] initWithFrame:inviteRect];
    _inviteView.backgroundColor = [UIColor whiteColor];
    _inviteView.layer.cornerRadius = 5;
    _inviteView.layer.masksToBounds = NO;
    _inviteView.layer.shadowOffset = CGSizeMake(-10, 10);
    _inviteView.layer.shadowRadius = 5;
    _inviteView.layer.shadowOpacity = 0.5;
    
    // Invitation Only label
    CGFloat constrainedSize = 265.0f;
    UIFont* inviteOnlyFont = [UIFont fontWithName:@"Arial-BoldMT" size:20.0f];
    NSString* inviteOnlyString = @"Invitation Only";
    CGSize sizeInviteOnlyString = [inviteOnlyString sizeWithFont:inviteOnlyFont
                                               constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                                   lineBreakMode:UILineBreakModeWordWrap];
    UILabel *inviteOnlyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, inviteViewWidth, sizeInviteOnlyString.height + 20)];
    inviteOnlyLabel.text = inviteOnlyString;
    inviteOnlyLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    inviteOnlyLabel.textColor = [UIColor blackColor];
    [inviteOnlyLabel setNumberOfLines:1];
    [inviteOnlyLabel setFont:inviteOnlyFont];
    inviteOnlyLabel.textAlignment = UITextAlignmentCenter;
    [_inviteView addSubview:inviteOnlyLabel];
    
    // Explanation lable
    UIFont* explanationFont = [UIFont fontWithName:@"ArialMT" size:17.0f];
    NSString* explanationString = @"PaidPunch is an exclusive network.\rYou need an invitation code.";
    CGSize sizeExplanationString = [explanationString sizeWithFont:explanationFont
                                                          forWidth:inviteViewWidth
                                                     lineBreakMode:UILineBreakModeWordWrap];
    UILabel *explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, inviteOnlyLabel.frame.origin.y + inviteOnlyLabel.frame.size.height + 5, inviteViewWidth, sizeExplanationString.height + 20)];
    explanationLabel.text = explanationString;
    explanationLabel.backgroundColor = [UIColor clearColor];
    explanationLabel.textColor = [UIColor blackColor];
    [explanationLabel setNumberOfLines:2];
    [explanationLabel setFont:explanationFont];
    [explanationLabel setLineBreakMode:NSLineBreakByWordWrapping];
    explanationLabel.textAlignment = UITextAlignmentCenter;
    [_inviteView addSubview:explanationLabel];
    
    // Invite code textfield
    NSString* inviteCodeText = @"Invite code: A1B2C";
    CGSize sizeInviteCodeString = [inviteCodeText sizeWithFont:explanationFont
                                                          forWidth:inviteViewWidth
                                                     lineBreakMode:UILineBreakModeWordWrap];
    CGFloat inviteCodeLabelWidth = sizeInviteCodeString.width + 20;
    CGFloat inviteCodeLabelHeight = sizeInviteCodeString.height + 10;
    CGRect inviteCodeFrame = CGRectMake((inviteViewWidth - inviteCodeLabelWidth)/2, explanationLabel.frame.origin.y + explanationLabel.frame.size.height + 20, inviteCodeLabelWidth, inviteCodeLabelHeight);
    _inviteCodeTextField = [self initializeUITextField:inviteCodeFrame placeholder:inviteCodeText font:explanationFont];
    _inviteCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    // Grey background bar for textfield
    CGFloat greybarLabelHeight = inviteCodeLabelHeight + 20;
    CGFloat greybarLabelYPos = inviteCodeFrame.origin.y - ((greybarLabelHeight - inviteCodeLabelHeight)/2);
    UILabel *greybarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, greybarLabelYPos, inviteViewWidth, greybarLabelHeight)];
    greybarLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    // Put grey label into view first, so it appears behind textfield
    [_inviteView addSubview:greybarLabel];
    [_inviteView addSubview:_inviteCodeTextField];
    
    // Create continue button
    CGFloat ContinueYPos = greybarLabel.frame.origin.y + greybarLabel.frame.size.height + 20;
    _continueButton = [self createButton:@"Continue" xpos:inviteViewWidth ypos:ContinueYPos justification:centerJustify action:@selector(didPressContinueButton:)];
    [_inviteView addSubview:_continueButton];
    
    // Create request invite button
    CGFloat requestYPos = _continueButton.frame.origin.y + _continueButton.frame.size.height + 20;
    _requestInviteButton = [self createButton:@"Request Invite" xpos:inviteViewWidth ypos:requestYPos justification:centerJustify action:@selector(didPressRequestInviteButton:)];
    [_inviteView addSubview:_requestInviteButton];
}

- (UITextField*) initializeUITextField:(CGRect)frame placeholder:(NSString*)placeholder font:(UIFont*)font
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = font;
    textField.placeholder = placeholder;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    return textField;
}

- (UIButton*)createButton:(NSString*)buttonText xpos:(CGFloat)xpos ypos:(CGFloat)ypos justification:(JustificationType)justification action:(SEL)action
{
    CGFloat constrainedSize = 265.0f;
    UIFont* buttonFont = [UIFont fontWithName:@"Helvetica" size:20.0f];
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    CGSize sizeButtonText = [buttonText sizeWithFont:buttonFont
                                   constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                       lineBreakMode:UILineBreakModeWordWrap];
    CGFloat buttonWidth = sizeButtonText.width + 30;
    CGFloat buttonHeight = sizeButtonText.height + 10;
    CGFloat realXPos;
    if (justification == rightJustify)
    {
        realXPos = stdiPhoneWidth - xpos - buttonWidth;
    }
    else if (justification == leftJustify)
    {
        realXPos = xpos;
    }
    else
    {
        // In center justified scenarios, the xpos is actually the main frame width
        realXPos = (xpos - buttonWidth)/2;
    }
    [newButton setFrame:CGRectMake(realXPos, ypos, buttonWidth, buttonHeight)];
    [newButton setTitle:buttonText forState:UIControlStateNormal];
    newButton.titleLabel.font = buttonFont;
    return newButton;
}

- (void)changeImage
{
    _currentIndex++;
    if(_currentIndex == [_imageFiles count])
    {
        _currentIndex = 0;
    }

    UIImage * toImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [_imageFiles objectAtIndex:_currentIndex]]];
    [UIView transitionWithView:self.view
                      duration:1.75f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_mainImageView setImage:toImage];
                        _businessTypeLabel.text = [_businessTypeTexts objectAtIndex:_currentIndex];
                    } completion:NULL];
}

- (void)toggleGreyoutLabel:(BOOL)enable
{
    if (enable)
    {
        _greyoutLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.70];
        _greyoutLabel.enabled = TRUE;
        _signinButton.enabled = FALSE;
        _signupButton.enabled = FALSE;
        [_mainView addSubview:_inviteView];
    }
    else
    {
        _greyoutLabel.backgroundColor = [UIColor clearColor];
        _greyoutLabel.enabled = FALSE;
        _signinButton.enabled = TRUE;
        _signupButton.enabled = TRUE;
        [_inviteView removeFromSuperview];
    }
}

- (BOOL) validateInputs:(NSString*) inviteCode
{
    BOOL success = FALSE;
    if (inviteCode == nil || inviteCode == @"" )
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Missing Invite Code"
                                                          message:@"Please enter a invite code before continuing."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else if (inviteCode.length < kMinInviteCodeSize || inviteCode.length > kMaxInviteCodeSize)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invite Code Invalid"
                                                          message:@"Please enter a valid invite code before continuing."
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

#pragma mark - event actions

- (void)didPressSignupButton:(id)sender
{
    [self toggleGreyoutLabel:TRUE];
}

- (void)didPressSigninButton:(id)sender
{
    
}

- (void)didPressContinueButton:(id)sender
{
     NSString* inviteCode = [_inviteCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self validateInputs:inviteCode])
    {
        
    }
}

- (void)didPressRequestInviteButton:(id)sender
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return (newLength <= kMaxInviteCodeSize) || returnKey;
}

@end
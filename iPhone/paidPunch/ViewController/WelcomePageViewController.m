//
//  WelcomePageViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/22/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "Utilities.h"
#import "WelcomePageViewController.h"

static NSUInteger kMinInviteCodeSize = 5;
static NSUInteger kMaxInviteCodeSize = 10;

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
    UIImageView* logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"landing-top-logo.png"]];
    logoImage.frame = CGRectMake(0, 0, logoImage.frame.size.width, logoImage.frame.size.height);
    logoImage.frame = [Utilities resizeProportionally:logoImage.frame maxWidth:stdiPhoneWidth maxHeight:100];
    [_mainView addSubview:logoImage];
    
    // Create cross fading images in the middle
    _imageFiles = [NSArray arrayWithObjects:@"spas.png", @"cafes.png", @"restaurants.png", @"salons.png", @"dry-cleaning.png", @"bars.png", nil];
    _currentIndex = 0;
    UIImage* currentImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [_imageFiles objectAtIndex:_currentIndex]]];
    CGRect imageRect = CGRectMake(0, logoImage.frame.origin.y + logoImage.frame.size.height, stdiPhoneWidth, 310);
    //imageRect = [Utilities resizeProportionally:imageRect maxWidth:stdiPhoneWidth maxHeight:320];
    _mainImageView = [[UIImageView alloc] initWithFrame:imageRect];
    [_mainImageView setImage:currentImage];
    [_mainView addSubview:_mainImageView];
    
    // Create white label across the images with upsell text
    CGFloat constrainedSize = 265.0f;
    UIFont* upsellFont = [UIFont fontWithName:@"Helvetica" size:16.0f];
    NSString* upsellString = @"  Save money every visit at ";
    CGSize sizeUpsellString = [upsellString sizeWithFont:upsellFont
                                       constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _mainImageView.frame.origin.y + 30, stdiPhoneWidth, sizeUpsellString.height + 20)];
    textLabel.text = upsellString;
    textLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    textLabel.textColor = [UIColor blackColor];
    [textLabel setNumberOfLines:1];
    [textLabel setFont:upsellFont];
    textLabel.textAlignment = UITextAlignmentLeft;
    [_mainView addSubview:textLabel];
    
    // Create clear label with business types in orange text
    _businessTypeTexts = [NSArray arrayWithObjects:@"spas", @"cafes", @"restaurants", @"salons", @"laundromats", @"bars", nil];
    UIFont* businessTypeFont = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    _businessTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(sizeUpsellString.width, _mainImageView.frame.origin.y + 30, stdiPhoneWidth - sizeUpsellString.width, sizeUpsellString.height + 20)];
    _businessTypeLabel.text = [_businessTypeTexts objectAtIndex:_currentIndex];
    _businessTypeLabel.backgroundColor = [UIColor clearColor];
    _businessTypeLabel.textColor = [UIColor orangeColor];
    [_businessTypeLabel setNumberOfLines:1];
    [_businessTypeLabel setFont:businessTypeFont];
    _businessTypeLabel.textAlignment = UITextAlignmentLeft;
    [_mainView addSubview:_businessTypeLabel];
    
    // Create signup button    
    CGFloat ypos = _mainImageView.frame.origin.y + _mainImageView.frame.size.height + 10;
    CGFloat xpos = 5;
    CGFloat buttonSize = (stdiPhoneWidth/2 - xpos*2);
    _signupButton = [self createCustomButton:@"Sign Up" btnImage:@"orange-button" btnWidth:buttonSize xpos:xpos ypos:ypos justification:leftJustify action:@selector(didPressSignupButton:)];
    [_mainView addSubview:_signupButton];
    
    // Create signin button
    _signinButton = [self createCustomButton:@"Sign In" btnImage:@"grey-button" btnWidth:buttonSize xpos:xpos ypos:ypos justification:rightJustify action:@selector(didPressSigninButton:)];
    [_signinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mainView addSubview:_signinButton];
    
    // Create gesture recognizers to handle tap-to-dismiss when inviteView is up
    _dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    // Create invisible label layer
    _greyoutLabel = [[UILabel alloc] initWithFrame:mainRect];
    [self displayInviteView:FALSE];
    
    [_mainView addSubview:_greyoutLabel];
    
    self.view = _mainView;
}

- (void)createInvitePopupView
{
    // Create invite view popup frame
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
    
    // lay down background image
    UIImageView* redcarpetImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup-redcarpet-img.png"]];
    redcarpetImage.frame = CGRectMake(0, greybarLabelYPos, inviteViewWidth, inviteViewHeight - greybarLabelYPos);
    
    // Create continue button
    CGFloat ContinueYPos = greybarLabel.frame.origin.y + greybarLabel.frame.size.height + 15;
    _continueButton = [self createCustomButton:@"Continue" btnImage:@"orange-button" btnWidth:(stdiPhoneWidth - 160) xpos:inviteViewWidth ypos:ContinueYPos justification:centerJustify action:@selector(didPressContinueButton:)];
    
    // Create request invite button
    CGFloat requestYPos = _continueButton.frame.origin.y + _continueButton.frame.size.height + 15;
    _requestInviteButton = [self createCustomButton:@"Request Invite" btnImage:@"grey-button" btnWidth:(stdiPhoneWidth - 160) xpos:inviteViewWidth ypos:requestYPos justification:centerJustify action:@selector(didPressRequestInviteButton:)];
    [_requestInviteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_inviteView addSubview:redcarpetImage];
    [_inviteView addSubview:inviteOnlyLabel];
    [_inviteView addSubview:explanationLabel];
    // Put grey label into view first, so it appears behind textfield
    [_inviteView addSubview:greybarLabel];
    [_inviteView addSubview:_inviteCodeTextField];
    [_inviteView addSubview:_continueButton];
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

- (UIButton*)createCustomButton:(NSString*)buttonText btnImage:(NSString*)btnImage btnWidth:(CGFloat)btnWidth xpos:(CGFloat)xpos ypos:(CGFloat)ypos justification:(JustificationType)justification action:(SEL)action
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:btnImage ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    UIFont* buttonFont = [UIFont fontWithName:@"Helvetica" size:18.0f];
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    CGRect originalRect = CGRectMake(0, ypos, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:btnWidth maxHeight:stdiPhoneHeight];
    if (justification == rightJustify)
    {
        finalRect.origin.x = stdiPhoneWidth - xpos - finalRect.size.width;
    }
    else if (justification == leftJustify)
    {
        finalRect.origin.x = xpos;
    }
    else
    {
        // In center justified scenarios, the xpos is actually the main frame width
        finalRect.origin.x = (xpos - finalRect.size.width)/2;
    }
    [newButton setFrame:finalRect];
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
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

- (void)displayInviteView:(BOOL)enable
{
    if (enable)
    {
        _greyoutLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.70];
        _greyoutLabel.enabled = TRUE;
        _signinButton.enabled = FALSE;
        _signupButton.enabled = FALSE;
        [_greyoutLabel addGestureRecognizer:_dismissTap];
        [_greyoutLabel setUserInteractionEnabled:TRUE];
        [_mainView addSubview:_inviteView];
    }
    else
    {
        _greyoutLabel.backgroundColor = [UIColor clearColor];
        _greyoutLabel.enabled = FALSE;
        _signinButton.enabled = TRUE;
        _signupButton.enabled = TRUE;
        [_greyoutLabel removeGestureRecognizer:_dismissTap];
        [_greyoutLabel setUserInteractionEnabled:FALSE];
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

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self displayInviteView:FALSE];
}

- (void)didPressSignupButton:(id)sender
{
    [self displayInviteView:TRUE];
}

- (void)didPressSigninButton:(id)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)didPressContinueButton:(id)sender
{
     NSString* inviteCode = [_inviteCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self validateInputs:inviteCode])
    {
        SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
        [self.navigationController pushViewController:signUpViewController animated:YES];
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

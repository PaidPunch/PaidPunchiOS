//
//  InviteCodeView.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/31/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "InviteCodeView.h"
#import "RequestInviteView.h"
#import "SignUpViewController.h"
#import "Utilities.h"

static NSUInteger kMinInviteCodeSize = 5;
static NSUInteger kMaxInviteCodeSize = 10;

@implementation InviteCodeView
@synthesize controller = _controller;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createInvitePopupView];
    }
    return self;
}

#pragma mark - private functions

- (void)createInvitePopupView
{
    CGFloat inviteViewWidth = _popupView.frame.size.width;
    CGFloat inviteViewHeight = _popupView.frame.size.height;
    
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
    
    [_popupView addSubview:redcarpetImage];
    [_popupView addSubview:inviteOnlyLabel];
    [_popupView addSubview:explanationLabel];
    // Put grey label into view first, so it appears behind textfield
    [_popupView addSubview:greybarLabel];
    [_popupView addSubview:_inviteCodeTextField];
    [_popupView addSubview:_continueButton];
    [_popupView addSubview:_requestInviteButton];
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

- (BOOL) validateInputs:(NSString*) inviteCode
{
    BOOL success = FALSE;
    if (inviteCode == nil || [inviteCode isEqual: @""] )
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

- (void)didPressContinueButton:(id)sender
{
    NSString* inviteCode = [_inviteCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self validateInputs:inviteCode])
    {
        SignUpViewController *signUpViewController = [[SignUpViewController alloc] initWithInviteCode:inviteCode];
        [_controller pushViewController:signUpViewController animated:YES];
    }
}

- (void)didPressRequestInviteButton:(id)sender
{
    RequestInviteView* inviteView = [[RequestInviteView alloc] initWithFrame:self.frame];
    [_scrollview addSubview:inviteView];
}

@end

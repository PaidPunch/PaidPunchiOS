//
//  RequestInviteView.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/31/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "RequestInviteView.h"
#import "User.h"
#import "Utilities.h"

@implementation RequestInviteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createRequestInviteView];
    }
    return self;
}

#pragma mark - private functions

- (void)createRequestInviteView
{
    CGFloat horizontalSpacing = 10;
    CGFloat textWidth = _popupView.frame.size.width - (horizontalSpacing * 2);
    CGFloat textfieldHeight = 40;
    
    // PaidPunch image
    UIImageView* backgrdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pp_icon.png"]];
    backgrdImg.frame = [Utilities resizeProportionally:backgrdImg.frame maxWidth:50 maxHeight:50];
    backgrdImg.frame = CGRectMake((_popupView.frame.size.width - backgrdImg.frame.size.width)/2, 15, backgrdImg.frame.size.width, backgrdImg.frame.size.height);
    [_popupView addSubview:backgrdImg];
    
    // Request Invite text
    NSString* inviteText = @"Thanks for your interest in PaidPunch!";
    UIFont* inviteFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
    CGSize sizeText = [inviteText sizeWithFont:inviteFont
                             constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                 lineBreakMode:UILineBreakModeWordWrap];
    CGRect inviteFrame = CGRectMake((_popupView.frame.size.width - sizeText.width)/2, backgrdImg.frame.origin.y + backgrdImg.frame.size.height + 20, sizeText.width, sizeText.height);
    UILabel* inviteLabel = [[UILabel alloc] initWithFrame:inviteFrame];
    [inviteLabel setText:inviteText];
    inviteLabel.font = inviteFont;
    [inviteLabel setNumberOfLines:0];
    [inviteLabel setTextAlignment:UITextAlignmentCenter];
    [_popupView addSubview:inviteLabel];
    
    // Create email textview
    CGFloat infoYPos = inviteLabel.frame.origin.y + inviteLabel.frame.size.height + 20;
    CGRect emailFrame = CGRectMake(horizontalSpacing, infoYPos, textWidth, textfieldHeight);
    _emailField = [[UITextField alloc] initWithFrame:emailFrame];
    _emailField.borderStyle = UITextBorderStyleRoundedRect;
    _emailField.font = inviteFont;
    _emailField.placeholder = @"Email: example@example.com";
    _emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailField.keyboardType = UIKeyboardTypeDefault;
    _emailField.returnKeyType = UIReturnKeyDone;
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _emailField.delegate = self;
    [_popupView addSubview:_emailField];
    
    // Create submit button
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"grey-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    CGFloat buttonWidth = 150;
    CGFloat buttonHeight = 50;
    CGFloat startingYPos = _emailField.frame.origin.y + _emailField.frame.size.height + 20;
    UIButton* submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(didPressSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    NSString* updateText = @"Submit Request";
    [submitBtn setFrame:CGRectMake((_popupView.frame.size.width - buttonWidth)/2, startingYPos, buttonWidth, buttonHeight)];
    [submitBtn setTitle:updateText forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:image forState:UIControlStateNormal];
    submitBtn.titleLabel.font = inviteFont;
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_popupView addSubview:submitBtn];
}

-(BOOL) validateFields
{
    return (_emailField.text.length > 0);
}

#pragma mark - UITextfield delegate functions

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [_scrollview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat upperBufferSpace = 50.0;
    [_scrollview setContentOffset:CGPointMake(0, textField.frame.origin.y - upperBufferSpace) animated:YES];
}

#pragma mark - event actions
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self removeFromSuperview];
    }
}

-(void) didPressSubmitButton:(id)sender
{
    [_emailField resignFirstResponder];
    [_scrollview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    if([self validateFields])
    {
        _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _hud.labelText = @"Requesting Invite";
        
        [[User getInstance] requestInvite:self email:_emailField.text];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in your email" delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type, BOOL success, NSString* message
{
    [MBProgressHUD hideHUDForView:self animated:NO];
    
    if(success)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Request received!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end

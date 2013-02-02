//
//  SuggestBusinessView.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/30/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "ProposedBusinesses.h"
#import "SuggestBusinessView.h"
#import "Utilities.h"

@implementation SuggestBusinessView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSuggestBusinessView];
    }
    return self;
}

#pragma mark - private functions

- (void)createSuggestBusinessView
{
    CGFloat horizontalSpacing = 10;
    CGFloat textWidth = _popupView.frame.size.width - (horizontalSpacing * 2);
    CGFloat textfieldHeight = 40;
    
    // PaidPunch image
    UIImageView* backgrdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pp_icon.png"]];
    backgrdImg.frame = [Utilities resizeProportionally:backgrdImg.frame maxWidth:50 maxHeight:50];
    backgrdImg.frame = CGRectMake((_popupView.frame.size.width - backgrdImg.frame.size.width)/2, 15, backgrdImg.frame.size.width, backgrdImg.frame.size.height);
    [_popupView addSubview:backgrdImg];
    
    // Thank you text
    NSString* thanksText = @"Thanks for helping to improve PaidPunch!";
    UIFont* thanksFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
    CGSize sizeText = [thanksText sizeWithFont:thanksFont
                             constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                 lineBreakMode:UILineBreakModeWordWrap];
    CGRect thanksFrame = CGRectMake((_popupView.frame.size.width - sizeText.width)/2, backgrdImg.frame.origin.y + backgrdImg.frame.size.height + 20, sizeText.width, sizeText.height);
    UILabel* thanksLabel = [[UILabel alloc] initWithFrame:thanksFrame];
    [thanksLabel setText:thanksText];
    thanksLabel.font = thanksFont;
    [thanksLabel setNumberOfLines:0];
    [thanksLabel setTextAlignment:UITextAlignmentCenter];
    [_popupView addSubview:thanksLabel];
    
    // Create business name textfield
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    CGRect nameFrame = CGRectMake(horizontalSpacing, thanksLabel.frame.origin.y + thanksLabel.frame.size.height + 20, textWidth, textfieldHeight);
    _nameField = [[UITextField alloc] initWithFrame:nameFrame];
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    _nameField.font = textFont;
    _nameField.placeholder = @"Business Name";
    _nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameField.keyboardType = UIKeyboardTypeDefault;
    _nameField.returnKeyType = UIReturnKeyNext;
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameField.delegate = self;
    [_popupView addSubview:_nameField];
    
    // Create business info textview
    CGFloat infoYPos = _nameField.frame.origin.y + _nameField.frame.size.height + 20;
    CGRect infoFrame = CGRectMake(horizontalSpacing, infoYPos, textWidth, textfieldHeight);
    _infoField = [[UITextField alloc] initWithFrame:infoFrame];
    _infoField.borderStyle = UITextBorderStyleRoundedRect;
    _infoField.font = textFont;
    _infoField.placeholder = @"City&State or Zipcode";
    _infoField.autocorrectionType = UITextAutocorrectionTypeNo;
    _infoField.keyboardType = UIKeyboardTypeDefault;
    _infoField.returnKeyType = UIReturnKeyDone;
    _infoField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _infoField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _infoField.delegate = self;
    [_popupView addSubview:_infoField];
    
    // Create suggest button
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"grey-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    CGFloat buttonWidth = 100;
    CGFloat buttonHeight = 50;
    CGFloat startingYPos = _infoField.frame.origin.y + _infoField.frame.size.height + 20;
    UIButton* suggestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [suggestBtn addTarget:self action:@selector(didPressSuggestButton:) forControlEvents:UIControlEventTouchUpInside];
    NSString* updateText = @"Suggest";
    [suggestBtn setFrame:CGRectMake((_popupView.frame.size.width - buttonWidth)/2, startingYPos, buttonWidth, buttonHeight)];
    [suggestBtn setTitle:updateText forState:UIControlStateNormal];
    [suggestBtn setBackgroundImage:image forState:UIControlStateNormal];
    suggestBtn.titleLabel.font = textFont;
    [suggestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_popupView addSubview:suggestBtn];
}

-(BOOL) validateFields
{
    return (_nameField.text.length > 0 && _infoField.text.length > 0);
}

#pragma mark - UITextfield delegate functions

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == _nameField)
    {
        [_infoField becomeFirstResponder];
    }
    else
    {
        [_scrollview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    }
    
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

-(void) didPressSuggestButton:(id)sender
{
    [_nameField resignFirstResponder];
    [_infoField resignFirstResponder];
    [_scrollview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    if([self validateFields])
    {
        _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _hud.labelText = @"Submitting Suggestion";
        
        [[ProposedBusinesses getInstance] suggestBusiness:self name:_nameField.text info:_infoField.text];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in all fields" delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type, BOOL success, NSString* message
{
    [MBProgressHUD hideHUDForView:self animated:NO];
    
    if(success)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Suggestion received!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}
@end

//
//  SignUpViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/23/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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

#pragma mark - event actions

- (void)didPressFacebookButton:(id)sender
{
}

- (void)didPressEmailButton:(id)sender
{
}

- (void)didPressTermsButton:(id)sender
{
}

@end

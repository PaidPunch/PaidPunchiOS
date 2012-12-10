//
//  SignupView.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/8/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "SignupView.h"

@implementation SignupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
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
        UITextField *referralTextField = [self initializeUITextField:referralFrame placeholder:@"Referral code: A1B2C" font:textFont];
        
        // Create checkbox for terms and conditions
        CGFloat termsYPos = referralFrame.size.height + referralFrame.origin.y + 10;
        UIButton* checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
        //[checkbox addTarget:self action:@selector(didPressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat loginButtonWidth = 25;
        CGFloat loginButtonHeight = 25;
        [checkbox setFrame:CGRectMake(leftSpacing, termsYPos, loginButtonWidth, loginButtonHeight)];
        NSString *uncheckedPath = [[NSBundle mainBundle] pathForResource:@"Unchecked" ofType:@"png"];
        NSData *uncheckedImageData = [NSData dataWithContentsOfFile:uncheckedPath];
        uncheckedImage = [[UIImage alloc] initWithData:uncheckedImageData];
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
        //[termsLink addTarget:self action:@selector(didPressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
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
        [self createFacebookButton:@"          Sign Up With Facebook" framewidth:frame.size.width yPos:hortLine.frame.origin.y + hortLine.frame.size.height + 20 textFont:textFont];
        
        [self addSubview:referralTextField];
        [self addSubview:termsLabel];
        [self addSubview:termsLink];
        [self addSubview:hortLine];
        [self addSubview:checkbox];
    }
    return self;
}

@end

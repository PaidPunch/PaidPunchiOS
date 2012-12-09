//
//  LoginView.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/8/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "LoginView.h"

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
        UITextField *emailTextField = [self initializeUITextField:emailFrame placeholder:@"Email: example@example.com" font:textFont];
        
        // Create textfield for password
        CGRect passwordFrame = CGRectMake(leftSpacing, emailFrame.size.height + emailFrame.origin.y + 5, textFieldWidth, textHeight);
        UITextField *passwordTextField = [self initializeUITextField:passwordFrame placeholder:@"Password" font:textFont];
        
        // Create login button
        UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[loginButton addTarget:self action:@selector(didPressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
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
        //[forgotPasswordButton addTarget:self action:@selector(didPressLoginButton:) forControlEvents:UIControlEventTouchUpInside];
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
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SignInFacebook" ofType:@"png"];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        UIButton* btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat imageLeftEdge = frame.size.width/2 - image.size.width/2;
        btnFacebook.frame = CGRectMake(imageLeftEdge, orLabel.frame.origin.y + orLabel.frame.size.height + 20, image.size.width, image.size.height);
        [btnFacebook setBackgroundImage:image forState:UIControlStateNormal];
        [btnFacebook setTitle:@"          Sign In With Facebook" forState:UIControlStateNormal];
        [btnFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnFacebook.titleLabel.font = textFont;
        
        [self addSubview:emailTextField];
        [self addSubview:passwordTextField];
        [self addSubview:orLabel];
        [self addSubview:hortLine1];
        [self addSubview:hortLine2];
        [self addSubview:btnFacebook];
        [self addSubview:loginButton];
        [self addSubview:forgotPasswordButton];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
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

@end

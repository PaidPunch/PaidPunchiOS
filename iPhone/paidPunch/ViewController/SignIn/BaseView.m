//
//  BaseView.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/9/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView
@synthesize navigationController = _navigationController;
@synthesize btnFacebook = _btnFacebook;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[self delegate] didInteractWithSubview];
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

- (void) createFacebookButton:(NSString*)text framewidth:(CGFloat)framewidth yPos:(CGFloat)yPos textFont:(UIFont*)textFont action:(SEL)action
{    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SignInFacebook" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    _btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat imageLeftEdge = framewidth/2 - image.size.width/2;
    _btnFacebook.frame = CGRectMake(imageLeftEdge, yPos, image.size.width, image.size.height);
    [_btnFacebook setBackgroundImage:image forState:UIControlStateNormal];
    [_btnFacebook setTitle:text forState:UIControlStateNormal];
    [_btnFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnFacebook.titleLabel.font = textFont;
    [_btnFacebook addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_btnFacebook];
}

@end

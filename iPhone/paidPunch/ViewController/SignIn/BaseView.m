//
//  BaseView.m
//  paidPunch
//
//  Created by Aaron Khoo on 12/9/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void) createFacebookButton:(NSString*)text framewidth:(CGFloat)framewidth yPos:(CGFloat)yPos textFont:(UIFont*)textFont
{    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SignInFacebook" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat imageLeftEdge = framewidth/2 - image.size.width/2;
    btnFacebook.frame = CGRectMake(imageLeftEdge, yPos, image.size.width, image.size.height);
    [btnFacebook setBackgroundImage:image forState:UIControlStateNormal];
    [btnFacebook setTitle:text forState:UIControlStateNormal];
    [btnFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFacebook.titleLabel.font = textFont;
    
    [self addSubview:btnFacebook];
}

@end

//
//  InfoChangeViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/10/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InfoChangeViewController.h"
#import "User.h"

@interface InfoChangeViewController ()

@end

@implementation InfoChangeViewController
@synthesize scrollView = _scrollview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat startingYPos = 80.0;
    CGFloat spacing = 20.0;
    
    CGFloat textHeight = 50;
    CGFloat textFieldWidth = self.view.frame.size.width - 40;
    CGFloat leftSpacing = (self.view.frame.size.width - textFieldWidth)/2;
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    
    // Create textfield for username
    CGRect usernameFrame = CGRectMake(leftSpacing, startingYPos, textFieldWidth, textHeight);
    NSString* usernameText = [NSString stringWithFormat:@"Name: %@", [[User getInstance] username]];
    _usernameTF = [self initializeUITextField:usernameFrame placeholder:usernameText font:textFont];
    _usernameTF.returnKeyType = UIReturnKeyNext;
    [_scrollview addSubview:_usernameTF];
    
    // Create textfield for mobile phone
    startingYPos = _usernameTF.frame.origin.y + _usernameTF.frame.size.height + spacing;
    CGRect mobilenoFrame = CGRectMake(leftSpacing, startingYPos, textFieldWidth, textHeight);
    NSString* mobilenoText = [NSString stringWithFormat:@"Phone: %@", [[User getInstance] phone]];
    _mobilenoTF = [self initializeUITextField:mobilenoFrame placeholder:mobilenoText font:textFont];
    _mobilenoTF.returnKeyType = UIReturnKeyNext;
    [_scrollview addSubview:_mobilenoTF];
    
    // Create textfield for zipcode
    startingYPos = _mobilenoTF.frame.origin.y + _mobilenoTF.frame.size.height + spacing;
    CGRect zipcodeFrame = CGRectMake(leftSpacing, startingYPos, textFieldWidth, textHeight);
    NSString* zipcodeText = [NSString stringWithFormat:@"Zipcode: %@", [[User getInstance] zipcode]];
    _zipcodeTF = [self initializeUITextField:zipcodeFrame placeholder:zipcodeText font:textFont];
    [_scrollview addSubview:_zipcodeTF];
  
    // Create update button
    startingYPos = _zipcodeTF.frame.origin.y + _zipcodeTF.frame.size.height + spacing;
    _updateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_updateBtn addTarget:self action:@selector(didPressUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
    NSString* updateText = @"Update";
    [_updateBtn setFrame:CGRectMake(leftSpacing, startingYPos, textFieldWidth, textHeight)];
    [_updateBtn setTitle:updateText forState:UIControlStateNormal];
    _updateBtn.titleLabel.font = textFont;
    [_scrollview addSubview:_updateBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextfield delegate functions

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == _usernameTF)
    {
        [_mobilenoTF becomeFirstResponder];
    }
    else if (textField == _mobilenoTF)
    {
        [_zipcodeTF becomeFirstResponder];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat upperBufferSpace = 50.0;
    [_scrollview setContentOffset:CGPointMake(0, textField.frame.origin.y - upperBufferSpace) animated:YES];
}

#pragma mark - private functions

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

#pragma mark - Event actions

-(IBAction)didPressUpdateButton:(id)sender
{
}

- (IBAction)goBack:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(BOOL)success, NSString* message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
    if(success)
    {

    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end

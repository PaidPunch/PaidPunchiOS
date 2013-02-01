//
//  InfoChangeViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/10/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "InfoChangeViewController.h"
#import "User.h"

@interface InfoChangeViewController ()

@end

@implementation InfoChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createMainView:[UIColor whiteColor]];
    
    [self createNavBar:@"Back" rightString:nil middle:@"Account Info" isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    [self createSilverBackgroundWithImage];
    
    [self createInputFields];
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
    else if (textField == _oldpasswordTF)
    {
        [_newpasswordTF becomeFirstResponder];
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

- (BOOL)validateInput:(NSString*)newVersion oldVersion:(NSString*)oldVersion
{
    // The input is valid if:
    // 1. The new version is longer than 0
    // 2. The new version is not the same as the old version
    return (([newVersion length] > 0) && ([newVersion compare:oldVersion] != NSOrderedSame));
}

-(BOOL) validatePassword
{
    if(_oldpasswordTF.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Old Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(_newpasswordTF.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter New Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if([_newpasswordTF.text isEqualToString:_oldpasswordTF.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Old Password and New Password should be different" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)createInputFields
{
    CGRect scrollRect = CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos);
    _scrollview = [[UIScrollView alloc] initWithFrame:scrollRect];
    _scrollview.backgroundColor = [UIColor clearColor];
    [_scrollview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
	_scrollview.scrollEnabled = FALSE;
    _scrollview.contentSize = CGSizeMake(stdiPhoneWidth, stdiPhoneHeight);
    [_mainView addSubview:_scrollview];
    
    CGFloat startingYPos = 25;
    CGFloat spacing = 10.0;
    
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
    _mobilenoTF.returnKeyType = UIReturnKeyDone;
    [_scrollview addSubview:_mobilenoTF];
    
    // Create update button
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"grey-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    startingYPos = _mobilenoTF.frame.origin.y + _mobilenoTF.frame.size.height + spacing;
    _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_updateBtn addTarget:self action:@selector(didPressUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
    NSString* updateText = @"Update";
    [_updateBtn setFrame:CGRectMake(leftSpacing, startingYPos, textFieldWidth, textHeight)];
    [_updateBtn setTitle:updateText forState:UIControlStateNormal];
    [_updateBtn setBackgroundImage:image forState:UIControlStateNormal];
    _updateBtn.titleLabel.font = textFont;
    [_updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_scrollview addSubview:_updateBtn];
    
    // Only non-facebook users have passwords
    if (![[User getInstance] isFacebookProfile])
    {
        // Create textfield for old password
        startingYPos = _updateBtn.frame.origin.y + _updateBtn.frame.size.height + spacing;
        CGRect oldpasswordFrame = CGRectMake(leftSpacing, startingYPos, textFieldWidth, textHeight);
        NSString* oldpasswordText = [NSString stringWithFormat:@"Current Password"];
        _oldpasswordTF = [self initializeUITextField:oldpasswordFrame placeholder:oldpasswordText font:textFont];
        _oldpasswordTF.returnKeyType = UIReturnKeyNext;
        [_scrollview addSubview:_oldpasswordTF];
        
        // Create textfield for mobile phone
        startingYPos = _oldpasswordTF.frame.origin.y + _oldpasswordTF.frame.size.height + spacing;
        CGRect newpasswordFrame = CGRectMake(leftSpacing, startingYPos, textFieldWidth, textHeight);
        NSString* newpasswordText = [NSString stringWithFormat:@"New Password"];
        _newpasswordTF = [self initializeUITextField:newpasswordFrame placeholder:newpasswordText font:textFont];
        _newpasswordTF.returnKeyType = UIReturnKeyDone;
        [_scrollview addSubview:_newpasswordTF];
        
        // Create password button
        startingYPos = _newpasswordTF.frame.origin.y + _newpasswordTF.frame.size.height + spacing;
        _passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passwordBtn addTarget:self action:@selector(didPressPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
        NSString* passwordText = @"Change Password";
        [_passwordBtn setFrame:CGRectMake(leftSpacing, startingYPos, textFieldWidth, textHeight)];
        [_passwordBtn setTitle:passwordText forState:UIControlStateNormal];
        [_passwordBtn setBackgroundImage:image forState:UIControlStateNormal];
        _passwordBtn.titleLabel.font = textFont;
        [_passwordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scrollview addSubview:_passwordBtn];
    }
}

#pragma mark - Event actions

-(IBAction)didPressPasswordButton:(id)sender
{
    if([self validatePassword])
    {
        [[User getInstance] changePassword:self oldPassword:_oldpasswordTF.text newPassword:_newpasswordTF.text];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please recheck password changes" delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)didPressUpdateButton:(id)sender
{
    // Dismiss any keyboards
    [_usernameTF resignFirstResponder];
    [_mobilenoTF resignFirstResponder];
    
    BOOL hasValidInput = false;
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSString* newUsername = [_usernameTF text];
    if ([self validateInput:newUsername oldVersion:[[User getInstance] username]])
    {
        [dict setObject:newUsername forKey:@"username"];
        hasValidInput = true;
    }
    
    NSString* newMobileno = [_mobilenoTF text];
    if ([self validateInput:newMobileno oldVersion:[[User getInstance] phone]])
    {
        [dict setObject:newMobileno forKey:@"mobile_no"];
        hasValidInput = true;
    }
    
    if (hasValidInput)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"Updating info";
        
        [[User getInstance] changeInfo:self parameters:dict];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No changes found." delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type, BOOL success, NSString* message
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
    
    if(success)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end

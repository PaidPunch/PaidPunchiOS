//
//  BaseWithNavBarViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/23/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "BaseWithNavBarViewController.h"
#import "Utilities.h"

static NSUInteger kDistanceFromTop = 5;
static CGFloat kButtonWidthSpacing = 20;
static CGFloat kButtonHeightSpacing = 10;

@implementation BaseWithNavBarViewController
@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize lowestYPos = _lowestYPos;

- (id)init
{
    self = [super init];
    if (self)
    {
        _lowestYPos = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public functions

- (void)createNavBar:(NSString*)leftString rightString:(NSString*)rightString middle:(NSString*)middle isMiddleImage:(BOOL)isMiddleImage leftAction:(SEL)leftAction rightAction:(SEL)rightAction
{
    CGRect mainRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    _mainView = [[UIView alloc] initWithFrame:mainRect];
    _mainView.backgroundColor = [UIColor whiteColor];
    self.view = _mainView;
    
    // Create background
    UIImageView* backgrdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-bg.png"]];
    CGRect originalRect = CGRectMake(0, 0, backgrdImg.frame.size.width, backgrdImg.frame.size.height);
    backgrdImg.frame = [Utilities resizeProportionally:originalRect maxWidth:stdiPhoneWidth maxHeight:stdiPhoneHeight];
    [_mainView addSubview:backgrdImg];
    
    CGFloat maxElementWidth = backgrdImg.frame.size.width - kButtonWidthSpacing;
    CGFloat maxElementHeight = backgrdImg.frame.size.height - kButtonHeightSpacing;
    
    // Create left button if necessary
    if (leftString != nil)
    {
        UIButton* leftButton;
        if (leftAction != nil)
        {
            leftButton = [self createButton:leftString xpos:5 ypos:kDistanceFromTop justification:leftJustify maxWidth:maxElementWidth maxHeight:maxElementHeight action:leftAction];
        }
        else
        {
            // Use the default left action
            leftButton = [self createButton:leftString xpos:5 ypos:kDistanceFromTop justification:leftJustify maxWidth:maxElementWidth maxHeight:maxElementHeight action:@selector(didPressLeftButton:)];
        }
        [_mainView addSubview:leftButton];
    }
    
    // Create right button if necessary
    if (rightString != nil)
    {
        UIButton* rightButton;
        if (rightAction != nil)
        {
            rightButton = [self createButton:rightString xpos:5 ypos:kDistanceFromTop justification:rightJustify maxWidth:maxElementWidth maxHeight:maxElementHeight action:rightAction];
        }
        else
        {
            rightButton = [self createButton:rightString xpos:5 ypos:kDistanceFromTop justification:rightJustify maxWidth:maxElementWidth maxHeight:maxElementHeight action:@selector(didPressRightButton:)];    
        }
        [_mainView addSubview:rightButton];
    }
    
    // Create middle text or image
    if (isMiddleImage)
    {
        
    }
    else
    {
        UIFont* middleFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
        CGSize sizeMiddle = [middle sizeWithFont:middleFont
                               constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                   lineBreakMode:UILineBreakModeWordWrap];
        UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake((stdiPhoneWidth - sizeMiddle.width)/2, kDistanceFromTop, sizeMiddle.width, sizeMiddle.height + 20)];
        middleLabel.text = middle;
        middleLabel.backgroundColor = [UIColor clearColor];
        middleLabel.textColor = [UIColor blackColor];
        [middleLabel setNumberOfLines:1];
        [middleLabel setFont:middleFont];
        middleLabel.textAlignment = UITextAlignmentCenter;
        [_mainView addSubview:middleLabel];
    }
    
    // Setting lowestYPos value to indicate where the next UI element can start vertically
    _lowestYPos = backgrdImg.frame.size.height;
}

- (void)createGreenNotificationBar:(NSString*)barText
{
    UIFont* textFont = [UIFont fontWithName:@"ArialMT" size:16.0f];
    
    // Green bar for notifications
    CGFloat greenbarLabelHeight = 50;
    UILabel* greenbarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos, stdiPhoneWidth, greenbarLabelHeight)];
    greenbarLabel.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
    greenbarLabel.text = barText;
    greenbarLabel.textColor = [UIColor blackColor];
    [greenbarLabel setNumberOfLines:2];
    [greenbarLabel setFont:textFont];
    greenbarLabel.textAlignment = UITextAlignmentCenter;
    
    [_mainView addSubview:greenbarLabel];
    
    _lowestYPos = greenbarLabelHeight + greenbarLabel.frame.origin.y;
}

- (void)createSignInOrUpButtons:(NSString*)currentText fbAction:(SEL)fbAction emailAction:(SEL)emailAction
{
    NSString* fbSpacing = @"          ";
    NSString* fbText = @" With Facebook";
    
    CGRect scrollRect = CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos);
    _scrollview = [[UIScrollView alloc] initWithFrame:scrollRect];
    _scrollview.backgroundColor = [UIColor clearColor];
    [_scrollview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
	_scrollview.scrollEnabled = FALSE;
    _scrollview.contentSize = CGSizeMake(stdiPhoneWidth, stdiPhoneHeight);
    [_mainView addSubview:_scrollview];
    
    // Insert facebook signup/signin image
    NSString* fbButtonText = [NSString stringWithFormat:@"%@%@%@", fbSpacing, currentText, fbText];
    [self createFacebookButton:fbButtonText framewidth:stdiPhoneWidth yPos:20 action:fbAction];
    
    // Insert or label separator
    [self createOrLabel:(_btnFacebook.frame.origin.y + _btnFacebook.frame.size.height + 10)];
    
    // Insert sign up/in with email fields and labels
    [self createEmailFields:currentText xpos:_btnFacebook.frame.origin.x ypos:(_orLabel.frame.origin.y + _orLabel.frame.size.height + 10) textfieldWidth:_btnFacebook.frame.size.width action:emailAction];
    
    // Setting lowestYPos value to indicate where the next UI element can start vertically
    _lowestYPos = _btnEmail.frame.origin.y + _btnEmail.frame.size.height;
}

#pragma mark - private functions

- (void) dismissKeyboard
{
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (UIButton*)createButton:(NSString*)buttonText xpos:(CGFloat)xpos ypos:(CGFloat)ypos justification:(JustificationType)justification maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight action:(SEL)action
{    
    // Get imagedata
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"blank" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    // Set text
    UIFont* buttonFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];    
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    
    CGRect buttonSize = CGRectMake(0, 0, image.size.width + 30, image.size.height + 10);
    buttonSize = [Utilities resizeProportionally:buttonSize maxWidth:maxWidth maxHeight:maxHeight];
    CGFloat buttonWidth = buttonSize.size.width;
    CGFloat buttonHeight = buttonSize.size.height;
    
    CGFloat realXPos;
    if (justification == rightJustify)
    {
        realXPos = stdiPhoneWidth - xpos - buttonWidth;
    }
    else if (justification == leftJustify)
    {
        realXPos = xpos;
    }
    else
    {
        // In center justified scenarios, the xpos is actually the main frame width
        realXPos = (xpos - buttonWidth)/2;
    }
    [newButton setFrame:CGRectMake(realXPos, ypos, buttonWidth, buttonHeight)];
    
    [newButton setTitle:buttonText forState:UIControlStateNormal];
    newButton.titleLabel.font = buttonFont;
    newButton.titleLabel.textColor = [UIColor blackColor];
    
    return newButton;
}

- (void)createFacebookButton:(NSString*)text framewidth:(CGFloat)framewidth yPos:(CGFloat)yPos action:(SEL)action
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"facebook-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    _btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, yPos, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 40) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (framewidth - finalRect.size.width)/2;
    
    _btnFacebook.frame = finalRect;
    [_btnFacebook setBackgroundImage:image forState:UIControlStateNormal];
    [_btnFacebook setTitle:text forState:UIControlStateNormal];
    [_btnFacebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnFacebook.titleLabel.font = textFont;
    [_btnFacebook addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollview addSubview:_btnFacebook];
}

- (void)createOrLabel:(CGFloat)orLabelYPos
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    UIColor* separatorColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    CGFloat leftSpacing = 20;
    
    // Create OR label
    NSString* lbtext = @" or ";
    CGSize sizeText = [lbtext sizeWithFont:textFont
                         constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                             lineBreakMode:UILineBreakModeWordWrap];
    _orLabel = [[UILabel alloc] initWithFrame:CGRectMake((stdiPhoneWidth - sizeText.width)/2, orLabelYPos, sizeText.width, sizeText.height)];
    _orLabel.text = lbtext;
    _orLabel.backgroundColor = [UIColor clearColor];
    _orLabel.textColor = separatorColor;
    [_orLabel setNumberOfLines:1];
    [_orLabel setFont:textFont];
    _orLabel.textAlignment = UITextAlignmentLeft;
    
    // Draw horizontal lines
    CGFloat hortLineYPos = orLabelYPos + (_orLabel.frame.size.height/2);
    CGFloat hortLineWidth = (stdiPhoneWidth - leftSpacing*2 - _orLabel.frame.size.width)/2;
    UIView *hortLine1 = [[UIView alloc] initWithFrame:CGRectMake(leftSpacing, hortLineYPos, hortLineWidth, 1.0)];
    UIView *hortLine2 = [[UIView alloc] initWithFrame:CGRectMake(leftSpacing + hortLineWidth + _orLabel.frame.size.width, hortLineYPos, hortLineWidth, 1.0)];
    hortLine1.backgroundColor = separatorColor;
    hortLine2.backgroundColor = separatorColor;
    
    [_scrollview addSubview:hortLine1];
    [_scrollview addSubview:_orLabel];
    [_scrollview addSubview:hortLine2];
}

- (void)createEmailFields:(NSString*)currentText xpos:(CGFloat)xpos ypos:(CGFloat)ypos textfieldWidth:(CGFloat)textfieldWidth action:(SEL)action
{
    CGFloat textHeight = 40;
    UIFont* textFont = [UIFont fontWithName:@"ArialMT" size:15.0f];
    UIFont* orangeButtonFont = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
    
    NSString* emailLabelString = [NSString stringWithFormat:@"%@ With Email", currentText];
    
    // Create label
    CGSize sizeemailLabelString = [emailLabelString sizeWithFont:textFont
                                               constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                                   lineBreakMode:UILineBreakModeWordWrap];
    UILabel* emailLabel = [[UILabel alloc] initWithFrame:CGRectMake((stdiPhoneWidth - sizeemailLabelString.width)/2, ypos, sizeemailLabelString.width, sizeemailLabelString.height)];
    emailLabel.text = emailLabelString;
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.textColor = [UIColor blackColor];
    [emailLabel setNumberOfLines:1];
    [emailLabel setFont:textFont];
    emailLabel.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:emailLabel];
    
    // Create textfield for email
    CGRect emailFrame = CGRectMake(xpos, emailLabel.frame.size.height + emailLabel.frame.origin.y + 15, textfieldWidth, textHeight);
    _emailTextField = [self initializeUITextField:emailFrame placeholder:@"Email: example@example.com" font:textFont];
    _emailTextField.returnKeyType = UIReturnKeyNext;
    [_scrollview addSubview:_emailTextField];
    
    // Create textfield for password
    CGRect passwordFrame = CGRectMake(xpos, emailFrame.size.height + emailFrame.origin.y + 10, textfieldWidth, textHeight);
    _passwordTextField = [self initializeUITextField:passwordFrame placeholder:@"Password" font:textFont];
    _passwordTextField.secureTextEntry = TRUE;
    [_scrollview addSubview:_passwordTextField];
    
    // Create orange sign in/up button
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"orange-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    _btnEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, passwordFrame.size.height + passwordFrame.origin.y + 10, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:stdiPhoneWidth maxHeight:(_btnFacebook.frame.size.height - 10)];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    
    _btnEmail.frame = finalRect;
    [_btnEmail setBackgroundImage:image forState:UIControlStateNormal];
    [_btnEmail setTitle:currentText forState:UIControlStateNormal];
    [_btnEmail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnEmail.titleLabel.font = orangeButtonFont;
    [_btnEmail addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:_btnEmail];
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
    textField.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    textField.delegate = self;
    return textField;
}

#pragma mark - event actions

- (void)didPressLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _emailTextField)
    {
        [_scrollview setContentOffset:CGPointMake(0, _emailTextField.frame.origin.y - 40) animated:YES];
    }
    else if (textField == _passwordTextField)
    {
        [_scrollview setContentOffset:CGPointMake(0, _passwordTextField.frame.origin.y - 40) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _emailTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    else
    {
        [_scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return NO;
}

@end

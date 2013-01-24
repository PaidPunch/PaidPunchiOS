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

- (id)init
{
    self = [super init];
    if (self)
    {
        _navBarHeight = 0;
        _notifyBarHeight = 0;
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

- (void)createNavBar:(NSString*)leftString rightString:(NSString*)rightString middle:(NSString*)middle isMiddleImage:(BOOL)isMiddleImage
{
    CGRect mainRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    _mainView = [[UIView alloc] initWithFrame:mainRect];
    _mainView.backgroundColor = [UIColor whiteColor];
    self.view = _mainView;
    
    // Create background
    UIImageView* backgrdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-bg.png"]];
    CGRect originalRect = CGRectMake(0, 0, backgrdImg.frame.size.width, backgrdImg.frame.size.height);
    backgrdImg.frame = [Utilities resizeProportionally:originalRect maxWidth:stdiPhoneWidth maxHeight:stdiPhoneHeight];
    _navBarHeight = backgrdImg.frame.size.height;
    [_mainView addSubview:backgrdImg];
    
    CGFloat maxElementWidth = backgrdImg.frame.size.width - kButtonWidthSpacing;
    CGFloat maxElementHeight = backgrdImg.frame.size.height - kButtonHeightSpacing;
    
    // Create left button if necessary
    if (leftString != nil)
    {
        UIButton* leftButton = [self createButton:leftString xpos:5 ypos:kDistanceFromTop justification:leftJustify maxWidth:maxElementWidth maxHeight:maxElementHeight action:@selector(didPressLeftButton:)];
        [_mainView addSubview:leftButton];
    }
    
    // Create right button if necessary
    if (rightString != nil)
    {
        UIButton* rightButton = [self createButton:rightString xpos:5 ypos:kDistanceFromTop justification:rightJustify maxWidth:maxElementWidth maxHeight:maxElementHeight action:@selector(didPressRightButton:)];
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
}

#pragma mark - private functions

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

@end

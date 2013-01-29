//
//  PaidPunchHomeViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "NoBizView.h"
#import "PaidPunchHomeViewController.h"
#import "PPRevealSideViewController.h"
#import "SidebarViewController.h"
#import "Utilities.h"

@implementation PaidPunchHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	
    [self createNavBar];
    
    [self createSuggestBusinessButton];
    
    [self createNoBizView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SidebarViewController *sidebar = [[SidebarViewController alloc] init];
    [self.revealSideViewController preloadViewController:sidebar forSide:PPRevealSideDirectionLeft];
}

#pragma mark - private functions

- (void)createNavBar
{    
    CGRect mainRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    UIImageView* backgrdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    _mainView = [[UIView alloc] initWithFrame:mainRect];
    [_mainView addSubview:backgrdImg];
    self.view = _mainView;
    
    // Create background
    UIImageView* navbarImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-bg.png"]];
    CGRect originalRect = CGRectMake(0, 0, navbarImg.frame.size.width, navbarImg.frame.size.height);
    navbarImg.frame = [Utilities resizeProportionally:originalRect maxWidth:stdiPhoneWidth maxHeight:stdiPhoneHeight];
    [_mainView addSubview:navbarImg];
    
    CGFloat maxElementWidth = navbarImg.frame.size.width - kButtonWidthSpacing;
    CGFloat maxElementHeight = navbarImg.frame.size.height - kButtonHeightSpacing;
    
    UIButton* leftButton = [self createListButton:5 ypos:kDistanceFromTop maxWidth:maxElementWidth maxHeight:maxElementHeight];
    [_mainView addSubview:leftButton];
    
    UIButton* centerButton = [self createPaidPunchButton:stdiPhoneWidth ypos:kDistanceFromTop maxWidth:maxElementWidth maxHeight:maxElementHeight];
    [_mainView addSubview:centerButton];
    
    UIButton* rightButton = [self createCreditsButton:5 ypos:kDistanceFromTop maxWidth:maxElementWidth maxHeight:maxElementHeight];
    [_mainView addSubview:rightButton];
    
    _lowestYPos = navbarImg.frame.origin.y + navbarImg.frame.size.height;
}

- (UIButton*)createListButton:(CGFloat)xpos ypos:(CGFloat)ypos maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    // Get imagedata
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"list-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:@selector(didPressListButton:) forControlEvents:UIControlEventTouchUpInside];
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    
    CGRect buttonSize = CGRectMake(0, 0, image.size.width + 30, image.size.height + 10);
    buttonSize = [Utilities resizeProportionally:buttonSize maxWidth:maxWidth maxHeight:maxHeight];
    CGFloat buttonWidth = buttonSize.size.width;
    CGFloat buttonHeight = buttonSize.size.height;
    
    [newButton setFrame:CGRectMake(xpos, ypos, buttonWidth, buttonHeight)];
    
    return newButton;
}

- (UIButton*)createPaidPunchButton:(CGFloat)xpos ypos:(CGFloat)ypos maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    // Get imagedata
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pp_icon" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:@selector(didPressPaidPunchButton:) forControlEvents:UIControlEventTouchUpInside];
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    
    CGRect buttonSize = CGRectMake(0, 0, image.size.width + 30, image.size.height + 10);
    buttonSize = [Utilities resizeProportionally:buttonSize maxWidth:maxWidth maxHeight:maxHeight];
    CGFloat buttonWidth = buttonSize.size.width;
    CGFloat buttonHeight = buttonSize.size.height;
    
    CGFloat realXPos = (xpos - buttonWidth)/2;
    [newButton setFrame:CGRectMake(realXPos, ypos, buttonWidth, buttonHeight)];
    
    return newButton;
}

- (UIButton*)createCreditsButton:(CGFloat)xpos ypos:(CGFloat)ypos maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    // Get imagedata
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"blank" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:@selector(didPressCreditsButton:) forControlEvents:UIControlEventTouchUpInside];
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    
    CGRect buttonSize = CGRectMake(0, 0, image.size.width + 30, image.size.height + 10);
    buttonSize = [Utilities resizeProportionally:buttonSize maxWidth:maxWidth maxHeight:maxHeight];
    CGFloat buttonWidth = buttonSize.size.width;
    CGFloat buttonHeight = buttonSize.size.height;
    
    // Set text
    UIFont* buttonFont = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    // TODO: Replace credits with real user credits
    [newButton setTitle:@"$5.00" forState:UIControlStateNormal];
    newButton.titleLabel.font = buttonFont;
    [newButton setTitleColor:[UIColor colorWithRed:0.0f green:153.0f/255.0f blue:51.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    CGFloat realXPos = stdiPhoneWidth - xpos - buttonWidth;
    [newButton setFrame:CGRectMake(realXPos, ypos, buttonWidth, buttonHeight)];
    
    return newButton;
}

- (void)createSuggestBusinessButton
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"green-suggest-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* suggestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, _lowestYPos + 10, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 60) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    
    suggestButton.frame = finalRect;
    [suggestButton setBackgroundImage:image forState:UIControlStateNormal];
    [suggestButton setTitle:@"Suggest A Business" forState:UIControlStateNormal];
    [suggestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    suggestButton.titleLabel.font = textFont;
    [suggestButton addTarget:self action:@selector(didPressSuggestBusinessButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainView addSubview:suggestButton];
    
    _lowestYPos = finalRect.origin.y + finalRect.size.height;
}

- (void)createNoBizView
{
    CGRect nobizRect = CGRectMake(0, _lowestYPos + 10, stdiPhoneWidth, stdiPhoneHeight - (_lowestYPos + 10));
    NoBizView* nobizView = [[NoBizView alloc] initWithFrame:nobizRect];
    [_mainView addSubview:nobizView];
}

#pragma mark - event actions

- (void)didPressListButton:(id)sender
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}

- (void)didPressCreditsButton:(id)sender
{
}

@end

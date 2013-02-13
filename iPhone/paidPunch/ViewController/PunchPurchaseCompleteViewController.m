//
//  PunchPurchaseCompleteViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/8/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#include "CommonDefinitions.h"
#import "AppDelegate.h"
#import "Punches.h"
#import "PunchPurchaseCompleteViewController.h"
#import "Utilities.h"

@interface PunchPurchaseCompleteViewController ()
{
    CGFloat _lowestYPos;
}
@end

@implementation PunchPurchaseCompleteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createMainView:[UIColor blackColor]];
    _lowestYPos = 0;
    
    [self createBackground];
    
    [self createInfoLabel];
    
    [self createContinueButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (void) createBackground
{
    // Add a background to the mainview
    UIImageView* backgrdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"punchpurchasecomplete.png"]];
    backgrdImg.frame = CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos);
    [_mainView addSubview:backgrdImg];
}

- (void) createInfoLabel
{
    // Congrats label
    CGFloat congratsLabelHeight = 20;
    UIFont* congratsFont = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    UILabel* congratsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, stdiPhoneWidth, congratsLabelHeight)];
    [congratsLabel setFont:congratsFont];
    congratsLabel.backgroundColor = [UIColor clearColor];
    congratsLabel.text = @"Congratulations!";
    congratsLabel.textColor = [UIColor whiteColor];
    [congratsLabel setNumberOfLines:1];
    congratsLabel.textAlignment = UITextAlignmentCenter;
    _lowestYPos = congratsLabelHeight;
    [_mainView addSubview:congratsLabel];
    _lowestYPos = congratsLabel.frame.origin.y + congratsLabelHeight;
    
    // Text top info label
    CGFloat textLabelWidth = stdiPhoneWidth - 20;
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:16.0];
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake((stdiPhoneWidth - textLabelWidth)/2, _lowestYPos, textLabelWidth, 50)];
    [textLabel setFont:textFont];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = @"You've successfully purchased coupons!";
    textLabel.textColor = [UIColor whiteColor];
    [textLabel setNumberOfLines:0];
    [textLabel setFont:textFont];
    [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    textLabel.textAlignment = UITextAlignmentCenter;
    [_mainView addSubview:textLabel];
    _lowestYPos = textLabel.frame.origin.y + textLabel.frame.size.height;
    
    // Create center text label
    CGFloat blackbarWidth = stdiPhoneWidth - 40;
    CGFloat blackbarHeight = 90;
    CGRect blackbarRect = CGRectMake((stdiPhoneWidth - blackbarWidth)/2, _lowestYPos + 150, blackbarWidth, blackbarHeight);
    UILabel* blackbar = [[UILabel alloc] initWithFrame:blackbarRect];
    blackbar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    blackbar.layer.cornerRadius = 5;
    blackbar.layer.masksToBounds = YES;
    [blackbar setText:@"Click the PaidPunch icon in the header to access all your coupons."];
    blackbar.textColor = [UIColor whiteColor];
    [blackbar setNumberOfLines:3];
    [blackbar setLineBreakMode:NSLineBreakByWordWrapping];
    [blackbar setAdjustsFontSizeToFitWidth:TRUE];
    [blackbar setFont:congratsFont];
    blackbar.textAlignment = UITextAlignmentCenter;
    [_mainView addSubview:blackbar];
    _lowestYPos = blackbar.frame.origin.y + blackbar.frame.size.height;
}

- (void)createContinueButton
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:24.0f];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"large-green-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 40) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    finalRect.origin.y = _lowestYPos + 30;
    
    continueButton.frame = finalRect;
    [continueButton setBackgroundImage:image forState:UIControlStateNormal];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    continueButton.titleLabel.font = textFont;
    [continueButton addTarget:self action:@selector(didPressContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainView addSubview:continueButton];
}

#pragma mark - event actions

- (void) didPressContinueButton:(id)sender
{
    // Indicate that a new punch was just purchased
    [[Punches getInstance] setJustPurchasedPunch:TRUE];
    [[Punches getInstance] forceRefresh];
    [[User getInstance] forceRefresh];
    [[User getInstance] forceLocationRefresh];
    
    // Go back to home page
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initView];
}

@end

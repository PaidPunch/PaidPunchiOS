//
//  EmailVerifyViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/17/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "AppDelegate.h"
#import "EmailVerifyViewController.h"
#import "Utilities.h"

@interface EmailVerifyViewController ()
{
    UIView* _mainView;
}

@end

@implementation EmailVerifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGRect mainRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    _mainView = [[UIView alloc] initWithFrame:mainRect];
    _mainView.backgroundColor = [UIColor whiteColor];
    self.view = _mainView;
	
    // Display background image
    UIImageView* bkgrdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emailverifybackground.png"]];
    bkgrdImage.frame = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    [_mainView addSubview:bkgrdImage];
    
    // Display text
    UIFont* boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:26.0f];
    NSString* boldText = [NSString stringWithFormat:@"You've Got Mail!"];
    CGSize sizeBoldText = [boldText sizeWithFont:boldFont
                               constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                   lineBreakMode:UILineBreakModeWordWrap];
    UILabel *boldTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, stdiPhoneWidth, sizeBoldText.height)];
    boldTextLabel.text = boldText;
    boldTextLabel.backgroundColor = [UIColor clearColor];
    boldTextLabel.textColor = [UIColor whiteColor];
    [boldTextLabel setNumberOfLines:1];
    [boldTextLabel setFont:boldFont];
    boldTextLabel.textAlignment = UITextAlignmentCenter;
    [boldTextLabel setAdjustsFontSizeToFitWidth:TRUE];
    [_mainView addSubview:boldTextLabel];
    
    NSString* verifyText = @"Verify your email, then sign in.";
    UIFont* verifyFont = [UIFont fontWithName:@"Helvetica" size:24.0f];
    CGSize sizeVerify = [verifyText sizeWithFont:verifyFont
                               constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                   lineBreakMode:UILineBreakModeWordWrap];
    UILabel *verifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, boldTextLabel.frame.size.height + boldTextLabel.frame.origin.y, stdiPhoneWidth, sizeVerify.height)];
    verifyLabel.text = verifyText;
    verifyLabel.backgroundColor = [UIColor clearColor];
    verifyLabel.textColor = [UIColor whiteColor];
    [verifyLabel setNumberOfLines:1];
    [verifyLabel setFont:verifyFont];
    verifyLabel.textAlignment = UITextAlignmentCenter;
    [verifyLabel setAdjustsFontSizeToFitWidth:TRUE];
    [_mainView addSubview:verifyLabel];
    
    [self createTransitionButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private functions

- (void)createTransitionButton
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:22.0f];
    NSString* transitionText = @"Okay";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"large-green-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* transitionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 80) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    finalRect.origin.y = stdiPhoneHeight - (finalRect.size.height + 20);
    
    transitionButton.frame = finalRect;
    [transitionButton setBackgroundImage:image forState:UIControlStateNormal];
    [transitionButton setTitle:transitionText forState:UIControlStateNormal];
    [transitionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    transitionButton.titleLabel.font = textFont;
    [transitionButton addTarget:self action:@selector(didPressTransitionButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:transitionButton];
}

#pragma mark - event actions

- (void)didPressTransitionButton:(id)sender
{
    // This is called on email registration success, where we take the use back to the main welcome screen
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initView];
}

@end

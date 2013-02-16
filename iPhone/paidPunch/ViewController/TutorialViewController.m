//
//  TutorialViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/16/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "InviteFriendsViewController.h"
#import "TutorialViewController.h"
#import "Utilities.h"

@interface TutorialViewController ()
{
    NSUInteger _step;
    NSArray* _tutorialText;
    UIView* _mainView;
}

@end

@implementation TutorialViewController

- (id)initWithStep:(NSUInteger)step
{
    self = [super init];
    if (self)
    {
        _step = step;
         _tutorialText = [NSArray arrayWithObjects:@"Invite friends to earn money.",
                          @"Buy sets of digital coupons.",
                          @"Use a coupon to save $$$",
                          nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect mainRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    _mainView = [[UIView alloc] initWithFrame:mainRect];
    _mainView.backgroundColor = [UIColor whiteColor];
    self.view = _mainView;
	
    // Display background tutorial image
    NSString* bkgrdImagePath = [NSString stringWithFormat:@"step%dbackground.png", _step];
    UIImageView* bkgrdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bkgrdImagePath]];
    bkgrdImage.frame = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    [_mainView addSubview:bkgrdImage];
    
    // Display text
    UIFont* boldStepFont = [UIFont fontWithName:@"Helvetica-Bold" size:26.0f];
    NSString* boldStep = [NSString stringWithFormat:@"Step %d", _step];
    CGSize sizeBoldStep = [boldStep sizeWithFont:boldStepFont
                               constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                   lineBreakMode:UILineBreakModeWordWrap];
    UILabel *boldStepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, stdiPhoneWidth, sizeBoldStep.height)];
    boldStepLabel.text = boldStep;
    boldStepLabel.backgroundColor = [UIColor clearColor];
    boldStepLabel.textColor = [UIColor whiteColor];
    [boldStepLabel setNumberOfLines:1];
    [boldStepLabel setFont:boldStepFont];
    boldStepLabel.textAlignment = UITextAlignmentCenter;
    [boldStepLabel setAdjustsFontSizeToFitWidth:TRUE];
    [_mainView addSubview:boldStepLabel];
    
    NSString* tutorialText = [_tutorialText objectAtIndex:(_step - 1)];
    UIFont* tutorialFont = [UIFont fontWithName:@"Helvetica" size:24.0f];
    CGSize sizeTutorial = [tutorialText sizeWithFont:tutorialFont
                                   constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                       lineBreakMode:UILineBreakModeWordWrap];
    UILabel *tutorialLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, boldStepLabel.frame.size.height + boldStepLabel.frame.origin.y, stdiPhoneWidth, sizeTutorial.height)];
    tutorialLabel.text = tutorialText;
    tutorialLabel.backgroundColor = [UIColor clearColor];
    tutorialLabel.textColor = [UIColor whiteColor];
    [tutorialLabel setNumberOfLines:1];
    [tutorialLabel setFont:tutorialFont];
    tutorialLabel.textAlignment = UITextAlignmentCenter;
    [tutorialLabel setAdjustsFontSizeToFitWidth:TRUE];
    [_mainView addSubview:tutorialLabel];
    
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
    NSString* transitionText;
    if (_step == 3)
    {
        transitionText = @"Get started!";
    }
    else
    {
        transitionText = @"Next";
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"large-green-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* transitionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 60) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    finalRect.origin.y = stdiPhoneHeight - (finalRect.size.height + 30);
    
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
    if (_step == 3)
    {
        // First time logging in via email signup
        InviteFriendsViewController *inviteFriendsViewController = [[InviteFriendsViewController alloc] init:FALSE duringSignup:TRUE];
        [self.navigationController pushViewController:inviteFriendsViewController animated:NO];
    }
    else
    {
        // Transition to next tutorial screen
        TutorialViewController *tutorialViewController = [[TutorialViewController alloc] initWithStep:(_step+1)];
        [self.navigationController pushViewController:tutorialViewController animated:NO];
    }
}

@end

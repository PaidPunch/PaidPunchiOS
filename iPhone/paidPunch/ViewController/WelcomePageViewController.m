//
//  WelcomePageViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/22/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InviteCodeView.h"
#import "LoginViewController.h"
#import "Utilities.h"
#import "WelcomePageViewController.h"

@implementation WelcomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	
    [self createView];
    
    _fadeTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (void)createView
{
    CGRect mainRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    _mainView = [[UIView alloc] initWithFrame:mainRect];
    _mainView.backgroundColor = [UIColor whiteColor];
    
    // Create logo image at top of view
    UIImageView* logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"landing-top-logo.png"]];
    logoImage.frame = CGRectMake(0, 0, logoImage.frame.size.width, logoImage.frame.size.height);
    logoImage.frame = [Utilities resizeProportionally:logoImage.frame maxWidth:stdiPhoneWidth maxHeight:100];
    [_mainView addSubview:logoImage];
    
    // Create cross fading images in the middle
    _imageFiles = [NSArray arrayWithObjects:@"spas.png", @"cafes.png", @"restaurants.png", @"salons.png", @"dry-cleaning.png", @"bars.png", nil];
    _currentIndex = 0;
    UIImage* currentImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [_imageFiles objectAtIndex:_currentIndex]]];
    CGRect imageRect = CGRectMake(0, logoImage.frame.origin.y + logoImage.frame.size.height, stdiPhoneWidth, 310);
    //imageRect = [Utilities resizeProportionally:imageRect maxWidth:stdiPhoneWidth maxHeight:320];
    _mainImageView = [[UIImageView alloc] initWithFrame:imageRect];
    [_mainImageView setImage:currentImage];
    [_mainView addSubview:_mainImageView];
    
    // Create white label across the images with upsell text
    CGFloat constrainedSize = 265.0f;
    UIFont* upsellFont = [UIFont fontWithName:@"Helvetica" size:16.0f];
    NSString* upsellString = @"  Save money every visit at ";
    CGSize sizeUpsellString = [upsellString sizeWithFont:upsellFont
                                       constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _mainImageView.frame.origin.y + 30, stdiPhoneWidth, sizeUpsellString.height + 20)];
    textLabel.text = upsellString;
    textLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    textLabel.textColor = [UIColor blackColor];
    [textLabel setNumberOfLines:1];
    [textLabel setFont:upsellFont];
    textLabel.textAlignment = UITextAlignmentLeft;
    [_mainView addSubview:textLabel];
    
    // Create clear label with business types in orange text
    _businessTypeTexts = [NSArray arrayWithObjects:@"spas", @"cafes", @"restaurants", @"salons", @"laundromats", @"bars", nil];
    UIFont* businessTypeFont = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    _businessTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(sizeUpsellString.width, _mainImageView.frame.origin.y + 30, stdiPhoneWidth - sizeUpsellString.width, sizeUpsellString.height + 20)];
    _businessTypeLabel.text = [_businessTypeTexts objectAtIndex:_currentIndex];
    _businessTypeLabel.backgroundColor = [UIColor clearColor];
    _businessTypeLabel.textColor = [UIColor orangeColor];
    [_businessTypeLabel setNumberOfLines:1];
    [_businessTypeLabel setFont:businessTypeFont];
    _businessTypeLabel.textAlignment = UITextAlignmentLeft;
    [_mainView addSubview:_businessTypeLabel];
    
    // Create signup button    
    CGFloat ypos = _mainImageView.frame.origin.y + _mainImageView.frame.size.height + 10;
    CGFloat xpos = 5;
    CGFloat buttonSize = (stdiPhoneWidth/2 - xpos*2);
    _signupButton = [self createCustomButton:@"Sign Up" btnImage:@"orange-button" btnWidth:buttonSize xpos:xpos ypos:ypos justification:leftJustify action:@selector(didPressSignupButton:)];
    [_mainView addSubview:_signupButton];
    
    // Create signin button
    _signinButton = [self createCustomButton:@"Sign In" btnImage:@"grey-button" btnWidth:buttonSize xpos:xpos ypos:ypos justification:rightJustify action:@selector(didPressSigninButton:)];
    [_signinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_mainView addSubview:_signinButton];
    
    self.view = _mainView;
}

- (UIButton*)createCustomButton:(NSString*)buttonText btnImage:(NSString*)btnImage btnWidth:(CGFloat)btnWidth xpos:(CGFloat)xpos ypos:(CGFloat)ypos justification:(JustificationType)justification action:(SEL)action
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:btnImage ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    UIFont* buttonFont = [UIFont fontWithName:@"Helvetica" size:18.0f];
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    CGRect originalRect = CGRectMake(0, ypos, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:btnWidth maxHeight:stdiPhoneHeight];
    if (justification == rightJustify)
    {
        finalRect.origin.x = stdiPhoneWidth - xpos - finalRect.size.width;
    }
    else if (justification == leftJustify)
    {
        finalRect.origin.x = xpos;
    }
    else
    {
        // In center justified scenarios, the xpos is actually the main frame width
        finalRect.origin.x = (xpos - finalRect.size.width)/2;
    }
    [newButton setFrame:finalRect];
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    [newButton setTitle:buttonText forState:UIControlStateNormal];
    newButton.titleLabel.font = buttonFont;
    return newButton;
}

- (void)changeImage
{
    _currentIndex++;
    if(_currentIndex == [_imageFiles count])
    {
        _currentIndex = 0;
    }

    UIImage * toImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [_imageFiles objectAtIndex:_currentIndex]]];
    [UIView transitionWithView:self.view
                      duration:1.75f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [_mainImageView setImage:toImage];
                        _businessTypeLabel.text = [_businessTypeTexts objectAtIndex:_currentIndex];
                    } completion:NULL];
}


#pragma mark - event actions

- (void)didPressSignupButton:(id)sender
{    
    InviteCodeView* inviteView = [[InviteCodeView alloc] initWithFrame:self.view.frame];
    [inviteView setController:self.navigationController];
    [_mainView addSubview:inviteView];
}

- (void)didPressSigninButton:(id)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

@end

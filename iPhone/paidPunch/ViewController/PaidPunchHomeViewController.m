//
//  PaidPunchHomeViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "AccountViewController.h"
#import "ATSurveys.h"
#import "BalanceViewController.h"
#import "BizView.h"
#import "Businesses.h"
#import "HiAccuracyLocator.h"
#import "MyCouponsView.h"
#import "NoBizView.h"
#import "PaidPunchHomeViewController.h"
#import "Punches.h"
#import "User.h"
#import "Utilities.h"
#import "VoteBusinessesViewController.h"

@implementation PaidPunchHomeViewController
@synthesize launchMyCouponsOnWillAppear = _launchMyCouponsOnWillAppear;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hud = nil;
    
    // Check for surveys
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(surveyBecameAvailable:)
                                                 name:ATSurveyNewSurveyAvailableNotification object:nil];
    [ATSurveys checkForAvailableSurveys];
    
    _launchMyCouponsOnWillAppear = FALSE;
    _currentBizView = nil;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	
    [self createNavBar];
    
    [self createSuggestBusinessButton];
    
    _bizBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, _lowestYPos + 3, stdiPhoneWidth, stdiPhoneHeight - (_lowestYPos + 10))];
    [_mainView addSubview:_bizBaseView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _updatingBusinesses = FALSE;
    _updatingUserInfo = FALSE;
    
    // User info hasn't been updated in a while; update it
    if ([[User getInstance] needsRefresh])
    {
        _updatingUserInfo = TRUE;
        [[User getInstance] getUserInfoFromServer:self];
    }
    else
    {
        [_creditsButton setTitle:[NSString stringWithFormat:@"%@", [[User getInstance] getCreditAsString]] forState:UIControlStateNormal];
    }
    
    if ([[Punches getInstance] justPurchasedPunch])
    {
        [_paidpunchButton startPPGlow];
    }
    
    // Launch my coupons view
    if (_launchMyCouponsOnWillAppear)
    {
        [self showMyCoupons];
    }
    
    if ([[User getInstance] useZipcodeForLocation])
    {
        // Indicate that location does not need to be refreshed
        [[User getInstance] indicateLocationRefreshed];
        
        if ([[Businesses getInstance] needsRefresh])
        {
            _updatingBusinesses = TRUE;
            [[Businesses getInstance] retrieveBusinessesFromServer:self];
        }
        else
        {
            [self createHomePageView:nil];
        }
    }
    else
    {
        if ([[User getInstance] locationNeedsRefresh])
        {
            // Start by locating user
            _updatingBusinesses = TRUE;
            [[HiAccuracyLocator getInstance] setDelegate:self];
            [[HiAccuracyLocator getInstance] startUpdatingLocation];
        }
        else
        {
            [self createHomePageView:[[HiAccuracyLocator getInstance] bestLocation]];
        }
    }
    
    if (_updatingUserInfo || _updatingBusinesses)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"Updating";
    }
}

#pragma mark - private functions

- (void)removeProgressSpinnerIfNecessary
{
    if (!_updatingUserInfo && !_updatingBusinesses)
    {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        _hud = nil;
    }
}

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
    
    UIButton* leftButton = [self createAccountButton:5 ypos:kDistanceFromTop maxWidth:maxElementWidth maxHeight:maxElementHeight];
    [_mainView addSubview:leftButton];
    
    _paidpunchButton = [self createPaidPunchButton:stdiPhoneWidth ypos:kDistanceFromTop maxWidth:maxElementWidth maxHeight:maxElementHeight];
    [_mainView addSubview:_paidpunchButton];
    
    _creditsButton = [self createCreditsButton:5 ypos:kDistanceFromTop maxWidth:maxElementWidth maxHeight:maxElementHeight];
    [_mainView addSubview:_creditsButton];
    
    _lowestYPos = navbarImg.frame.origin.y + navbarImg.frame.size.height;
}

- (UIButton*)createAccountButton:(CGFloat)xpos ypos:(CGFloat)ypos maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    // Get imagedata
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"list-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:@selector(didPressAccountButton:) forControlEvents:UIControlEventTouchUpInside];
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    
    CGRect buttonSize = CGRectMake(0, 0, image.size.width + 30, image.size.height + 10);
    buttonSize = [Utilities resizeProportionally:buttonSize maxWidth:maxWidth maxHeight:maxHeight];
    CGFloat buttonWidth = buttonSize.size.width;
    CGFloat buttonHeight = buttonSize.size.height;
    
    [newButton setFrame:CGRectMake(xpos, ypos, buttonWidth, buttonHeight)];
    
    return newButton;
}

- (HomePaidPunchButton*)createPaidPunchButton:(CGFloat)xpos ypos:(CGFloat)ypos maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    // Get imagedata
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pp_icon" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    CGRect buttonSize = CGRectMake(0, 0, image.size.width + 30, image.size.height + 10);
    buttonSize = [Utilities resizeProportionally:buttonSize maxWidth:maxWidth maxHeight:maxHeight];
    CGFloat buttonWidth = buttonSize.size.width;
    CGFloat buttonHeight = buttonSize.size.height;
    
    CGFloat realXPos = (xpos - buttonWidth)/2;
    CGRect frame = CGRectMake(realXPos, ypos, buttonWidth, buttonHeight);
    
    HomePaidPunchButton* newButton = [[HomePaidPunchButton alloc] initCustom:frame image:image delegate:self];
    
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
    [newButton setTitle:[NSString stringWithFormat:@"%@", [[User getInstance] getCreditAsString]] forState:UIControlStateNormal];
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
    
    CGRect originalRect = CGRectMake(0, _lowestYPos + 3, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 60) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    
    suggestButton.frame = finalRect;
    [suggestButton setBackgroundImage:image forState:UIControlStateNormal];
    [suggestButton setTitle:@"Vote For Businesses" forState:UIControlStateNormal];
    [suggestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    suggestButton.titleLabel.font = textFont;
    [suggestButton addTarget:self action:@selector(didPressSuggestBusinessButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainView addSubview:suggestButton];
    
    _lowestYPos = finalRect.origin.y + finalRect.size.height;
}

- (void)createHomePageView:(CLLocation*)location
{
    NSArray* businesses = [[Businesses getInstance] getBusinessesCloseby:location];
    if ([businesses count] > 0)
    {
        [self createBizView:businesses];
    }
    else
    {
        [self createNoBizView];
    }
}

- (void)createBizView:(NSArray*)businesses
{
    if (_currentBizView != nil)
    {
        [_currentBizView removeFromSuperview];
    }
    CGRect bizRect = CGRectMake(0, 0, _bizBaseView.frame.size.width, _bizBaseView.frame.size.height);
    BizView* bizView = [[BizView alloc] initWithFrameAndBusinesses:bizRect businesses:businesses];
    [_bizBaseView addSubview:bizView];
    _currentBizView = bizView;
}

- (void)createNoBizView
{
    if (_currentBizView != nil)
    {
        [_currentBizView removeFromSuperview];
    }
    CGRect nobizRect = CGRectMake(0, 0, _bizBaseView.frame.size.width, _bizBaseView.frame.size.height);
    NoBizView* nobizView = [[NoBizView alloc] initWithFrame:nobizRect];
    [_bizBaseView addSubview:nobizView];
    _currentBizView = nobizView;
}

- (void)showMyCoupons
{
    _launchMyCouponsOnWillAppear = FALSE;
    MyCouponsView* myCouponsView = [[MyCouponsView alloc] initWithFrame:self.view.frame];
    [_mainView addSubview:myCouponsView];
}

#pragma mark - event actions

- (void)didPressAccountButton:(id)sender
{
    AccountViewController *accountViewController = [[AccountViewController alloc] init];
    
    // Totally hacky way to communicate between the two view controllers
    [accountViewController setParentController:self];
    
    [self.navigationController pushViewController:accountViewController animated:YES];
}

- (void)didPressCreditsButton:(id)sender
{
    BalanceViewController *balanceViewController = [[BalanceViewController alloc] init];
    [self.navigationController pushViewController:balanceViewController animated:NO];
}

- (void)didPressSuggestBusinessButton:(id)sender
{
    VoteBusinessesViewController *voteViewController = [[VoteBusinessesViewController alloc] init];
    [self.navigationController pushViewController:voteViewController animated:NO];
}

- (void)didPressHomePaidPunchButton
{
    [_paidpunchButton stopPPGlow];
    [self showMyCoupons];
}

- (void)surveyBecameAvailable:(NSNotification *)notification
{
    [ATSurveys presentSurveyControllerFromViewController:self];
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{
    if ([type compare:kKeyUsersGetInfo] == NSOrderedSame)
    {
        _updatingUserInfo = FALSE;
        [self removeProgressSpinnerIfNecessary];
        if (success)
        {
            [_creditsButton setTitle:[NSString stringWithFormat:@"%@", [[User getInstance] getCreditAsString]] forState:UIControlStateNormal];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else if ([type compare:kKeyBusinessesRetrieval] == NSOrderedSame)
    {
        _updatingBusinesses = FALSE;
        [self removeProgressSpinnerIfNecessary];
        if (success)
        {
            if ([[User getInstance] useZipcodeForLocation])
            {
                [self createHomePageView:nil];
            }
            else
            {
                [self createHomePageView:[[HiAccuracyLocator getInstance] bestLocation]];    
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [self createNoBizView];
        }
    }
    else
    {
        NSLog(@"Unknown HTTP completion call");
    }
}

#pragma mark - HiAccuracyLocatorDelegate
- (void) locator:(HiAccuracyLocator *)locator didLocateUser:(BOOL)didLocateUser reason:(StopReason)reason
{
    if(didLocateUser)
    {
        [[User getInstance] indicateLocationRefreshed];
        if ([[User getInstance] isUserInNewLocation:[[HiAccuracyLocator getInstance] bestLocation]] &&
            [[Businesses getInstance] needsRefresh])
        {
            [[Businesses getInstance] retrieveBusinessesFromServer:self];
        }
        else
        {
            // User hasn't moved much or businesses don't need to be refreshed yet
            _updatingBusinesses = FALSE;
            [self removeProgressSpinnerIfNecessary];
            [self createHomePageView:[[HiAccuracyLocator getInstance] bestLocation]];
        }
    }
    else
    {
        _updatingBusinesses = FALSE;
        [self removeProgressSpinnerIfNecessary];
        if (reason == kStopReasonDenied)
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Unable to locate!" message:@"We were not find your current location. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        [self createNoBizView];
    }
}

@end

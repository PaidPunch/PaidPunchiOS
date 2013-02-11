//
//  BusinessPageViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "Businesses.h"
#import "BusinessDescView.h"
#import "BusinessMapView.h"
#import "BusinessPageViewController.h"
#import "Punches.h"
#import "User.h"

@interface BusinessPageViewController ()

@end

static CGFloat const kButtonHeight = 40;

@implementation BusinessPageViewController

- (id)initWithBusiness:(NSString*)business_id business_name:(NSString*)business_name
{
    self = [super init];
    if (self)
    {
        _bizId = business_id;
        _bizname = business_name;
        
        _descView = nil;
        _mapView = nil;
        _callView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self createMainView:[UIColor whiteColor]];
    
    [self createSilverBackgroundWithImage];
    
    _business = [[Businesses getInstance] getBusinessOffersById:_bizId];
    if (_business == nil)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"Retrieving business info";
        
        [[Businesses getInstance] retrieveBusinessesFromServer:self];
    }
    else
    {
        NSArray* offers = [_business getOffers];
        if (offers != nil)
        {
            [self createBusinessView];
        }
        else
        {
            _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"Retrieving business info";
            [_business retrieveOffersFromServer:self];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (void)createBusinessView
{
    [self createNavBar:@"Back" rightString:nil middle:[[_business business] business_name] isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    [self createTopTabBar];
    
    // Description is selected by default
    [_descButton setSelected:TRUE];
    
    _descView = [[BusinessDescView alloc] initWithFrameAndBusiness:CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos) business:[_business business] punchcard:[[_business getOffers] objectAtIndex:0]];
    [_mainView addSubview:_descView];
    _currentView = _descView;
}

- (void)createTopTabBar
{
    // Create Description tab
    _descButton = [self createTabBarButton:@"Description" unselected:@"LEFT-NOTselected.png" selected:@"LEFT-selected.png" action:@selector(didPressDescriptionButton:) position:0];
    [_mainView addSubview:_descButton];
    
    // Create Map tab
    _mapButton = [self createTabBarButton:@"Map" unselected:@"CENTER-NOTselected.png" selected:@"CENTER-selected.png" action:@selector(didPressMapButton:) position:1];
    [_mainView addSubview:_mapButton];
    
    // Create Call tab
    _callButton = [self createTabBarButton:@"Call" unselected:@"RIGHT-NOTselected.png" selected:@"RIGHT-selected.png" action:@selector(didPressCallButton:) position:2];
    [_mainView addSubview:_callButton];
    
    _lowestYPos = _lowestYPos + kButtonHeight;
}

- (UIButton*)createTabBarButton:(NSString*)btnText unselected:(NSString*)unselected selected:(NSString*)selected action:(SEL)action position:(NSUInteger)position
{
    CGFloat buttonWidth = stdiPhoneWidth/3;
    CGFloat buttonXPos = buttonWidth * position;
    CGFloat buttonYPos = _lowestYPos;
    UIButton* newButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXPos, buttonYPos, buttonWidth, kButtonHeight)];
    [newButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [newButton setBackgroundImage:[UIImage imageNamed:unselected] forState:UIControlStateNormal];
    [newButton setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [newButton setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateHighlighted];
    [newButton setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected | UIControlStateDisabled];
    [newButton setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateDisabled];
    [newButton setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected | UIControlStateHighlighted];
    [newButton setTitle:btnText forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[newButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:13.0f]];
    
    return newButton;
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{
    if ([type compare:kKeyBusinessesRetrieval] == NSOrderedSame)
    {
        if (success)
        {
            _business = [[Businesses getInstance] getBusinessOffersById:_bizId];
            [_business retrieveOffersFromServer:self];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else if ([type compare:kKeyBusinessOffersRetrieval] == NSOrderedSame)
    {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        if (success)
        {
            [self createBusinessView];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else
    {
        NSLog(@"Unknown HTTP completion call");
    }
}

#pragma mark - event actions

- (void)didPressDescriptionButton:(id)sender
{
    if (!_descButton.selected)
    {
        [_descButton setSelected:TRUE];
        [_mapButton setSelected:FALSE];
        
        // Remove current view from _mainview
        [_currentView removeFromSuperview];
        
        [_mainView addSubview:_descView];
        _currentView = _descView;
    }
}

- (void)didPressMapButton:(id)sender
{
    if (!_mapButton.selected)
    {
        [_mapButton setSelected:TRUE];
        [_descButton setSelected:FALSE];
        
        // Remove current view from _mainview
        [_currentView removeFromSuperview];
        
        if (_mapView == nil)
        {
            PunchCard* current = [[_business getOffers] objectAtIndex:0];
            _mapView = [[BusinessMapView alloc] initWithFrameAndPunches:CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos) punchcard:current business:[_business business]];
        }
        
        [_mainView addSubview:_mapView];
        _currentView = _mapView;
        
    }
}

- (void)didPressCallButton:(id)sender
{
    NSString* contactUrl = [NSString stringWithFormat:@"telprompt://%@", [[_business business] contactno]];
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:contactUrl]])
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"No Phone Available" message:@"This device is incapable of making phonecalls." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

@end

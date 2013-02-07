//
//  BusinessPageViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "BusinessDescView.h"
#import "BusinessMapView.h"
#import "BusinessPageViewController.h"
#import "DatabaseManager.h"
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
        
        _networkManager =[[NetworkManager alloc] init];
        _networkManager.delegate = self;
        
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
    
    _business = [[DatabaseManager sharedInstance] getBusinessByBusinessId:_bizId];
    if (_business == nil)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"Retrieving business info";
        
        [_networkManager searchByName:_bizname loggedInUserId:[[User getInstance] userId]];
    }
    else
    {
        if ([self retrievePunchcard])
        {
            [self createBusinessView]; 
        }
        else
        {
            [_networkManager getBusinessOffer:_business.business_name loggedInUserId:[[User getInstance] userId]];
        }
    }
}

-(void)viewDidUnload
{
    // This is here to break any circular references that might have occurred
    _business.punchCard = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (BOOL)retrievePunchcard
{
    BOOL retrieved = FALSE;
    if (_business.punchCard == nil)
    {
        _business.punchCard = [[Punches getInstance] getPunchcardByBusinessId:[_business business_id]];
        retrieved = (_business.punchCard != nil);
    }
    else
    {
        retrieved = TRUE;
    }
    return retrieved;
}

- (void)createBusinessView
{
    UIFont* middleFont = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
    [self createNavBar:@"Back" rightString:nil middle:[_business business_name] middleFont:middleFont isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    [self createTopTabBar];
    
    // Description is selected by default
    [_descButton setSelected:TRUE];
    
    _descView = [[BusinessDescView alloc] initWithFrameAndBusiness:CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos) business:_business];
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
    [[newButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
    
    return newButton;
}

#pragma mark - event actions

- (void)didFinishSearchByName:(NSString *)statusCode
{
    if ([statusCode rangeOfString:@"00"].location == NSNotFound)
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to locate business information" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        if ([self retrievePunchcard])
        {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
            [self createBusinessView];
        }
        else
        {
            [_networkManager getBusinessOffer:_business.business_name loggedInUserId:[[User getInstance] userId]];
        }
    }
}

- (void) didFinishLoadingBusinessOffer:(NSString *)statusCode statusMessage:(NSString *)message punchCardDetails:(PunchCard*)punchCard
{
    if ([statusCode rangeOfString:@"00"].location == NSNotFound || punchCard == nil)
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to locate business information" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
        _business.punchCard = punchCard;
        [self createBusinessView];
    }
}

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
            PunchCard* current = [_business punchCard];
            [current setBusiness:_business];
            NSMutableArray* punchcardArray = [[NSMutableArray alloc] init];
            [punchcardArray addObject:current];
            
            _mapView = [[BusinessMapView alloc] initWithFrameAndPunches:CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos) punchcardArray:punchcardArray];
        }
        
        [_mainView addSubview:_mapView];
        _currentView = _mapView;
        
    }
}

- (void)didPressCallButton:(id)sender
{

}

@end

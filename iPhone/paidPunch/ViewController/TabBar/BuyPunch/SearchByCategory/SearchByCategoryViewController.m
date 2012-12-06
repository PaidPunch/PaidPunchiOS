//
//  SearchViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 27/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "SearchByCategoryViewController.h"

@implementation SearchByCategoryViewController

#define kCellHeight		107.0

@synthesize searchTableView;
@synthesize locateView;
@synthesize settingsView;
@synthesize totalMilesTxtField;
@synthesize businessList;
@synthesize cityTxtField;
@synthesize locationMgr;
@synthesize currentLocation;
//@synthesize activity;

@synthesize numberPadDoneImageNormal;
@synthesize numberPadDoneImageHighlighted;
@synthesize numberPadDoneButton;

@synthesize lastRefreshTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    
    UIImage *rightBtnImage = [UIImage imageNamed:@"Locator.png"];
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	rightButton.bounds = CGRectMake( 0, 0, rightBtnImage.size.width, rightBtnImage.size.height );    
	[rightButton setBackgroundImage:rightBtnImage forState:UIControlStateNormal];
	[rightButton addTarget:self action:@selector(settingsBtnTouchUpInsideHandler:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightBtnOnNavigation = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	self.navigationItem.rightBarButtonItem = rightBtnOnNavigation;

    
	UIImage *leftBtnImage = [UIImage imageNamed:@"SearchSettingsBtn.png"];
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.bounds = CGRectMake( 0, 0, leftBtnImage.size.width, leftBtnImage.size.height );    
	[leftButton setBackgroundImage:leftBtnImage forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(locateBtnTouchUpInsideHandler:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBtnOnNavigation = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftBtnOnNavigation;

    self.searchTableView.backgroundColor = [UIColor clearColor];
	self.searchTableView.sectionFooterHeight = 0;
    self.searchTableView.separatorColor=[UIColor clearColor];
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    totalMilesTxtField.text=[[[InfoExpert sharedInstance] totalMilesValue] stringValue];
    [[InfoExpert sharedInstance] setSearchType:SEARCH_BY_CURRENT_LOCATION];
    
    locateViewFlag=0;
    settingsViewFlag=0;
    [[InfoExpert sharedInstance] setSearchCriteria:1];
    
    if (_refreshHeaderView == nil) {
		
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - searchTableView.bounds.size.height, self.view.frame.size.width, searchTableView.bounds.size.height) isForSearchView:kEGOType_SearchByCat];
		view.delegate = self;
		[searchTableView addSubview:view];
		_refreshHeaderView = view;
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
        self.numberPadDoneImageNormal = [UIImage imageNamed:@"bluedonebtn.png"];
        self.numberPadDoneImageHighlighted = [UIImage imageNamed:@"greydonebtn.png"];
    } else {        
        self.numberPadDoneImageNormal = [UIImage imageNamed:@"bluedonebtn.png"];
        self.numberPadDoneImageHighlighted = [UIImage imageNamed:@"greydonebtn.png"];
    }        
    self.lastRefreshTime=[NSDate date];
    
    popupHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:popupHUD];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.totalMilesTxtField.text=[[[InfoExpert sharedInstance] totalMilesValue] stringValue];
    self.cityTxtField.text=[[InfoExpert sharedInstance] cityOrZipCodeValue];
    self.currentLocation=nil;
    // Add listener for keyboard display events
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardDidShow:) 
                                                     name:UIKeyboardDidShowNotification 
                                                   object:nil];     
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
    }
    
    // Add listener for all text fields starting to be edited
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(textFieldBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification 
                                               object:nil];
    self.locateView.hidden=YES;
    self.settingsView.hidden=YES;
    settingsViewFlag=0;
    locateViewFlag=0;
    
    NSTimeInterval interval=[[NSDate date] timeIntervalSinceDate:self.lastRefreshTime];
    int hours=(int)interval/3600;
    int minutes=(interval -(hours * 3600))/60;
    if(minutes>=2 || [[[DatabaseManager sharedInstance] getAllBusinesses] count]<=0)
    {
        self.lastRefreshTime=[NSDate date];
        [self loadBusinessList];
    }
    NSLog(@"HH = %d MM = %d" ,hours,minutes);

    
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:UIKeyboardDidShowNotification 
                                                      object:nil];      
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:UIKeyboardWillShowNotification 
                                                      object:nil];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UITextFieldTextDidBeginEditingNotification 
                                                  object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setSearchTableView:nil];
    [self setLocateView:nil];
    [self setSettingsView:nil];
    [self setTotalMilesTxtField:nil];
    [self setCityTxtField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Cleanup


#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 4;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier=@"Cell";
	
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;    
    
    UIImageView *bgImageView=[[UIImageView alloc] init];
    
    if(indexPath.row==0)
    {
        cell.textLabel.text=@"eat";
        bgImageView.image=[UIImage imageNamed:@"Eat.png"];
    }
    if(indexPath.row==1)
    {
        cell.textLabel.text=@"drink";
        bgImageView.image=[UIImage imageNamed:@"Drink.png"];
    }
    if(indexPath.row==2)
    {
        cell.textLabel.text=@"relax";
        bgImageView.image=[UIImage imageNamed:@"Relax.png"];
    }
    if(indexPath.row==3)
    {
        cell.textLabel.text=@"essentials";
        bgImageView.image=[UIImage imageNamed:@"Essentials.png"];
    }
    cell.backgroundView=bgImageView;
    cell.textLabel.textColor=[UIColor whiteColor];
   	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods Implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex=indexPath.row;
    currentBtnClicked=NO;
    NSNumber *sMiles=[NSNumber numberWithDouble:[totalMilesTxtField.text doubleValue]];

    if([[InfoExpert sharedInstance] searchType]==SEARCH_BY_NAME)
    {
        if([[InfoExpert sharedInstance] searchCriteria]==1)
            [[InfoExpert sharedInstance] setSearchType:SEARCH_BY_CURRENT_LOCATION];
        if([[InfoExpert sharedInstance] searchCriteria]==2)
            [[InfoExpert sharedInstance] setSearchType:SEARCH_BY_CITY];
        if([[InfoExpert sharedInstance] searchCriteria]==3)
            [[InfoExpert sharedInstance] setSearchType:SEARCH_BY_ZIPCODE];
    }
    if([[InfoExpert sharedInstance] searchType]==SEARCH_BY_CURRENT_LOCATION)
    {
        [self showPopup];
        self.locationMgr = [[CLLocationManager alloc] init];
        self.locationMgr.delegate = self; // send loc updates to myself
    
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest; 
        locationMgr.distanceFilter = kCLDistanceFilterNone;
        self.currentLocation=nil;
        if([CLLocationManager locationServicesEnabled])
        {
            [self.locationMgr startUpdatingLocation];
        }
        else
        {
            [self removePopup];
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    }
    else
    {
        if(indexPath.row==0)
        {
            [self goToSearchListView:[[InfoExpert sharedInstance] searchType] withCategory:@"eat" withTotalMiles:sMiles];
        }
        if(indexPath.row==1)
        {
            [self goToSearchListView:[[InfoExpert sharedInstance] searchType] withCategory:@"drink" withTotalMiles:sMiles];
        }
        if(indexPath.row==2)
        {
            [self goToSearchListView:[[InfoExpert sharedInstance] searchType] withCategory:@"relax" withTotalMiles:sMiles];
        }
        if(indexPath.row==3)
        {
            [self goToSearchListView:[[InfoExpert sharedInstance] searchType] withCategory:@"essentials" withTotalMiles:sMiles];
        }
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods Implementation

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self removePopup];
    [self.locationMgr stopUpdatingLocation];
    CLLocation *prevLocation=self.currentLocation;
    self.currentLocation = newLocation;
    NSNumber *sMiles=[NSNumber numberWithDouble:[totalMilesTxtField.text doubleValue]];
    if(prevLocation==nil && [[InfoExpert sharedInstance] searchType] == SEARCH_BY_NAME)
    {
        [self goToSearchListView:[[InfoExpert sharedInstance] searchType] withCategory:nil withTotalMiles:sMiles];
    }
    else
        if(prevLocation==nil && currentBtnClicked==NO)
        {
            //[self goToSearchListView:SEARCH_BY_CURRENT_LOCATION withCategory:nil withTotalMiles:sMiles];
            if(selectedIndex==0)
            {
                [self goToSearchListView:[[InfoExpert sharedInstance] searchType] withCategory:@"eat" withTotalMiles:sMiles];
            }
            if(selectedIndex==1)
            {
                [self goToSearchListView:[[InfoExpert sharedInstance] searchType] withCategory:@"drink" withTotalMiles:sMiles];
            }
            if(selectedIndex==2)
            {
                [self goToSearchListView:[[InfoExpert sharedInstance] searchType] withCategory:@"relax" withTotalMiles:sMiles];
            }
            if(selectedIndex==3)
            {
                [self goToSearchListView:[[InfoExpert sharedInstance] searchType] withCategory:@"essentials" withTotalMiles:sMiles];
            }
            
        }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self removePopup];
    [self.locationMgr stopUpdatingLocation];
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods Implementation

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==totalMilesTxtField)
    {
        if([textField.text length]<5)
            return YES;
        else
        {
            if([string isEqualToString:@""])
                return YES;
            return NO;
        }

    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==cityTxtField)
    {
        settingsView.hidden=YES;
        [totalMilesTxtField resignFirstResponder];
        //locateView.hidden=YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[InfoExpert sharedInstance] setCityOrZipCodeValue:self.cityTxtField.text];
    if(textField==cityTxtField)
    {
        NSString *str = cityTxtField.text;
        NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
        BOOL valid = [[str stringByTrimmingCharactersInSet: decimalSet] isEqualToString:@""];
        if(valid)
        {
            [[InfoExpert sharedInstance] setSearchType:SEARCH_BY_ZIPCODE];
            [[InfoExpert sharedInstance] setSearchCriteria:3];
        }
        else
        {
            [[InfoExpert sharedInstance] setSearchType:SEARCH_BY_CITY];
            [[InfoExpert sharedInstance] setSearchCriteria:2];
        }
    }
    [textField resignFirstResponder];
    self.locateView.hidden=YES;
    
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishSearchByName:(NSString*)statusCode
{ 
    if([statusCode rangeOfString:@"00"].location == NSNotFound)
    {
        
    }
    else
    {
        NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
        NSArray *dblist=[[DatabaseManager sharedInstance] getAllBusinesses];
        self.businessList=[dblist sortedArrayUsingDescriptors:dateSortDescriptors];
        
    }
}

#pragma mark -
#pragma mark Handling Keypad Events for Adding Done btn on NumberPad 

- (UIView *)findFirstResponderUnder:(UIView *)root {
    if (root.isFirstResponder)
        return root;    
    for (UIView *subView in root.subviews) {
        UIView *firstResponder = [self findFirstResponderUnder:subView];        
        if (firstResponder != nil)
            return firstResponder;
    }
    return nil;
}

- (UITextField *)findFirstResponderTextField {
    UIResponder *firstResponder = [self findFirstResponderUnder:[self.view window]];
    if (![firstResponder isKindOfClass:[UITextField class]])
        return nil;
    return (UITextField *)firstResponder;
}

- (void)updateKeyboardButtonFor:(UITextField *)textField {
    
    // Remove any previous button
    [self.numberPadDoneButton removeFromSuperview];
    self.numberPadDoneButton = nil;
    
    // Does the text field use a number pad?
    if (textField.keyboardType != UIKeyboardTypeNumberPad)
        return;
    
    // If there's no keyboard yet, don't do anything
    if ([[[UIApplication sharedApplication] windows] count] < 2)
        return;
    UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    // Create new custom button
    self.numberPadDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numberPadDoneButton.frame = CGRectMake(0, 163, self.numberPadDoneImageNormal.size.width, self.numberPadDoneImageNormal.size.height);
    self.numberPadDoneButton.adjustsImageWhenHighlighted = FALSE;
    [self.numberPadDoneButton setBackgroundImage:self.numberPadDoneImageNormal forState:UIControlStateNormal];
    [self.numberPadDoneButton setBackgroundImage:self.numberPadDoneImageHighlighted forState:UIControlStateHighlighted];
    [self.numberPadDoneButton addTarget:self action:@selector(numberPadDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // Locate keyboard view and add button
    NSString *keyboardPrefix = [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2 ? @"<UIPeripheralHost" : @"<UIKeyboard";
    for (UIView *subView in keyboardWindow.subviews) {
        if ([[subView description] hasPrefix:keyboardPrefix]) {
            [subView addSubview:self.numberPadDoneButton];
            [self.numberPadDoneButton addTarget:self action:@selector(numberPadDoneButton:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
}

- (void)textFieldBeginEditing:(NSNotification *)note {
    [self updateKeyboardButtonFor:[note object]];
}

- (void)keyboardWillShow:(NSNotification *)note {
    [self updateKeyboardButtonFor:[self findFirstResponderTextField]];
}

- (void)keyboardDidShow:(NSNotification *)note {
    [self updateKeyboardButtonFor:[self findFirstResponderTextField]];
}


#pragma mark -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    settingsView.hidden=YES;
    locateView.hidden=YES;
    [self.totalMilesTxtField resignFirstResponder];
    [self.cityTxtField resignFirstResponder];
}

#pragma mark -

- (IBAction)numberPadDoneButton:(id)sender {
    [[InfoExpert sharedInstance] setTotalMilesValue:[NSNumber numberWithDouble:[self.totalMilesTxtField.text doubleValue]]];
    UITextField *textField = [self findFirstResponderTextField];
    [textField resignFirstResponder];
    self.settingsView.hidden=YES;
}

-(void)settingsBtnTouchUpInsideHandler:(id)sender
{
    if(settingsViewFlag==0)
    {
        settingsView.hidden=NO;
        [totalMilesTxtField becomeFirstResponder];
        settingsViewFlag=1;
    }
    else
    {
        settingsView.hidden=YES;
        settingsViewFlag=0;
        [self.totalMilesTxtField resignFirstResponder];
    }
    locateView.hidden=YES;
    
    
}
-(void)locateBtnTouchUpInsideHandler:(id)sender
{
    if(locateViewFlag==0)
    {
        locateView.hidden=NO;
        locateViewFlag=1;
        [self.cityTxtField becomeFirstResponder];
    }
    else
    {
        locateView.hidden=YES;
        locateViewFlag=0;
        [self.cityTxtField resignFirstResponder];
    }
    settingsView.hidden=YES;
    [self.totalMilesTxtField resignFirstResponder];
}

- (IBAction)currentLocationBtnTouchUpInsideHandler:(id)sender {
    settingsView.hidden=YES;
    locateView.hidden=YES;
    self.cityTxtField.text=@"";
    [[InfoExpert sharedInstance] setCityOrZipCodeValue:@""];
    [[InfoExpert sharedInstance] setSearchType:SEARCH_BY_CURRENT_LOCATION];
    [[InfoExpert sharedInstance] setSearchCriteria:1];
    [self.cityTxtField resignFirstResponder];
    [self showPopup];
    self.locationMgr = [[CLLocationManager alloc] init];
    self.locationMgr.delegate = self; // send loc updates to myself
    
    currentBtnClicked=YES;
    
    locationMgr.desiredAccuracy = kCLLocationAccuracyBest; 
    locationMgr.distanceFilter = kCLDistanceFilterNone;
    self.currentLocation=nil;
    if([CLLocationManager locationServicesEnabled])
    {
        [self.locationMgr startUpdatingLocation];
    }
    else
    {
        [self removePopup];
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

- (IBAction)searchByNameBtnTouchUpInsideHandler:(id)sender
{
    NSNumber *sMiles=[NSNumber numberWithDouble:[totalMilesTxtField.text doubleValue]];
    [self goToSearchListView:SEARCH_BY_NAME withCategory:nil withTotalMiles:sMiles];
}

#pragma mark -

-(void) loadBusinessList
{
    [networkManager searchByName:@"" loggedInUserId:[[InfoExpert sharedInstance]userId]];
}

#pragma mark -

-(void) goToSearchListView:(NSString *)searchType withCategory:(NSString *)category withTotalMiles:(NSNumber *)sMiles
{
    [cityTxtField resignFirstResponder];
    [totalMilesTxtField resignFirstResponder];
    SearchListViewController *searchListViewController= [[SearchListViewController alloc] init:searchType withCategory:category withTotalMiles:sMiles withCurrentlocation:self.currentLocation withBusinessName:@"" withCityOrZipCode:cityTxtField.text];
    [self.navigationController pushViewController:searchListViewController animated:YES];
}

- (IBAction)goBack:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

-(void) showPopup
{
	/*NSArray *xibUIObjects =[[NSBundle mainBundle] loadNibNamed:@"NetworkActivity" owner:self options:nil];
	self.activity= [xibUIObjects objectAtIndex:0];
	[self.view addSubview:self.activity];
	NSString *msg=@"Fetching Location";
	UILabel *lbl= ((UILabel *)[self.activity viewWithTag:1]);
    lbl.text=msg;
    UIImage *imageGradient = [[Utility sharedInstance]gradientImage:lbl];
    lbl.textColor = [UIColor colorWithPatternImage:imageGradient];*/
    [popupHUD show:YES];
}

-(void) removePopup
{
    // finished loading, hide the activity indicator in the status bar
    /*if([self.activity respondsToSelector:@selector(viewWithTag:)])
	{
        [self.activity removeFromSuperview];
    }*/
    [popupHUD hide:YES];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderView Delegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	//EGO tells us that it has been pulled
//    SearchByCategoryViewController *searchByCategoryController = [[SearchByCategoryViewController alloc] init];
//    [self.navigationController pushViewController:searchByCategoryController animated:YES];
//    [searchByCategoryController release];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return NO; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods Implementation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

@end

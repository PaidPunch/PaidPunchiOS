//
//  SearchListViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 27/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "SearchListViewController.h"

@implementation SearchListViewController

@synthesize locateView;
@synthesize settingsView;
@synthesize categoryLbl;
@synthesize backImageView;
@synthesize backView;
@synthesize totalMilesTxtField;
@synthesize cityTxtField;
@synthesize noBusinessFoundLbl;
@synthesize searchBar;
@synthesize businessListTableView;
@synthesize searchType;
@synthesize category;
@synthesize businessName;
@synthesize cityOrZipCode;
@synthesize businessList;
@synthesize categoryImageView;
@synthesize userLocation;
@synthesize searchFilterType;
@synthesize locationMgr;
@synthesize currentLocation;
@synthesize activity;
@synthesize reverseGeoLocation;

@synthesize numberPadDoneImageNormal;
@synthesize numberPadDoneImageHighlighted;
@synthesize numberPadDoneButton;

#define kCellHeight		44.0
#define DegreesToRadians(degrees) (degrees * M_PI / 180)
#define M_PI   3.14159265358979323846264338327950288 
#define kOneMileMeters 1609.344


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init:(NSString *)sType withCategory:(NSString *)sCategory withTotalMiles:(NSNumber *)sMiles withCurrentlocation:(CLLocation *)uLocation withBusinessName:(NSString *)bName withCityOrZipCode:(NSString *)cityZipcode
{
    self = [super init];
    if (self) {
        // Custom initialization
//        self.searchType=sType;
        self.searchType = SEARCH_BY_ZIPCODE;
        self.category=sCategory;
        self.userLocation=uLocation;
        self.businessName=bName;
        shouldGoToPunchCardOfferPage = NO;
//        self.cityOrZipCode=cityZipcode;
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        self.cityOrZipCode = [ud objectForKey:@"userZipCode"];
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
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.titleView=self.searchBar;
    self.title=@"Back";
    
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
    
    self.noBusinessFoundLbl.textColor=[UIColor colorWithRed:244.0/255.0 green:123.0/255.0 blue:39.0/255.0 alpha:1];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
        self.numberPadDoneImageNormal = [UIImage imageNamed:@"bluedonebtn.png"];
        self.numberPadDoneImageHighlighted = [UIImage imageNamed:@"greydonebtn.png"];
    } else {        
        self.numberPadDoneImageNormal = [UIImage imageNamed:@"bluedonebtn.png"];
        self.numberPadDoneImageHighlighted = [UIImage imageNamed:@"greydonebtn.png"];
    }       
    
    if(self.searchType == SEARCH_BY_CITY)
    {
        self.searchFilterType=SEARCH_BY_CITY;
        self.categoryLbl.text=category;
        if(self.cityOrZipCode==nil)
        {
            
        }
        else
        {
            //self.businessList=[[DatabaseManager sharedInstance] getBusinessesByCityAndCategory:self.cityOrZipCode withCategory:self.category];
            CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityOrZipCode];
            NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
            CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
            self.businessList=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
            self.reverseGeoLocation=cloc;
        }
    }
    if(self.searchType == SEARCH_BY_ZIPCODE) 
    {
        self.searchFilterType=SEARCH_BY_ZIPCODE;
        self.categoryLbl.text=category;
        if(self.cityOrZipCode==nil)
        {
            
        }
        else
        {
            //self.businessList=[[DatabaseManager sharedInstance] getBusinessesByZipCodeAndCategory:self.cityOrZipCode withCategory:self.category];
            CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityOrZipCode];
            NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
            CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
            self.businessList=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
            self.reverseGeoLocation=cloc;
        }
    }
    if(self.searchType == SEARCH_BY_NAME)
    {
        self.searchFilterType=SEARCH_BY_NAME;
        self.categoryLbl.text=@"Search";
        NSArray *arr=[[DatabaseManager sharedInstance] getBusinessesByName:self.businessName];
        //by current location
        if([[InfoExpert sharedInstance] searchCriteria]==1)
        {
            self.businessList=[[DatabaseManager sharedInstance] getBusinessesByCurrentLocation:arr withCurrentLocation:userLocation withMiles:[[InfoExpert sharedInstance]totalMilesValue]];
        }
        else //by city
            if([[InfoExpert sharedInstance] searchCriteria]==2)
            {
                /*NSMutableArray *businessesByCity=[[[NSMutableArray alloc] init] autorelease];
                 for(Business *bObj in arr)
                 {
                 if([bObj.city.lowercaseString isEqualToString:self.cityOrZipCode.lowercaseString])
                 {
                 [businessesByCity addObject:bObj];
                 }
                 }
                 self.businessList=businessesByCity;*/
                CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityOrZipCode];
                NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                self.businessList=[[DatabaseManager sharedInstance] getBusinessesByCurrentLocation:arr withCurrentLocation:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue]];
                self.reverseGeoLocation=cloc;
                
            }
            else //by zipcode
                if([[InfoExpert sharedInstance] searchCriteria]==3)
                {
                    /*NSMutableArray *businessesByZipCode=[[[NSMutableArray alloc] init] autorelease];
                     for(Business *bObj in arr)
                     {
                     if([[bObj.pincode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:self.cityOrZipCode])
                     {
                     [businessesByZipCode addObject:bObj];
                     }
                     }
                     self.businessList=businessesByZipCode;*/
                    CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityOrZipCode];
                    NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                    CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                    self.businessList=[[DatabaseManager sharedInstance] getBusinessesByCurrentLocation:arr withCurrentLocation:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue]];
                    self.reverseGeoLocation=cloc;
                }
                else
                {
                    self.businessList=[[DatabaseManager sharedInstance] getBusinessesByName:self.businessName];
                }
        self.searchBar.placeholder=@"Search by name";
        self.searchBar.text=self.businessName;
    }
    if(self.searchType == SEARCH_BY_CURRENT_LOCATION)
    {
        self.searchFilterType=SEARCH_BY_CURRENT_LOCATION;
        self.categoryLbl.text=category;
        self.businessList=[[DatabaseManager sharedInstance] getBusinessesNearMe:self.userLocation withMiles:[[InfoExpert sharedInstance] totalMilesValue] withCategory:self.category];
    }
    
    if(self.category==@"eat")
    {
        self.categoryImageView.image=[UIImage imageNamed:@"Eat.png"];
    }
    if(self.category==@"drink")
    {
        self.categoryImageView.image=[UIImage imageNamed:@"Drink.png"];
    }
    if(self.category==@"play")
    {
        self.categoryImageView.image=[UIImage imageNamed:@"Play.png"];
    }
    if(self.category==@"relax")
    {
        self.categoryImageView.image=[UIImage imageNamed:@"Relax.png"];
    }
    if(self.category==@"essentials")
    {
        self.categoryImageView.image=[UIImage imageNamed:@"Essentials.png"];
    }
    
    self.businessListTableView.backgroundColor = [UIColor clearColor];
	self.businessListTableView.sectionFooterHeight = 0;
    
    
    locateViewFlag=0;
    settingsViewFlag=0;
    
    self.totalMilesTxtField.text=[[[InfoExpert sharedInstance] totalMilesValue] stringValue];
    //[[InfoExpert sharedInstance] setSearchCriteria:1];
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    popupHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:popupHUD];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.totalMilesTxtField.text=[[[InfoExpert sharedInstance] totalMilesValue] stringValue];
    self.cityTxtField.text=[[InfoExpert sharedInstance] cityOrZipCodeValue];
    
    self.navigationItem.hidesBackButton=YES;
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
    [self setBusinessListTableView:nil];
    [self setCategoryImageView:nil];
    [self setSearchBar:nil];
    [self setLocateView:nil];
    [self setSettingsView:nil];
    [self setCategoryLbl:nil];
    [self setBackImageView:nil];
    [self setBackView:nil];
    [self setTotalMilesTxtField:nil];
    [self setCityTxtField:nil];
    [self setNoBusinessFoundLbl:nil];
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
    if([self.businessList count]>0)
    {
        self.noBusinessFoundLbl.hidden=YES;
        self.businessListTableView.hidden=NO;
    }
    else
    {
        self.noBusinessFoundLbl.hidden=NO;
        self.businessListTableView.hidden=YES;
    }
    
    if(self.searchType==SEARCH_BY_CURRENT_LOCATION)
    {
        if(self.searchFilterType==SEARCH_BY_CURRENT_LOCATION)
        {
            NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"diff_in_miles" ascending:YES]];
            self.businessList=[businessList sortedArrayUsingDescriptors:dateSortDescriptors];
        }
        else
        {
            NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
            self.businessList=[businessList sortedArrayUsingDescriptors:dateSortDescriptors];
        }
    }
    else
    {
        if(self.searchFilterType==SEARCH_BY_CURRENT_LOCATION)
        {
            NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"diff_in_miles" ascending:YES]];
            self.businessList=[businessList sortedArrayUsingDescriptors:dateSortDescriptors];
        }
        else
        {
            NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
            self.businessList=[businessList sortedArrayUsingDescriptors:dateSortDescriptors];
        }

    }
    return [self.businessList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*static NSString *cellIdentifier=@"Cell";
     
     UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if(cell==nil)
     {
     cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
     }
     */
    
    static NSString *searchListViewCellIdentifier = @"SearchListViewCellIdentifier";
    
    SearchListViewCell *cell = (SearchListViewCell *)[tableView dequeueReusableCellWithIdentifier:searchListViewCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchlistViewCell" owner:self options:nil];
        cell  = (SearchListViewCell *)[nib objectAtIndex:0];
    }
    
	cell.selectionStyle=UITableViewCellSelectionStyleNone;    
    Business *business;
    business=[self.businessList objectAtIndex:indexPath.row];
    
    CLLocation *item1 =nil;
    if(self.currentLocation==nil)
        item1=userLocation;
    else
        item1=self.currentLocation;  
    if((self.searchType==SEARCH_BY_ZIPCODE || self.searchType==SEARCH_BY_CITY) && self.searchFilterType!=SEARCH_BY_CURRENT_LOCATION)
        item1=self.reverseGeoLocation;
    CLLocation *item2 = [[CLLocation alloc] initWithLatitude:[business.latitude doubleValue] longitude:[business.longitude doubleValue]];
    
    CLLocationDistance meters = [item1 distanceFromLocation:item2]; 
    //NSLog(@"Distance in metres: %f", meters);
    double distanceInMiles=meters/kOneMileMeters;
    //NSLog(@"Distance in miles: %f", distanceInMiles);
    if(distanceInMiles<[[[InfoExpert sharedInstance] totalMilesValue] doubleValue])
    {
    }
    
    cell.businessNameLbl.text=[NSString stringWithFormat:@"%d.  %@",indexPath.row+1,business.business_name];
    cell.businessNameLbl.adjustsFontSizeToFitWidth=NO;
    cell.businessNameLbl.lineBreakMode=UILineBreakModeTailTruncation;
    cell.businessNameLbl.font = [UIFont fontWithName:@"Helvetica" size:18];
    if((self.searchType==SEARCH_BY_NAME && ([[InfoExpert sharedInstance] searchCriteria]==2 || [[InfoExpert sharedInstance] searchCriteria] == 3)) || self.searchType==SEARCH_BY_CITY || self.searchType==SEARCH_BY_ZIPCODE)
    {
        if(self.searchFilterType==SEARCH_BY_CURRENT_LOCATION)
            cell.milesLbl.text=[NSString stringWithFormat:@"%.2f miles",distanceInMiles];
    }
    else
    {
        if(self.searchType==SEARCH_BY_CURRENT_LOCATION || (self.searchType==SEARCH_BY_NAME && self.searchFilterType==SEARCH_BY_CURRENT_LOCATION))
        {
            if(self.searchFilterType==SEARCH_BY_NAME || self.searchFilterType==SEARCH_BY_CURRENT_LOCATION)
                cell.milesLbl.text=[NSString stringWithFormat:@"%.2f miles",distanceInMiles];
        }
        if(self.searchFilterType==SEARCH_BY_NAME && self.searchFilterType==SEARCH_BY_NAME)
            cell.milesLbl.text=[NSString stringWithFormat:@"%.2f miles",distanceInMiles];
    }
    
    /*if((self.searchType==SEARCH_BY_NAME && ([[InfoExpert sharedInstance] searchCriteria]==2 || [[InfoExpert sharedInstance] searchCriteria] == 3)))
     {
     }
     else
     {
     cell.milesLbl.text=[NSString stringWithFormat:@"%.2f miles",distanceInMiles];
     }*/
    
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
    locateView.hidden=YES;
    settingsView.hidden=YES;
    [self.searchBar resignFirstResponder];
    Business *business;
    business=[businessList objectAtIndex:selectedIndex];
    if(business.punchCard==nil)
    {
        shouldGoToPunchCardOfferPage = YES;
        [self getBusinessOffer];
    }
    else
    {
        [self goToPunchCardOfferView:business.business_name punchCardDetails:business.punchCard];
    }
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishLoadingBusinessOffer:(NSString *)statusCode statusMessage:(NSString *)message punchCardDetails:(PunchCard*)punchCard;
{
    if(self.businessList!=nil && [self.businessList count]>0)
    {
        if(shouldGoToPunchCardOfferPage){
            Business *business=[self.businessList objectAtIndex:selectedIndex];
            if([statusCode isEqualToString:@"00"])
            {
                [business setPunchCard:punchCard];
                [punchCard setBusiness:business];
                [[DatabaseManager sharedInstance] saveEntity:nil];
                [self goToPunchCardOfferView:business.business_name punchCardDetails:punchCard];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        else {
            Business *business = [self getBizWithName:punchCard.business_name];
            if([statusCode isEqualToString:@"00"])
            {
                [business setPunchCard:punchCard];
                [punchCard setBusiness:business];
                [[DatabaseManager sharedInstance] saveEntity:nil];

                BOOL allCardsLoaded = YES;
                for(Business *biz in businessList){
                    if(biz.punchCard == nil){
                        //At least one isn't loaded
                        allCardsLoaded = NO;
                    }
                }
                if(allCardsLoaded){
                    [self showMap:nil];
                }
            }
        }
    }
}

#pragma mark -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touch event");
    locateView.hidden=YES;
    settingsView.hidden=YES;
    
    [self.totalMilesTxtField resignFirstResponder];
    [self.cityTxtField resignFirstResponder];
    [self.searchBar resignFirstResponder];
    
    UITouch *touch=[touches anyObject];
    if(touch.view==self.backView)
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}


#pragma mark -
#pragma mark UISearchBarDelegate methods Implementation

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    self.locateView.hidden=YES;
    self.settingsView.hidden=YES;
    self.searchFilterType=SEARCH_BY_NAME;
    
	[searchBar resignFirstResponder];
    NSArray *arr;
    //arr=[[DatabaseManager sharedInstance] getBusinessesByName:self.searchBar.text];
    NSNumber *sMiles=[NSNumber numberWithDouble:[totalMilesTxtField.text doubleValue]];
    //by current location
    if([[InfoExpert sharedInstance] searchCriteria]==1)
    {
        if(self.currentLocation==nil)
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
            if(self.searchType == SEARCH_BY_NAME)
            {
                NSArray *arr=[[DatabaseManager sharedInstance] getBusinessesByName:self.searchBar.text];
                arr=self.businessList=[[DatabaseManager sharedInstance] getBusinessesByCurrentLocation:arr withCurrentLocation:self.userLocation withMiles:sMiles];  
                self.businessList=arr;
                [self.businessListTableView reloadData];
            }
            else
            {
                NSNumber *sMiles=[NSNumber numberWithDouble:[totalMilesTxtField.text doubleValue]];
                arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:self.currentLocation withMiles:sMiles withCategory:self.category];
                
                NSMutableArray *businessesByName=[[NSMutableArray alloc] init];
                for(Business *bObj in arr)
                {
                    //if([bObj.business_name.lowercaseString isEqualToString:self.searchBar.text.lowercaseString])
                    if([bObj.business_name.lowercaseString hasPrefix:self.searchBar.text.lowercaseString])
                    {
                        [businessesByName addObject:bObj];
                    }
                }
                self.businessList=businessesByName;
                [self.businessListTableView reloadData];
                currentBtnClicked=NO;
            }
        }
    }
    else 
    {
        if(self.searchType == SEARCH_BY_NAME)
        {
            self.businessList=[[DatabaseManager sharedInstance] getBusinessesByName:self.searchBar.text];
            //by city
            if([[InfoExpert sharedInstance] searchCriteria]==2)
            {
                /*NSMutableArray *businessesByCity=[[[NSMutableArray alloc] init] autorelease];
                 for(Business *bObj in arr)
                 {
                 if([bObj.city.lowercaseString isEqualToString:self.cityTxtField.text.lowercaseString])
                 {
                 [businessesByCity addObject:bObj];
                 }
                 }
                 self.businessList=businessesByCity;*/
                CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityTxtField.text];
                NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                NSArray *arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
                self.reverseGeoLocation=cloc;
                
                NSMutableArray *businessesByCity=[[NSMutableArray alloc] init];
                for(Business *bObj in arr)
                {
                    if([bObj.business_name.lowercaseString hasPrefix:self.searchBar.text])
                    {
                        [businessesByCity addObject:bObj];
                    }
                }
                self.businessList=businessesByCity;
                
            }
            else //by zipcode
                if([[InfoExpert sharedInstance] searchCriteria]==3)
                {
                    /*NSMutableArray *businessesByZipCode=[[[NSMutableArray alloc] init] autorelease];
                     for(Business *bObj in arr)
                     {
                     if([[bObj.pincode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:self.cityTxtField.text])
                     {
                     [businessesByZipCode addObject:bObj];
                     }
                     }
                     self.businessList=businessesByZipCode;*/
                    CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityTxtField.text];
                    NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                    CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                    arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
                    self.reverseGeoLocation=cloc;
                    
                    NSMutableArray *businessesByZipCode=[[NSMutableArray alloc] init];
                    for(Business *bObj in arr)
                    {
                        if([bObj.business_name.lowercaseString hasPrefix:self.searchBar.text])
                        {
                            [businessesByZipCode addObject:bObj];
                        }
                    }
                    self.businessList=businessesByZipCode;
                    
                }
            
            [self.businessListTableView reloadData];
            
        }
        else
        {
            //by city
            if([[InfoExpert sharedInstance] searchCriteria]==2)
            {
                /*NSMutableArray *businessesByCity=[[[NSMutableArray alloc] init] autorelease];
                 for(Business *bObj in arr)
                 {
                 if([bObj.city.lowercaseString isEqualToString:self.cityTxtField.text.lowercaseString])
                 {
                 [businessesByCity addObject:bObj];
                 }
                 }
                 self.businessList=businessesByCity;*/
                CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityTxtField.text];
                NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
                self.reverseGeoLocation=cloc;
                
                NSMutableArray *businessesByCity=[[NSMutableArray alloc] init];
                for(Business *bObj in arr)
                {
                    if([bObj.business_name.lowercaseString hasPrefix:self.searchBar.text])
                    {
                        [businessesByCity addObject:bObj];
                    }
                }
                self.businessList=businessesByCity;
                //self.businessList=arr;
            }
            else //by zipcode
                if([[InfoExpert sharedInstance] searchCriteria]==3)
                {
                    /*NSMutableArray *businessesByZipCode=[[[NSMutableArray alloc] init] autorelease];
                     for(Business *bObj in arr)
                     {
                     if([[bObj.pincode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:self.cityTxtField.text])
                     {
                     [businessesByZipCode addObject:bObj];
                     }
                     }
                     self.businessList=businessesByZipCode;*/
                    CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityTxtField.text];
                    NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                    CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                    arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
                    self.reverseGeoLocation=cloc;
                    
                    NSMutableArray *businessesByZipCode=[[NSMutableArray alloc] init];
                    for(Business *bObj in arr)
                    {
                        if([bObj.business_name.lowercaseString hasPrefix:self.searchBar.text])
                        {
                            [businessesByZipCode addObject:bObj];
                        }
                    }
                    self.businessList=businessesByZipCode;
                    
                    //self.businessList=arr;
                }
                else
                {
                    self.businessList=[[DatabaseManager sharedInstance] getBusinessesByName:self.businessName];
                }
        }
    }
    [self.businessListTableView reloadData];
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
        NSArray *arr;
        
        if(valid)
        {
            NSLog(@"%@",self.category);
            if(self.searchType==SEARCH_BY_NAME)
            {
                arr=[[DatabaseManager sharedInstance] getBusinessesByName:str];
            }
            else
            {
                //arr=[[DatabaseManager sharedInstance] getBusinessesByZipCodeAndCategory:str withCategory:self.category];
                CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityTxtField.text];
                NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
                self.reverseGeoLocation=cloc;
                self.searchFilterType=SEARCH_BY_ZIPCODE;
            }
            /*NSMutableArray *businessesByZipCode=[[[NSMutableArray alloc] init] autorelease];
             for(Business *bObj in arr)
             {
             if([[bObj.pincode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:str])
             {
             [businessesByZipCode addObject:bObj];
             }
             }
             self.businessList=businessesByZipCode;*/
            self.businessList=arr;
            
            [self.businessListTableView reloadData];
            [[InfoExpert sharedInstance] setSearchCriteria:3];
        }
        else
        {
            if(self.searchType==SEARCH_BY_NAME)
            {
                arr=[[DatabaseManager sharedInstance] getBusinessesByName:str];
            }
            else
            {
                //arr=[[DatabaseManager sharedInstance] getBusinessesByCityAndCategory:str withCategory:self.category];
                CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityTxtField.text];
                NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
                self.reverseGeoLocation=cloc;
                self.searchFilterType=SEARCH_BY_CITY;
            }
            /*NSMutableArray *businessesByCity=[[[NSMutableArray alloc] init] autorelease];
             for(Business *bObj in arr)
             {
             if([bObj.city.lowercaseString isEqualToString:str.lowercaseString])
             {
             [businessesByCity addObject:bObj];
             }
             }
             self.businessList=businessesByCity;*/
            self.businessList=arr;
            [self.businessListTableView reloadData];
            [[InfoExpert sharedInstance] setSearchCriteria:2];
        }
    }
    [self.businessListTableView reloadData];
    [textField resignFirstResponder];
    self.locateView.hidden=YES;
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
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
    if(prevLocation==nil && self.searchType!=SEARCH_BY_NAME)
    {
        if(self.searchFilterType==SEARCH_BY_NAME)
        {
            NSNumber *sMiles=[NSNumber numberWithDouble:[totalMilesTxtField.text doubleValue]];
            NSArray *arr;
            arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:self.currentLocation withMiles:sMiles withCategory:self.category];
            
            NSMutableArray *businessesByName=[[NSMutableArray alloc] init];
            for(Business *bObj in arr)
            {
                //if([bObj.business_name.lowercaseString isEqualToString:self.searchBar.text.lowercaseString])
                if([bObj.business_name.lowercaseString hasPrefix:self.searchBar.text.lowercaseString])
                {
                    [businessesByName addObject:bObj];
                }
            }
            self.businessList=businessesByName;
            currentBtnClicked=NO;
            
        }
        else
        {
            self.businessList=[[DatabaseManager sharedInstance] getBusinessesNearMe:self.currentLocation withMiles:sMiles withCategory:self.category];
        }
        [self.businessListTableView reloadData];
    }
    else
        if(self.searchType == SEARCH_BY_NAME)
        {
            NSArray *arr=[[DatabaseManager sharedInstance] getBusinessesByName:self.searchBar.text];
            arr=self.businessList=[[DatabaseManager sharedInstance] getBusinessesByCurrentLocation:arr withCurrentLocation:self.userLocation withMiles:sMiles];  
            self.businessList=arr;
            [self.businessListTableView reloadData];
        }
    
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self removePopup];
    [self.locationMgr stopUpdatingLocation];
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark -

- (IBAction)numberPadDoneButton:(id)sender {
    [[InfoExpert sharedInstance] setTotalMilesValue:[NSNumber numberWithDouble:[self.totalMilesTxtField.text doubleValue]]];
    UITextField *textField = [self findFirstResponderTextField];
    [textField resignFirstResponder];
    self.settingsView.hidden=YES;
    
    currentBtnClicked=YES;
    settingsView.hidden=YES;
    locateView.hidden=YES;
    [self.cityTxtField resignFirstResponder];
    //self.searchFilterType=SEARCH_BY_CURRENT_LOCATION;
    //[[InfoExpert sharedInstance] setSearchCriteria:1];
    NSNumber *sMiles=[NSNumber numberWithDouble:[totalMilesTxtField.text doubleValue]];
    if(self.currentLocation==nil && [[InfoExpert sharedInstance] searchCriteria]==1)
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
            currentBtnClicked=NO;
        }
        
    }
    else
    {
        if(self.searchType == SEARCH_BY_NAME)
        {
            self.businessList=[[DatabaseManager sharedInstance] getBusinessesByName:self.searchBar.text];
            [self.businessListTableView reloadData];
        }
        else
        {
            
            /*self.businessList=[[DatabaseManager sharedInstance] getBusinessesNearMe:self.currentLocation withMiles:sMiles withCategory:self.category];*/
            
            //by city
            if([[InfoExpert sharedInstance] searchCriteria]==2)
            {
                /*NSMutableArray *businessesByCity=[[[NSMutableArray alloc] init] autorelease];
                 for(Business *bObj in arr)
                 {
                 if([bObj.city.lowercaseString isEqualToString:self.cityTxtField.text.lowercaseString])
                 {
                 [businessesByCity addObject:bObj];
                 }
                 }
                 self.businessList=businessesByCity;*/
                CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityTxtField.text];
                NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                NSArray *arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
                self.reverseGeoLocation=cloc;
                
                /*NSMutableArray *businessesByCity=[[[NSMutableArray alloc] init] autorelease];
                 for(Business *bObj in arr)
                 {
                 if([bObj.business_name.lowercaseString hasPrefix:self.searchBar.text])
                 {
                 [businessesByCity addObject:bObj];
                 }
                 }
                 self.businessList=businessesByCity;*/
                self.businessList=arr;
            }
            else //by zipcode
                if([[InfoExpert sharedInstance] searchCriteria]==3)
                {
                    /*NSMutableArray *businessesByZipCode=[[[NSMutableArray alloc] init] autorelease];
                     for(Business *bObj in arr)
                     {
                     if([[bObj.pincode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:self.cityTxtField.text])
                     {
                     [businessesByZipCode addObject:bObj];
                     }
                     }
                     self.businessList=businessesByZipCode;*/
                    CLLocationCoordinate2D coords=[self geoCodeUsingAddress:self.cityTxtField.text];
                    NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
                    CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
                    NSArray *arr=[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[[InfoExpert sharedInstance]totalMilesValue] withCategory:self.category];
                    self.reverseGeoLocation=cloc;
                    
                    /*NSMutableArray *businessesByZipCode=[[[NSMutableArray alloc] init] autorelease];
                     for(Business *bObj in arr)
                     {
                     if([bObj.business_name.lowercaseString hasPrefix:self.searchBar.text])
                     {
                     [businessesByZipCode addObject:bObj];
                     }
                     }
                     self.businessList=businessesByZipCode;*/
                    
                    self.businessList=arr;
                }
                else
                {
                    //self.businessList=[[DatabaseManager sharedInstance] getBusinessesByName:self.businessName];
                    self.businessList=[[DatabaseManager sharedInstance] getBusinessesNearMe:self.currentLocation withMiles:sMiles withCategory:self.category];
                }
            
            [self.businessListTableView reloadData];
        }
    }
    
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
        [self.cityTxtField becomeFirstResponder];
        locateViewFlag=1;
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
    currentBtnClicked=YES;
    settingsView.hidden=YES;
    locateView.hidden=YES;
    self.cityTxtField.text=@"";
    [self.cityTxtField resignFirstResponder];
    self.searchFilterType=SEARCH_BY_CURRENT_LOCATION;
    [[InfoExpert sharedInstance] setSearchCriteria:1];
    NSNumber *sMiles=[NSNumber numberWithDouble:[totalMilesTxtField.text doubleValue]];
    if(self.currentLocation==nil && [[InfoExpert sharedInstance] searchCriteria]==1)
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
            currentBtnClicked=NO;
        }
        
    }
    else
    {
        if(self.searchType == SEARCH_BY_NAME)
        {
            self.businessList=[[DatabaseManager sharedInstance] getBusinessesByName:self.searchBar.text];
            [self.businessListTableView reloadData];
        }
        else
        {
            
            self.businessList=[[DatabaseManager sharedInstance] getBusinessesNearMe:self.currentLocation withMiles:sMiles withCategory:self.category];
            [self.businessListTableView reloadData];
        }
    }
    [self.businessListTableView reloadData];
}

#pragma mark -

- (void)goToPunchCardOfferView:(NSString *)offerQrCode punchCardDetails:(PunchCard *)punchCard
{
    Business *business;
    business=[businessList objectAtIndex:selectedIndex];
    
    PunchCardOfferViewController *punchCardOfferView = [[PunchCardOfferViewController alloc] init:business.business_name punchCardDetails:punchCard];
    [self.navigationController pushViewController:punchCardOfferView animated:YES];
}

#pragma mark -

- (IBAction)showMap:(id)sender {
    BOOL allBizsHaveCards = YES;
    shouldGoToPunchCardOfferPage = NO;
    NSMutableArray *cardArray = [[NSMutableArray alloc] init];
    for(Business *biz in businessList){
        if(biz.punchCard == nil){
            //At least one biz does not have it's punch card, load it from the internet, then this'll be called again
            allBizsHaveCards = NO;
            [networkManager getBusinessOffer:biz.business_name loggedInUserId:[[InfoExpert sharedInstance] userId]];
        }
        else {
            [cardArray addObject:biz.punchCard];
        }
    }
    
    /*for (id key in businessOfferDetails) {
        PunchCard *card = [businessOfferDetails objectForKey:key];
        card.business = [[DatabaseManager sharedInstance] getBusinessByBusinessId:card.business_id];
        [cardArray addObject:card];
    }*/
    if(allBizsHaveCards == YES){
        BusinessLocatorViewController *businessMapViewController = [[BusinessLocatorViewController alloc] init:cardArray];
        [self.navigationController pushViewController:businessMapViewController animated:YES];
    }
    else {
        //Skip, still need to load punch cards
    }
}

- (Business *)getBizWithName:(NSString *)name {
    for(Business *biz in businessList){
        if([biz.business_name isEqualToString:name]){
            return biz;
        }
    }
    return nil;
}

-(void) getBusinessOffer
{
    Business *business=[self.businessList objectAtIndex:selectedIndex];
    [networkManager getBusinessOffer:business.business_name loggedInUserId:[[InfoExpert sharedInstance]userId]];
}

-(void) showPopup
{
    /*activityIndicator = [[UIActivityIndicatorView alloc] init];
    activityIndicator.center = CGPointMake(160.0f, 240.0f);
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];*/
    
	/*NSArray *xibUIObjects =[[NSBundle mainBundle] loadNibNamed:@"NetworkActivity" owner:self options:nil];
	self.activity= [xibUIObjects objectAtIndex:0];
	[self.view addSubview:self.activity];*/
    [popupHUD show:YES];
}

-(void) removePopup
{
    // finished loading, hide the activity indicator in the status bar
    /*if([self.activity respondsToSelector:@selector(viewWithTag:)])
	{
        [self.activity removeFromSuperview];
    }*/
    
    /*[activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];*/
    [popupHUD hide:YES];
}

#pragma mark -

- (CLLocationCoordinate2D) geoCodeUsingAddress: (NSString *) address
{
    Zipcodes_Cache *zipCodeCache=[[DatabaseManager sharedInstance] getZipcodesCacheObject:address];
    if(zipCodeCache==nil)
    {
        [self showPopup];
        CLLocationCoordinate2D myLocation; 
        
        // -- modified from the stackoverflow page - we use the SBJson parser instead of the string scanner --
        
        NSString       *esc_addr = [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString            *req = [NSString stringWithFormat: @"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
        
        SBJsonParser *parser=[SBJsonParser new];
        NSDictionary *googleResponse=[parser objectWithString:[NSString stringWithContentsOfURL: [NSURL URLWithString: req] encoding: NSUTF8StringEncoding error: NULL]];
        
        //NSDictionary *googleResponse = [[NSString stringWithContentsOfURL: [NSURL URLWithString: req] encoding: NSUTF8StringEncoding error: NULL] JSONValue];
        
        NSDictionary    *resultsDict = [googleResponse valueForKey:  @"results"];   // get the results dictionary
        NSDictionary   *geometryDict = [   resultsDict valueForKey: @"geometry"];   // geometry dictionary within the  results dictionary
        NSDictionary   *locationDict = [  geometryDict valueForKey: @"location"];   // location dictionary within the geometry dictionary
        
        // -- you should be able to strip the latitude & longitude from google's location information (while understanding what the json parser returns) --
        
        //DLog (@"-- returning latitude & longitude from google --");
        
        NSArray *latArray = [locationDict valueForKey: @"lat"]; NSString *latString = [latArray lastObject];     // (one element) array entries provided by the json parser
        NSArray *lngArray = [locationDict valueForKey: @"lng"]; NSString *lngString = [lngArray lastObject];     // (one element) array entries provided by the json parser
        
        myLocation.latitude = [latString doubleValue];     // the json parser uses NSArrays which don't support "doubleValue"
        myLocation.longitude = [lngString doubleValue];
        
        [self removePopup];
        if(myLocation.latitude==0)
        {
            
        }
        else
        {
            if([address isEqualToString:@""])
            {
            }
            else
            {
                Zipcodes_Cache *zipcode=[[DatabaseManager sharedInstance] getZipcodes_CacheObject];
                [zipcode setValue:[NSNumber numberWithDouble:myLocation.latitude] forKey:@"latitude"];
                [zipcode setValue:[NSNumber numberWithDouble:myLocation.longitude] forKey:@"longitude"];
                [zipcode setValue:address forKey:@"zip_code"];
                [[DatabaseManager sharedInstance] saveEntity:nil];
            }
        }
        return myLocation;
    }
    else
    {
        CLLocationCoordinate2D myLocation; 
        myLocation.latitude=[zipCodeCache.latitude doubleValue];
        myLocation.longitude=[zipCodeCache.longitude doubleValue];
        return myLocation;
    }
}


@end

//
//  SearchPageViewController.m
//  paidPunch
//
//  Created by Alexander on 7/27/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize searchTable, noBusinessesErrorImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)viewDidLoad
{
    //Initialize the array.
    listOfRanges = [[NSMutableArray alloc] init];
    
    businessOfferDetails = [[NSMutableDictionary alloc] init];
        
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    //Network Manager for loading the business list
    networkManagerBusinessList=[[NetworkManager alloc] initWithView:self.view];
    networkManagerBusinessList.delegate=self;
    
    //Network Manager for loading the business offers
    networkManagerBusinessOfferDict = [[NSMutableDictionary alloc] init];
    
    userZipCode = [[NSMutableString alloc] initWithString:@""];
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    if ([ud objectForKey:@"userZipCode"] != nil) {
        [userZipCode setString:[ud objectForKey:@"userZipCode"]];
    }
    else {
        [userZipCode setString:@""];
    }
    
    currentLocation = [[CLLocation alloc] init];
    
    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.delegate = self;
    locationMgr.desiredAccuracy = kCLLocationAccuracyBest; 
    locationMgr.distanceFilter = kCLDistanceFilterNone;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        [locationMgr startUpdatingLocation];
    }
    
    //[[InfoExpert sharedInstance] setSearchCriteria:1];
    
    if (_refreshHeaderView == nil) {
		
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.searchTable.bounds.size.height, self.view.frame.size.width, self.searchTable.bounds.size.height) isForSearchView:kEGOType_SearchView];
		view.delegate = self;
		[searchTable addSubview:view];
		_refreshHeaderView = view;
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self loadBusinessList];
    [self refreshBusinessList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSLog(@"Will Appear");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)appWillBecomeActive {
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        [locationMgr startUpdatingLocation];
    }
}

#pragma mark - Network Manager delegate

- (void) didFinishLoadingBusinessOffer:(NSString *)statusCode statusMessage:(NSString *)message punchCardDetails:(PunchCard*)punchCard {
    if ([statusCode rangeOfString:@"00"].location == NSNotFound || punchCard == nil) {
        //Bad bug
        NSLog(@"$$Loading Biz Offer: Error: %@", message);
    }
    else {
        NSLog(@"$$Loading Biz offer: Successfuly; Biz Name: %@'", punchCard.business_name);
        [businessOfferDetails setValue:punchCard forKey:punchCard.business_name];
        [searchTable reloadData];
    }
}

- (void)didFinishSearchByName:(NSString *)statusCode {
    if ([statusCode rangeOfString:@"00"].location == NSNotFound) {
        
    }
    else {
        [self refreshBusinessList];
    }
}

- (void)didConnectionFailed:(NSString *)responseStatus {
    NSLog(@"$$Network Connection did fail: %@", responseStatus);
}

#pragma mark - View functions

- (IBAction)showLocationSelector:(id)sender {
    UIAlertView *locationAlertView = [[UIAlertView alloc] initWithTitle:@"Enter your zip code."
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Current location"
                                                      otherButtonTitles:@"Okay", nil];
    [locationAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[locationAlertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[locationAlertView textFieldAtIndex:0] setKeyboardAppearance:UIKeyboardAppearanceDefault];
    [[locationAlertView textFieldAtIndex:0] setText:userZipCode];
    [locationAlertView show];
}

- (IBAction)showMap:(id)sender {
    NSMutableArray *cardArray = [[NSMutableArray alloc] init];
    for (id key in businessOfferDetails) {
        PunchCard *card = [businessOfferDetails objectForKey:key];
        card.business = [[DatabaseManager sharedInstance] getBusinessByBusinessId:card.business_id];
        [cardArray addObject:card];
    }
    BusinessLocatorViewController *businessMapViewController = [[BusinessLocatorViewController alloc] init:cardArray];
    [self.navigationController pushViewController:businessMapViewController animated:YES];
}

#pragma mark - Alertview Delegate methods

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if([inputText length] >= 5){
        return YES;
    }
    else {
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                NSLog(@"**reverseGeocodeLocation:completionHandler: Completion Handler called!");
                
                if (error){
                    NSLog(@"**Geocode failed with error: %@", error);
                    return;
                    
                }
                
                if(placemarks && placemarks.count > 0)
                    
                {
                    //do something
                    CLPlacemark *topResult = [placemarks objectAtIndex:0];
                    NSLog(@"**Geocode successful; zip code: %@", [topResult postalCode]);
                    [userZipCode setString:[topResult postalCode]];
                    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                    [ud setObject:userZipCode forKey:@"userZipCode"];
                    [ud synchronize];
                    [self refreshBusinessList];
                }
            }];
        }
        else {
            [locationMgr stopUpdatingLocation];
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    }
    else if(buttonIndex == 1) {
        [userZipCode setString:[[alertView textFieldAtIndex:0] text]];
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        [ud setObject:userZipCode forKey:@"userZipCode"];
        [ud synchronize];
        [self refreshBusinessList];
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods Implementation

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationMgr stopUpdatingLocation];
    currentLocation = newLocation;
    
    //Use the location to get a zipcode
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"**reverseGeocodeLocation:completionHandler: Completion Handler called!");
        
        if (error){
            NSLog(@"**Geocode failed with error: %@", error);
            return;
            
        }
        
        if(placemarks && placemarks.count > 0)
            
        {
            //do something
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            NSLog(@"**Geocode successful; zip code: %@", [topResult postalCode]);
            if ([userZipCode isEqualToString:@""]) {
                [userZipCode setString:[topResult postalCode]];
                NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                [ud setObject:userZipCode forKey:@"userZipCode"];
                [ud synchronize];
                [self refreshBusinessList];
            }
        }
    }];
    NSLog(@"**location manager did update");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*[locationMgr stopUpdatingLocation];
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];*/
}

#pragma mark -

- (CLLocationCoordinate2D) geoCodeUsingAddress: (NSString *) address
{
    Zipcodes_Cache *zipCodeCache=[[DatabaseManager sharedInstance] getZipcodesCacheObject:address];
    if(zipCodeCache==nil)
    {
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

#pragma mark -

-(void) loadBusinessList
{
    [networkManagerBusinessList searchByName:@"" loggedInUserId:[[User getInstance] userId]];
}

- (void)refreshBusinessList {
    //Get businesses    
    CLLocationCoordinate2D coords = [self geoCodeUsingAddress:userZipCode];
    NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
    CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
    NSMutableArray *bizArray = (NSMutableArray *)[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[NSNumber numberWithInt:20] withCategory:@"eat"];
    [bizArray addObjectsFromArray:[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[NSNumber numberWithInt:20] withCategory:@"drink"]];
    [bizArray addObjectsFromArray:[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[NSNumber numberWithInt:20] withCategory:@"play"]];
    [bizArray addObjectsFromArray:[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[NSNumber numberWithInt:20] withCategory:@"relax"]];
    [bizArray addObjectsFromArray:[[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[NSNumber numberWithInt:20] withCategory:@"essentials"]];
    businessList = (NSArray *)bizArray;
    
    //Sort by diff_in_miles
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"diff_in_miles" ascending:YES]];
    businessList = [businessList sortedArrayUsingDescriptors:dateSortDescriptors];
    
    //Separate businesses in different miles: 1,2,5,10,15,20
    NSMutableArray *diffOneMile = [NSMutableArray array];
    NSMutableArray *diffTwoMiles = [NSMutableArray array];
    NSMutableArray *diffFiveMiles = [NSMutableArray array];
    NSMutableArray *diffTenMiles = [NSMutableArray array];
    NSMutableArray *diffFifteenMiles = [NSMutableArray array];
    NSMutableArray *diffTwentyMiles = [NSMutableArray array];
    
    for(Business *bizObj in businessList){
        if (bizObj.punchCard == nil) {
            if([networkManagerBusinessOfferDict objectForKey:bizObj.business_name] == nil){
                NetworkManager *tempNetManager = [[NetworkManager alloc] initWithView:self.view];
                tempNetManager.delegate = self;
                [tempNetManager getBusinessOffer:bizObj.business_name loggedInUserId:[[User getInstance] userId]];
                [networkManagerBusinessOfferDict setObject:tempNetManager forKey:bizObj.business_name];
//                [[networkManagerBusinessOfferDict objectForKey:bizObj.business_name] getBusinessOffer:bizObj.business_name loggedInUserId:[[InfoExpert sharedInstance] userId]];
            }
            else {
                [[networkManagerBusinessOfferDict objectForKey:bizObj.business_name] getBusinessOffer:bizObj.business_name loggedInUserId:[[User getInstance] userId]];
            }
//            [networkManagerBusinessOffer getBusinessOffer:bizObj.business_name loggedInUserId:[[InfoExpert sharedInstance]userId]];
        }
        else {
            [businessOfferDetails setValue:bizObj.punchCard forKey:bizObj.punchCard.business_name];
        }
        
        if([bizObj.diff_in_miles floatValue] < 1.1){
            [diffOneMile addObject:bizObj];
        }
        else if([bizObj.diff_in_miles floatValue] < 2.1){
            [diffTwoMiles addObject:bizObj];
        }
        else if([bizObj.diff_in_miles floatValue] < 5.1){
            [diffFiveMiles addObject:bizObj];
        }
        else if([bizObj.diff_in_miles floatValue] < 10.1){
            [diffTenMiles addObject:bizObj];
        }
        else if([bizObj.diff_in_miles floatValue] < 15.1){
            [diffFifteenMiles addObject:bizObj];
        }
        else if([bizObj.diff_in_miles floatValue] < 20.1){
            [diffTwentyMiles addObject:bizObj];
        }
        else {
            
        }
    }
    
    //Put them in our main array
    [listOfRanges removeAllObjects];
    
    if ([diffOneMile count] > 0) [listOfRanges addObject:diffOneMile];
    if ([diffTwoMiles count] > 0) [listOfRanges addObject:diffTwoMiles];
    if ([diffFiveMiles count] > 0) [listOfRanges addObject:diffFiveMiles];
    if ([diffTenMiles count] > 0) [listOfRanges addObject:diffTenMiles];
    if ([diffTwentyMiles count] > 0) [listOfRanges addObject:diffTwentyMiles];
    
    if (listOfRanges.count > 0) {
        searchTable.hidden = NO;
        noBusinessesErrorImage.hidden = YES;
        [searchTable reloadData];
    }
    else {
        noBusinessesErrorImage.hidden = NO;
        searchTable.hidden = YES;
    }
}

- (void)goToPunchCardOfferView:(NSString *)offerQrCode punchCardDetails:(PunchCard *)punchCard selectedIndex:(NSIndexPath *)index {
    Business *business;
    business = [[listOfRanges objectAtIndex:index.section] objectAtIndex:index.row];
    
    PunchCardOfferViewController *punchCardOfferView = [[PunchCardOfferViewController alloc] init:business.business_name punchCardDetails:punchCard];
    [self.navigationController pushViewController:punchCardOfferView animated:YES];
}

#pragma mark Table view methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 20)];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.0 green:190.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, tableView.bounds.size.width, 20)];
    NSString *labelText = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    [headerLabel setText:labelText];
    [headerLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listOfRanges count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[listOfRanges objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
      
    //Get the first business of a range, as none will be empty this is safe
    Business *businessObject = [[listOfRanges objectAtIndex:section] objectAtIndex:0];
    float diff = [[businessObject diff_in_miles] floatValue];
    if(diff > 0 && diff <= 1.1) return @"Within 1 Mile";
    else if(diff > 1.1 && diff <= 2.1) return @"Within 2 Miles";
    else if(diff > 2.1 && diff <= 5.1) return @"Within 5 Miles";
    else if(diff > 5.1 && diff <= 10.1) return @"Within 10 Miles";
    else if(diff > 10.1 && diff <= 15.1) return @"Within 15 Miles";
    else if(diff > 15.1 && diff <= 20.1) return @"Within 20 Miles";
    else return @"Error";    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    for(UIView *eachView in [cell subviews]) {
        if (eachView.tag > 100) {
            [eachView removeFromSuperview];
        }
    }
    
    //Initialize Label
    /*UILabel *businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, cell.bounds.size.width - 85, cell.bounds.size.height - 2)];
    [businessLabel setFont:[UIFont systemFontOfSize:17.0]];
    [businessLabel setTextColor:[UIColor blackColor]];
    Business *business = [[[listOfRanges objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] retain];
    NSString *cellValue = business.business_name;
    businessLabel.text = cellValue;
    businessLabel.tag = 101;
    [cell addSubview:businessLabel];
    [businessLabel release];*/
    
    MarqueeLabel *businessLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(5.0, 0.0, cell.bounds.size.width - 95, cell.bounds.size.height - 2) rate:20.0f andFadeLength:10.0f];
    [businessLabel setFont:[UIFont systemFontOfSize:17.0]];
    [businessLabel setTextColor:[UIColor blackColor]];
    Business *business = [[listOfRanges objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *cellValue = business.business_name;
    businessLabel.text = cellValue;
    businessLabel.tag = 101;
    [cell addSubview:businessLabel];
    
    UILabel *savingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5.0, 0.0, cell.bounds.size.width, cell.bounds.size.height - 2)];
    [savingsLabel setTextAlignment:UITextAlignmentRight];
    [savingsLabel setBackgroundColor:[UIColor clearColor]];
    [savingsLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [savingsLabel setTextColor:[UIColor colorWithRed:0.0 green:157.0/255.0 blue:3.0/255.0 alpha:1.0]];
//    float savings = [[[businessOfferDetails objectForKey:business.business_name] actual_price] floatValue] - [[[businessOfferDetails objectForKey:business.business_name] selling_price] floatValue];
    float savings = [[[businessOfferDetails objectForKey:business.business_name] actual_price] floatValue] - [[[businessOfferDetails objectForKey:business.business_name] selling_price] floatValue];
    savingsLabel.text = [NSString stringWithFormat:@"$%.2f off", savings];
    savingsLabel.tag = 102;
    if (savings > 0.0) {
        [cell addSubview:savingsLabel];
    }
    else {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicator startAnimating];
        [activityIndicator setCenter:CGPointMake(cell.bounds.size.width - 20, 22)];
        activityIndicator.tag = 103;
        [cell addSubview:activityIndicator];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *businessName = [[[listOfRanges objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] business_name];
//    [self goToPunchCardOfferView:businessName punchCardDetails:[businessOfferDetails objectForKey:businessName] selectedIndex:indexPath];
    [self goToPunchCardOfferView:[[businessOfferDetails objectForKey:businessName] business_name] punchCardDetails:[businessOfferDetails objectForKey:businessName] selectedIndex:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*NSString *businessName = [[[listOfRanges objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] business_name];
    PunchUsedViewController *punchView = [[PunchUsedViewController alloc] init:[businessOfferDetails objectForKey:businessName] barcodeImageData:nil barcodeValue:@"Free soft drink with purchase"];
    punchView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:punchView animated:YES];
    [punchView release];*/
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark -
#pragma mark EGORefreshTableHeaderView Delegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	//EGO tells us that it has been pulled
    SearchByCategoryViewController *searchByCategoryController = [[SearchByCategoryViewController alloc] init];
    [self.navigationController pushViewController:searchByCategoryController animated:YES];
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
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

@synthesize searchTable;

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
        
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    userZipCode = @"92101";
    
    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.delegate = self;
    locationMgr.desiredAccuracy = kCLLocationAccuracyBest; 
    locationMgr.distanceFilter = kCLDistanceFilterNone;
    [locationMgr startUpdatingLocation];
    
    [[InfoExpert sharedInstance] setSearchCriteria:1];
    
    [self refreshBusinessList];
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

#pragma mark - Network Manager delegate

-(void) didFinishLoadingBusinessOffer:(NSString *)statusCode statusMessage:(NSString *)message punchCardDetails:(PunchCard*)punchCard {
    
}

#pragma mark - View functions

- (IBAction)showLocationSelector:(id)sender {
    UIAlertView *locationAlertView = [[UIAlertView alloc] initWithTitle:@"Enter your zip code."
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Okay", nil];
    [locationAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[locationAlertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[locationAlertView textFieldAtIndex:0] setKeyboardAppearance:UIKeyboardAppearanceDefault];
    [[locationAlertView textFieldAtIndex:0] setText:userZipCode];
    [locationAlertView show];
}

- (IBAction)showMap:(id)sender {
    
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
    if (buttonIndex == 1) {
        userZipCode = [[alertView textFieldAtIndex:0] text];
        [[InfoExpert sharedInstance] setZipcode:userZipCode];
        [self refreshBusinessList];
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods Implementation

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationMgr stopUpdatingLocation];
    currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationMgr stopUpdatingLocation];
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release]; 
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
        
        [parser release];
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
    
}

- (void)refreshBusinessList {
    //Get businesses    
    CLLocationCoordinate2D coords = [self geoCodeUsingAddress:userZipCode];
    NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
    CLLocation *cloc = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
    businessList = [[DatabaseManager sharedInstance] getBusinessesNearMe:cloc withMiles:[NSNumber numberWithInt:20] withCategory:@"eat"];
    
    //Sort by diff_in_miles
    NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"diff_in_miles" ascending:YES]];
    businessList = [businessList sortedArrayUsingDescriptors:dateSortDescriptors];
    [cloc release];
    
    //Separate businesses in different miles: 1,2,5,10,15,20
    NSMutableArray *diffOneMile = [NSMutableArray array];
    NSMutableArray *diffTwoMiles = [NSMutableArray array];
    NSMutableArray *diffFiveMiles = [NSMutableArray array];
    NSMutableArray *diffTenMiles = [NSMutableArray array];
    NSMutableArray *diffFifteenMiles = [NSMutableArray array];
    NSMutableArray *diffTwentyMiles = [NSMutableArray array];
    
    for(Business *bizObj in businessList){
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
    
    [searchTable reloadData];
}

#pragma mark Table view methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 20)] autorelease];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.0 green:190.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, tableView.bounds.size.width, 20)] autorelease];
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
    else if(diff > 20.1 && diff <= 20.1) return @"Within 20 Miles";
    else return @"Error";    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    for(UIView *eachView in [cell subviews]) {
        if (eachView.tag > 100) {
            [eachView removeFromSuperview];
        }
    }
    
    //Initialize Label
    UILabel *businessLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, cell.bounds.size.width, cell.bounds.size.height - 2)];
    [businessLabel setFont:[UIFont systemFontOfSize:17.0]];
    [businessLabel setTextColor:[UIColor blackColor]];
    Business *business = [[[listOfRanges objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] retain];
    NSString *cellValue = business.business_name;
    businessLabel.text = cellValue;
    businessLabel.tag = 101;
    [cell addSubview:businessLabel];
    [businessLabel release];
    
    UILabel *savingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 75, 0.0, cell.bounds.size.width, cell.bounds.size.height - 2)];
    [savingsLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [savingsLabel setTextColor:[UIColor colorWithRed:0.0 green:157.0/255.0 blue:3.0/255.0 alpha:1.0]];
    //savingsLabel.text = @"$1.99 off";
    
    savingsLabel.text = [NSString stringWithFormat:@"%f", [business.diff_in_miles floatValue]];
    
    savingsLabel.tag = 102;
    [cell addSubview:savingsLabel];
    [savingsLabel release];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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


@end
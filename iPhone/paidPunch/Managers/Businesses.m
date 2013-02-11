//
//  Businesses.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/8/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "AFClientManager.h"
#import "AFHTTPRequestOperation.h"
#import "Businesses.h"
#import "Utilities.h"

#define kOneMileMeters 1609.344
#define kMaxMiles 20

static NSString* const kKeyVersion = @"version";
static NSString* const kKeyLastUpdate = @"lastUpdate";
static NSString* const kKeyStatusMessage = @"statusMessage";
static NSString* const kKeyBusinesses = @"businesses";
static NSString* const kBusinessesFilename = @"businesses.sav";

// 1 hour refresh schedule
static double const refreshTime = -(60 * 60);

@implementation Businesses

- (id) init
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _lastUpdate = nil;
        
        // Initializing punch cards retrieval
        _networkManager=[[NetworkManager alloc] init];
        _networkManager.delegate=self;
        
        _businessesDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)retrieveBusinessesFromServer:(NSObject<HttpCallbackDelegate>*)delegate
{
    _businessesDelegate = delegate;
    [_networkManager searchByName:@"" loggedInUserId:[[User getInstance] userId]];
}

- (NSArray*) getBusinessesCloseby:(CLLocation*)location
{
    //TODO: Remove these lines
    CLLocationCoordinate2D coords = [self geoCodeUsingAddress:@"98053"];
    NSLog(@"Reverse %f %f",coords.latitude,coords.longitude);
    location = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
    
    NSNumber* maxDistance = [NSNumber numberWithInt:kMaxMiles];
    
    NSMutableArray* bizArray = [[NSMutableArray alloc] init];
    for (id bizId in _businessesDict)
    {
        BusinessOffers* current = [_businessesDict objectForKey:bizId];
        Business* currentBiz = [current business];
        
        CLLocation *bizLocation = [[CLLocation alloc] initWithLatitude:[currentBiz.latitude doubleValue] longitude:[currentBiz.longitude doubleValue]];
        
        CLLocationDistance meters = [location distanceFromLocation:bizLocation];
        NSLog(@"Distance in metres: %f", meters);
        double distanceInMiles = meters/kOneMileMeters;
        NSLog(@"%@ Distance in miles: %f", currentBiz.business_name , distanceInMiles);
        [current setDiff_in_miles:[NSNumber numberWithDouble:distanceInMiles]];
        if (distanceInMiles < [maxDistance doubleValue])
        {
            [bizArray addObject:current];
        }
    }
    
    //Sort by diff_in_miles
    NSArray *dateSortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"diff_in_miles" ascending:YES]];
    
    return [bizArray sortedArrayUsingDescriptors:dateSortDescriptors];;
}

- (BusinessOffers*)getBusinessOffersById:(NSString*)business_id
{
    return [_businessesDict objectForKey:business_id];
}

- (BOOL) needsRefresh
{
    return (!_lastUpdate) || ([_lastUpdate timeIntervalSinceNow] < refreshTime);
}

- (void) forceRefresh
{
    _lastUpdate = nil;
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_lastUpdate forKey:kKeyLastUpdate];
    [aCoder encodeObject:_businessesDict forKey:kKeyBusinesses];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
    _lastUpdate = [aDecoder decodeObjectForKey:kKeyLastUpdate];
    _businessesDict = [aDecoder decodeObjectForKey:kKeyBusinesses];
    return self;
}

#pragma mark - private functions

+ (NSString*) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*) businessesFilepath
{
    NSString* docsDir = [Businesses documentsDirectory];
    NSString* filepath = [docsDir stringByAppendingPathComponent:kBusinessesFilename];
    return filepath;
}

#pragma mark - saved game data loading and unloading
+ (Businesses*) loadBusinessesData
{
    Businesses* current_businesses = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [Businesses businessesFilepath];
    if ([fileManager fileExistsAtPath:filepath])
    {
        NSData* readData = [NSData dataWithContentsOfFile:filepath];
        if(readData)
        {
            current_businesses = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        }
    }
    return current_businesses;
}

- (void) saveBusinessesData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSError* error = nil;
    BOOL writeSuccess = [data writeToFile:[Businesses businessesFilepath]
                                  options:NSDataWritingAtomic
                                    error:&error];
    if(writeSuccess)
    {
        NSLog(@"businesses file saved successfully");
    }
    else
    {
        NSLog(@"businesses file save failed: %@", error);
    }
}

- (void) removeBusinessesData
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [Businesses businessesFilepath];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:filepath])
    {
        [fileManager removeItemAtPath:filepath error:&error];
    }
}

#pragma mark - network manager delegate
- (void)didFinishSearchByName:(NSString *)statusCode
{
    if ([statusCode rangeOfString:@"00"].location == NSNotFound)
    {
        NSLog(@"SearchByName received a failure from the server: %@", statusCode);
        [_businessesDelegate didCompleteHttpCallback:kKeyBusinessesRetrieval success:FALSE message:@"Failed to retrieve list of businesses from the server"];
    }
    else
    {
        NSArray* bizArray = [[DatabaseManager sharedInstance] getAllBusinesses];
        for (Business* current in bizArray)
        {
            BusinessOffers* currentBiz = [[BusinessOffers alloc] initWithBusiness:current];
            [_businessesDict setObject:currentBiz forKey:[current business_id]];
        }
        [_businessesDelegate didCompleteHttpCallback:kKeyBusinessesRetrieval success:TRUE message:@"Businesses retrieved"];
    }
}

#pragma mark - testing function
// For testing purposes

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

#pragma mark - Singleton
static Businesses* singleton = nil;
+ (Businesses*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            // First, try to load the punches data from disk
            // TODO: Someday, we'll actually do this right
            //singleton = [Businesses loadBusinessesData];
            if (!singleton)
            {
                // OK, no saved data available. Go ahead and create a new User.
                singleton = [[Businesses alloc] init];
            }
		}
	}
	return singleton;
}

+ (void) destroyInstance
{
	@synchronized(self)
	{
		singleton = nil;
	}
}

@end

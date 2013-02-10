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
#import "BusinessOffers.h"
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
        [currentBiz setDiff_in_miles:[NSNumber numberWithDouble:distanceInMiles]];
        if (distanceInMiles < [maxDistance doubleValue])
        {
            [bizArray addObject:current];
        }
    }
    return bizArray;
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

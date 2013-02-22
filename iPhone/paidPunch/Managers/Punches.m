//
//  Punches.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/15/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "AFClientManager.h"
#import "AFHTTPRequestOperation.h"
#import "Punches.h"
#import "User.h"
#import "Utilities.h"

static NSString* const kKeyVersion = @"version";
static NSString* const kKeyLastUpdate = @"lastUpdate";
static NSString* const kKeyUserId = @"user_id";
static NSString* const kKeyPunchId = @"punchcardid";
static NSString* const kKeyPunches = @"punches";
static NSString* const kKeyStatusMessage = @"statusMessage";
static NSString* const kKeyUniqueId = @"sessionid";
static NSString* const kPunchesFilename = @"punches.sav";

// 1 hour refresh schedule
static double const refreshTime = -(60 * 60);

@implementation Punches
@synthesize lastUpdate = _lastUpdate;
@synthesize validPunchesArray = _validPunchesArray;

- (id) init
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _lastUpdate = nil;
        _punchesArray = nil;
        
        // Initializing punch cards retrieval
        _networkManager=[[NetworkManager alloc] init];
        _networkManager.delegate=self;
    }
    return self;
}

-(void)retrievePunchesFromServer:(NSObject<HttpCallbackDelegate>*)delegate
{
    _mypunchesDelegate = delegate;
    [_networkManager getUserPunches:[[User getInstance] userId]];
}

- (void) purchasePunchWithCredit:(NSObject<HttpCallbackDelegate>*)delegate punchid:(NSString*)punchid
{
    // post parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                punchid, kKeyPunchId,
                                [[User getInstance] userId], kKeyUserId,
                                [[User getInstance] uniqueId], kKeyUniqueId,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    NSString* path = @"Punches";
    [httpClient postPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"%@", responseObject);
                     _lastUpdate = nil;
                     [delegate didCompleteHttpCallback:kKeyPunchesPurchase success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                 }
                 failure:^(AFHTTPRequestOperation* operation, NSError* error){
                     NSLog(@"Punch purchase failed with code: %d", [operation.response statusCode]);
                     [delegate didCompleteHttpCallback:kKeyPunchesPurchase success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                 }
     ];
}

- (BOOL) needsRefresh
{
    return (!_lastUpdate) || ([_lastUpdate timeIntervalSinceNow] < refreshTime);
}

- (void) forceRefresh
{
    _lastUpdate = nil;
}

- (void) getAvailablePunches
{
    _validPunchesArray = [[NSMutableArray alloc] init];
    for (PunchCard* current in _punchesArray)
    {
        NSLog(@"Current punch: %@, total punches: %d, used punches: %d", [current business_name], [[current total_punches] intValue], [[current total_punches_used] intValue]);
        if ([[current total_punches] intValue] > [[current total_punches_used] intValue])
        {
            [_validPunchesArray addObject:current];
        }
    }
}

- (PunchCard*) getPunchcardByBusinessId:(NSString*)business_id
{
    for (PunchCard* current in _punchesArray)
    {
        if ([business_id compare:[current business_id]] == NSOrderedSame)
        {
            return current;
        }
    }
    return nil;
}

#pragma mark - private functions

- (void)replaceCardInfo:(PunchCard*)newPunch
{
    NSUInteger index = 0;
    while (index < [_punchesArray count])
    {
        PunchCard* current = [_punchesArray objectAtIndex:index];
        if ([[current punch_card_id] compare:[newPunch punch_card_id]] == NSOrderedSame)
        {
            [current setRedeem_time_diff:[newPunch redeem_time_diff]];
            [current setMinimum_value:[newPunch minimum_value]];
            [current setExpire_days:[newPunch expire_days]];
            [current setCode:[newPunch code]];
        }
        index++;
    }
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_lastUpdate forKey:kKeyLastUpdate];
    [aCoder encodeObject:_punchesArray forKey:kKeyPunches];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
    _lastUpdate = [aDecoder decodeObjectForKey:kKeyLastUpdate];
    _punchesArray = [aDecoder decodeObjectForKey:kKeyPunches];
    return self;
}

#pragma mark - private functions

+ (NSString*) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*) punchesFilepath
{
    NSString* docsDir = [Punches documentsDirectory];
    NSString* filepath = [docsDir stringByAppendingPathComponent:kPunchesFilename];
    return filepath;
}

#pragma mark - saved game data loading and unloading
+ (Punches*) loadPunchesData
{
    Punches* current_punches = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [Punches punchesFilepath];
    if ([fileManager fileExistsAtPath:filepath])
    {
        NSData* readData = [NSData dataWithContentsOfFile:filepath];
        if(readData)
        {
            current_punches = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        }
    }
    return current_punches;
}

- (void) savePunchesData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSError* error = nil;
    BOOL writeSuccess = [data writeToFile:[Punches punchesFilepath]
                                  options:NSDataWritingAtomic
                                    error:&error];
    if(writeSuccess)
    {
        NSLog(@"punches file saved successfully");
    }
    else
    {
        NSLog(@"punches file save failed: %@", error);
    }
}

- (void) removePunchesData
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [Punches punchesFilepath];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:filepath])
    {
        [fileManager removeItemAtPath:filepath error:&error];
    }
}

#pragma mark - network manager delegate
-(void) didFinishGetUsersPunch:(NSString*)statusCode
{
    [[DatabaseManager sharedInstance] saveEntity:nil];
    _punchesArray = [NSMutableArray arrayWithArray:[[DatabaseManager sharedInstance] fetchPunchCards]];
    _numPunches = 0;
    if ([_punchesArray count] > 0)
    {
        for (PunchCard* punchcard in _punchesArray)
        {
            NSLog(@"Requesting additional data for punchcard: %@", [punchcard business_name]);
            [_networkManager getBusinessOffer:[punchcard business_name] loggedInUserId:[[User getInstance] userId]];
        }
    }
    else
    {
        [_mypunchesDelegate didCompleteHttpCallback:kKeyPunchesPurchase success:TRUE message:@"No punches for current user"];
    }
}

- (void) didFinishLoadingBusinessOffer:(NSString *)statusCode statusMessage:(NSString *)message punchCardDetails:(PunchCard*)punchCard
{
    if ([statusCode rangeOfString:@"00"].location == NSNotFound || punchCard == nil)
    {
        // Some failure occurred
        NSLog(@"Loading Biz Offer: Error: %@", message);
        [_mypunchesDelegate didCompleteHttpCallback:kKeyPunchesRetrieve success:FALSE message:message];
    }
    else
    {
        NSLog(@"Retrieved additional data for %@ with expire time: %@", [punchCard business_name], [punchCard redeem_time_diff]);
        _numPunches++;
        [self replaceCardInfo:punchCard];
        if (_numPunches == [_punchesArray count])
        {
            NSLog(@"All punches retrieved");
            _lastUpdate = [NSDate date];
            [self getAvailablePunches];
            [_mypunchesDelegate didCompleteHttpCallback:kKeyPunchesPurchase success:TRUE message:message];
        }
    }
}

#pragma mark - Singleton
static Punches* singleton = nil;
+ (Punches*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            // First, try to load the punches data from disk
            // TODO: Someday, we'll actually do this right
            //singleton = [Punches loadPunchesData];
            if (!singleton)
            {
                // OK, no saved data available. Go ahead and create a new User.
                singleton = [[Punches alloc] init];
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

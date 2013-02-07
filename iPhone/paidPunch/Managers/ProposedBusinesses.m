//
//  ProposedBusinesses.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/26/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "AFClientManager.h"
#import "ProposedBusiness.h"
#import "ProposedBusinesses.h"
#import "User.h"
#import "Utilities.h"

static NSString* const kKeyVersion = @"version";
static NSString* const kKeyUserId = @"user_id";
static NSString* const kKeyLastUpdate = @"lastUpdate";
static NSString* const kKeyProposedBusinesses = @"proposedBusinesses";
static NSString* const kKeyVotedBusinesses = @"votedBusinesses";
static NSString* const kKeyBusinessName = @"business_name";
static NSString* const kKeyBusinessInfo = @"business_info";
static NSString* const kKeyStatusMessage = @"statusMessage";
static NSString* const kProposedBusinessesFilename = @"proposedbusinesses.sav";

// 24 hour refresh schedule
static double const refreshTime = -(24 * 60 * 60);

@implementation ProposedBusinesses
@synthesize proposedBusinessesArray = _proposedBusinessesArray;
@synthesize lastUpdate = _lastUpdate;

- (id) init
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _lastUpdate = NULL;
        _proposedBusinessesArray = [[NSMutableArray alloc] init];
        _votedBusinesses = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_lastUpdate forKey:kKeyLastUpdate];
    [aCoder encodeObject:_proposedBusinessesArray forKey:kKeyProposedBusinesses];
    [aCoder encodeObject:_votedBusinesses forKey:kKeyVotedBusinesses];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
    _lastUpdate = [aDecoder decodeObjectForKey:kKeyLastUpdate];
    _proposedBusinessesArray = [aDecoder decodeObjectForKey:kKeyProposedBusinesses];
    _votedBusinesses = [aDecoder decodeObjectForKey:kKeyVotedBusinesses];
    return self;
}

#pragma mark - public functions

- (BOOL) alreadyVoted:(NSString*)businessId
{
    return ([_votedBusinesses objectForKey:businessId] != nil);
}

- (void) recordVote:(NSString*)businessId
{
    [_votedBusinesses setObject:[NSDate date] forKey:businessId];
    [self saveProposedBusinessesData];
}

#pragma mark - private functions

+ (NSString*) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*) proposedBusinessesFilepath
{
    NSString* docsDir = [ProposedBusinesses documentsDirectory];
    NSString* filepath = [docsDir stringByAppendingPathComponent:kProposedBusinessesFilename];
    return filepath;
}

#pragma mark - saved game data loading and unloading
+ (ProposedBusinesses*) loadProposedBusinessesData
{
    ProposedBusinesses* current_proposedbusinesses = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [ProposedBusinesses proposedBusinessesFilepath];
    if ([fileManager fileExistsAtPath:filepath])
    {
        NSData* readData = [NSData dataWithContentsOfFile:filepath];
        if(readData)
        {
            current_proposedbusinesses = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        }
    }
    return current_proposedbusinesses;
}

- (void) saveProposedBusinessesData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSError* error = nil;
    BOOL writeSuccess = [data writeToFile:[ProposedBusinesses proposedBusinessesFilepath]
                                  options:NSDataWritingAtomic
                                    error:&error];
    if(writeSuccess)
    {
        NSLog(@"proposed businesses file saved successfully");
    }
    else
    {
        NSLog(@"proposed businesses file save failed: %@", error);
    }
}

- (void) removeProposedBusinessesData
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [ProposedBusinesses proposedBusinessesFilepath];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:filepath])
    {
        [fileManager removeItemAtPath:filepath error:&error];
    }
}

#pragma mark - public functions
- (BOOL) needsRefresh
{
    return (!_lastUpdate) || ([_lastUpdate timeIntervalSinceNow] < refreshTime);
}

- (void) createProposedBusinessesArray:(id)responseObject
{
    for (NSDictionary* proposedBusiness in responseObject)
    {
        ProposedBusiness* current = [[ProposedBusiness alloc] initWithDictionary:proposedBusiness];
        [_proposedBusinessesArray addObject:current];
    }
}

#pragma mark - Server calls

- (void) retrieveProposedBusinesses:(NSObject<HttpCallbackDelegate>*) delegate
{
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    [httpClient getPath:@"paid_punch/ProposedBusinesses"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"Retrieved: %@", responseObject);
                    [_proposedBusinessesArray removeAllObjects];
                    [self createProposedBusinessesArray:responseObject];
                    _lastUpdate = [NSDate date];
                    [self saveProposedBusinessesData];
                    [delegate didCompleteHttpCallback:kKeyProposedBusinessesRetrieve success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"Downloading new proposed businesses from server has failed.");
                    [delegate didCompleteHttpCallback:kKeyProposedBusinessesRetrieve success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

- (void) voteBusiness:(NSObject<HttpCallbackDelegate>*) delegate index:(NSUInteger)index
{
    // put parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[User getInstance] userId], kKeyUserId,
                                nil];
    
    NSString* path = [NSString stringWithFormat:@"paid_punch/ProposedBusinesses/%@/vote", [[_proposedBusinessesArray objectAtIndex:index] proposedBusinessId]];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    [httpClient putPath:path
             parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"Retrieved: %@", responseObject);
                    [delegate didCompleteHttpCallback:kKeyProposedBusinessesVote success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"Voting for proposed business failed with error: %@", error.description);
                    [delegate didCompleteHttpCallback:kKeyProposedBusinessesVote success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

- (void) suggestBusiness:(NSObject<HttpCallbackDelegate>*) delegate name:(NSString*)name info:(NSString*)info
{
    // put parameters
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[User getInstance] userId], kKeyUserId,
                                name, kKeyBusinessName,
                                info, kKeyBusinessInfo,
                                nil];
    
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    [httpClient putPath:@"paid_punch/ProposedBusinesses/suggest"
             parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"Retrieved: %@", responseObject);
                    [delegate didCompleteHttpCallback:kKeyProposedBusinessesVote success:TRUE message:[responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"Suggesting a new business failed with error: %@", error.description);
                    [delegate didCompleteHttpCallback:kKeyProposedBusinessesVote success:FALSE message:[Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

#pragma mark - Singleton
static ProposedBusinesses* singleton = nil;
+ (ProposedBusinesses*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            // First, try to load the user data from disk
            singleton = [ProposedBusinesses loadProposedBusinessesData];
            if (!singleton)
            {
                // OK, no saved data available. Go ahead and create a new User.
                singleton = [[ProposedBusinesses alloc] init];
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

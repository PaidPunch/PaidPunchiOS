//
//  InviteTemplates.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/9/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "AFClientManager.h"
#import "InviteTemplates.h"
#import "Utilities.h"

static NSString* const kKeyVersion = @"version";
static NSString* const kKeyEmailTemplate = @"emailTemplate";
static NSString* const kKeyFacebookTemplate = @"facebookTemplate";
static NSString* const kTemplatesFilename = @"template.sav";
static NSString* const kKeyStatusMessage = @"statusMessage";

// 1 hour refresh schedule
static double const refreshTime = -(60 * 30);

@implementation InviteTemplates
@synthesize emailTemplate = _emailTemplate;
@synthesize facebookTemplate = _facebookTemplate;

- (id) init
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _lastUpdate = NULL;
        _facebookTemplate = @"";
        _emailTemplate = @"";
    }
    return self;
}

- (BOOL) needsRefresh
{
    return (!_lastUpdate) || ([_lastUpdate timeIntervalSinceNow] < refreshTime);
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_emailTemplate forKey:kKeyEmailTemplate];
    [aCoder encodeObject:_facebookTemplate forKey:kKeyFacebookTemplate];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
    _emailTemplate = [aDecoder decodeObjectForKey:kKeyEmailTemplate];
    _facebookTemplate = [aDecoder decodeObjectForKey:kKeyFacebookTemplate];
    return self;
}

#pragma mark - saved game data loading and unloading
+ (NSString*) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*) templatesFilepath
{
    NSString* docsDir = [InviteTemplates documentsDirectory];
    NSString* filepath = [docsDir stringByAppendingPathComponent:kTemplatesFilename];
    return filepath;
}

+ (InviteTemplates*) loadTemplatesData
{
    InviteTemplates* current_templates = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [InviteTemplates templatesFilepath];
    if ([fileManager fileExistsAtPath:filepath])
    {
        NSData* readData = [NSData dataWithContentsOfFile:filepath];
        if(readData)
        {
            current_templates = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        }
    }
    return current_templates;
}

- (void) saveTemplatesData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSError* error = nil;
    BOOL writeSuccess = [data writeToFile:[InviteTemplates templatesFilepath]
                                  options:NSDataWritingAtomic
                                    error:&error];
    if(writeSuccess)
    {
        NSLog(@"templates file saved successfully");
    }
    else
    {
        NSLog(@"templates file save failed: %@", error);
    }
}

- (void) removeTemplatesData
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [InviteTemplates templatesFilepath];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:filepath])
    {
        [fileManager removeItemAtPath:filepath error:&error];
    }
}

#pragma mark - Server calls

- (void) retrieveTemplatesFromServer:(NSObject<HttpCallbackDelegate>*) delegate
{
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    [httpClient getPath:@"paid_punch/Templates"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"Retrieved: %@", responseObject);
                    NSDictionary* dict = responseObject;
                    _emailTemplate = [NSString stringWithFormat:@"%@", [dict valueForKeyPath:@"email"]];
                    _facebookTemplate = [NSString stringWithFormat:@"%@", [dict valueForKeyPath:@"facebook"]];
                    _lastUpdate = [NSDate date];
                    [self saveTemplatesData];
                    [delegate didCompleteHttpCallback:TRUE, [responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"Downloading new Products from server has failed.");
                    [delegate didCompleteHttpCallback:FALSE, [Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

#pragma mark - Singleton
static InviteTemplates* singleton = nil;
+ (InviteTemplates*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            // First, try to load the user data from disk
            singleton = [InviteTemplates loadTemplatesData];
            if (!singleton)
            {
                // OK, no saved data available. Go ahead and create a new User.
                singleton = [[InviteTemplates alloc] init];
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

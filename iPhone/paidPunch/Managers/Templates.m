//
//  Templates
//  paidPunch
//
//  Created by Aaron Khoo on 1/9/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "AFClientManager.h"
#import "Template.h"
#import "Templates.h"
#import "User.h"
#import "Utilities.h"

static NSString* const kKeyVersion = @"version";
static NSString* const kKeyTemplates = @"templates";
static NSString* const kKeyLastUpdate = @"lastUpdate";
static NSString* const kTemplatesFilename = @"template.sav";
static NSString* const kKeyStatusMessage = @"statusMessage";

// 1 hour refresh schedule
static double const refreshTime = -(60 * 30);

@implementation Templates

- (id) init
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _lastUpdate = NULL;
        _templatesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL) needsRefresh
{
    return (!_lastUpdate) || ([_lastUpdate timeIntervalSinceNow] < refreshTime);
}

- (NSString*) getTemplateByName:(NSString*)name
{
    Template* result = nil;
    for (Template* current in _templatesArray)
    {
        if ([[current name] compare:name] == NSOrderedSame)
        {
            result = current;
            break;
        }
    }
    return [result templateValue];
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_lastUpdate forKey:kKeyLastUpdate];
    [aCoder encodeObject:_templatesArray forKey:kKeyTemplates];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
    _lastUpdate = [aDecoder decodeObjectForKey:kKeyLastUpdate];
    _templatesArray = [aDecoder decodeObjectForKey:kKeyTemplates];
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
    NSString* docsDir = [Templates documentsDirectory];
    NSString* filepath = [docsDir stringByAppendingPathComponent:kTemplatesFilename];
    return filepath;
}

+ (Templates*) loadTemplatesData
{
    Templates* current_templates = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [Templates templatesFilepath];
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
    BOOL writeSuccess = [data writeToFile:[Templates templatesFilepath]
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
    NSString* filepath = [Templates templatesFilepath];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:filepath])
    {
        [fileManager removeItemAtPath:filepath error:&error];
    }
}

- (void) createTemplatesArray:(id)responseObject
{
    for (NSDictionary* templateValue in responseObject)
    {
        Template* current = [[Template alloc] initWithDictionary:templateValue];
        [_templatesArray addObject:current];
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
                    [self createTemplatesArray:dict];
                    _lastUpdate = [NSDate date];
                    [self saveTemplatesData];
                    [delegate didCompleteHttpCallback:kKeyTemplatesRetrieve, TRUE, [responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"Downloading new Products from server has failed.");
                    [delegate didCompleteHttpCallback:kKeyTemplatesRetrieve, FALSE, [Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

#pragma mark - Singleton
static Templates* singleton = nil;
+ (Templates*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            // First, try to load the user data from disk
            singleton = [Templates loadTemplatesData];
            if (!singleton)
            {
                // OK, no saved data available. Go ahead and create a new User.
                singleton = [[Templates alloc] init];
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

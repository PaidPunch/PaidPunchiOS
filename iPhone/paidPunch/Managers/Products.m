//
//  Products.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "AFClientManager.h"
#import "Product.h"
#import "Products.h"
#import "Utilities.h"

static NSString* const kKeyVersion = @"version";
static NSString* const kKeyLastUpdate = @"lastUpdate";
static NSString* const kKeyProducts = @"products";
static NSString* const kKeyStatusMessage = @"statusMessage";
static NSString* const kProductsFilename = @"products.sav";

@implementation Products
@synthesize productsArray = _productsArray;
@synthesize lastUpdate = _lastUpdate;

- (id) init
{
    self = [super init];
    if(self)
    {
        _createdVersion = @"1.0";
        _lastUpdate = NULL;
        _productsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - NSCoding
- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_createdVersion forKey:kKeyVersion];
    [aCoder encodeObject:_lastUpdate forKey:kKeyLastUpdate];
    [aCoder encodeObject:_productsArray forKey:kKeyProducts];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    _createdVersion = [aDecoder decodeObjectForKey:kKeyVersion];
    _lastUpdate = [aDecoder decodeObjectForKey:kKeyLastUpdate];
    _productsArray = [aDecoder decodeObjectForKey:kKeyProducts];
    return self;
}

#pragma mark - private functions

+ (NSString*) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*) productsFilepath
{
    NSString* docsDir = [Products documentsDirectory];
    NSString* filepath = [docsDir stringByAppendingPathComponent:kProductsFilename];
    return filepath;
}

#pragma mark - saved game data loading and unloading
+ (Products*) loadProductsData
{
    Products* current_products = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [Products productsFilepath];
    if ([fileManager fileExistsAtPath:filepath])
    {
        NSData* readData = [NSData dataWithContentsOfFile:filepath];
        if(readData)
        {
            current_products = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        }
    }
    return current_products;
}

- (void) saveProductsData
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSError* error = nil;
    BOOL writeSuccess = [data writeToFile:[Products productsFilepath]
                                  options:NSDataWritingAtomic
                                    error:&error];
    if(writeSuccess)
    {
        NSLog(@"products file saved successfully");
    }
    else
    {
        NSLog(@"products file save failed: %@", error);
    }
}

- (void) removeProductsData
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filepath = [Products productsFilepath];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:filepath])
    {
        [fileManager removeItemAtPath:filepath error:&error];
    }
}

#pragma mark - public functions
- (BOOL) needsRefresh:(NSDate*) lastModifiedDate
{
    return (!_lastUpdate) || ([_lastUpdate timeIntervalSinceDate:lastModifiedDate] < 0);
}

- (void) createProductsArray:(id)responseObject
{
    for (NSDictionary* product in responseObject)
    {
        Product* current = [[Product alloc] initWithDictionary:product];
        [_productsArray addObject:current];
    }
    
#if defined(USE_FALLBACKS)
    [self fillMissingFlyerTypesFromFallback];
#endif
}

#pragma mark - Server calls

- (void) retrieveProductsFromServer:(NSObject<HttpCallbackDelegate>*) delegate
{
    // make a post request
    AFHTTPClient* httpClient = [[AFClientManager sharedInstance] paidpunch];
    [httpClient getPath:@"paid_punch/Products"
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject){
                    NSLog(@"Retrieved: %@", responseObject);
                    [_productsArray removeAllObjects];
                    [self createProductsArray:responseObject];
                    _lastUpdate = [NSDate date];
                    [self saveProductsData];
                    [delegate didCompleteHttpCallback:TRUE, [responseObject valueForKeyPath:kKeyStatusMessage]];
                }
                failure:^(AFHTTPRequestOperation* operation, NSError* error){
                    NSLog(@"Downloading new Products from server has failed.");
                    [delegate didCompleteHttpCallback:FALSE, [Utilities getStatusMessageFromResponse:operation]];
                }
     ];
}

#pragma mark - Singleton
static Products* singleton = nil;
+ (Products*) getInstance
{
	@synchronized(self)
	{
		if (!singleton)
		{
            // First, try to load the user data from disk
            singleton = [Products loadProductsData];
            if (!singleton)
            {
                // OK, no saved data available. Go ahead and create a new User.
                singleton = [[Products alloc] init];
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

//
//  AFClientManager.m
//
//  Created by Aaron Khoo on 12/11/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import "AFClientManager.h"
#import "AFJSONRequestOperation.h"
#import "User.h"

#define USE_PRODUCTION_SERVER 1

#if defined(USE_PRODUCTION_SERVER)
static NSString* const kPaidPunchBaseURLString = @"api.paidpunch.com";
static NSString* const kPaidPunchPort = @"443";
static NSString* const kPaidPunchFullPath = @"https://api.paidpunch.com";
#else
static NSString* const kPaidPunchBaseURLString = @"test.paidpunch.com";
static NSString* const kPaidPunchPort = @"80";
static NSString* const kPaidPunchFullPath = @"http://test.paidpunch.com/paid_punch";
#endif


@implementation AFClientManager
@synthesize paidpunch = _paidpunch;
@synthesize appUrl = _appUrl;

- (id) init
{
    self = [super init];
    if(self)
    {
        _paidpunch = nil;
        
        [self resetPaidPunchWithIp:kPaidPunchBaseURLString];

        _appUrl = kPaidPunchFullPath;
    }
    return self;
}

- (void) dealloc
{
    [_paidpunch unregisterHTTPOperationClass:[AFJSONRequestOperation class]];
}

- (NSString*) getPaidPunchURL
{
    return [NSString stringWithFormat:@"%@", kPaidPunchBaseURLString];
}

- (void) resetPaidPunchWithIp:(NSString *)serverIp
{
    if(_paidpunch)
    {
        [_paidpunch unregisterHTTPOperationClass:[AFJSONRequestOperation class]];
    }

#if defined(FINAL) || defined(USE_PRODUCTION_SERVER)
    NSString* urlString = [NSString stringWithFormat:@"https://%@:%@/", serverIp, kPaidPunchPort];
#else
    NSString* urlString = [NSString stringWithFormat:@"http://%@:%@/", serverIp, kPaidPunchPort];
#endif
    NSLog(@"traderpog client reset with server ip %@", urlString);
    
    _paidpunch = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [_paidpunch registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //  Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [_paidpunch setDefaultHeader:@"Accept" value:@"application/json"];
    [_paidpunch setDefaultHeader:@"api-version" value:@"1.0"];
    [_paidpunch setDefaultHeader:@"sessionid" value:[[User getInstance] uniqueId]];
    
    // Encode parameters in XML format
    _paidpunch.parameterEncoding =  AFJSONParameterEncoding;
}

#pragma mark - singleton
static AFClientManager* _sharedInstance = nil;
+ (AFClientManager*)sharedInstance
{
	@synchronized(self)
	{
		if (!_sharedInstance)
		{
			_sharedInstance = [[AFClientManager alloc] init];
		}
        return _sharedInstance;
	}
}

+ (void) destroyInstance
{
    @synchronized(self)
    {
        _sharedInstance = nil;
    }
}

@end

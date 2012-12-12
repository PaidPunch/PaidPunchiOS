//
//  AFClientManager.m
//
//  Created by Aaron Khoo on 12/11/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import "AFClientManager.h"
#import "AFXMLRequestOperation.h"

#if defined(FINAL) || defined(USE_PRODUCTION_SERVER)
static NSString* const kPaidPunchBaseURLString = @"paidpunch.com";
static NSString* const kPaidPunchPort = @"443";
#else
static NSString* const kPaidPunchBaseURLString = @"test.paidpunch.com";
static NSString* const kPaidPunchPort = @"80";
#endif


@implementation AFClientManager
@synthesize paidpunch = _paidpunch;

- (id) init
{
    self = [super init];
    if(self)
    {
        _paidpunch = nil;
        
        [self resetPaidPunchWithIp:kPaidPunchBaseURLString];
    }
    return self;
}

- (void) dealloc
{
    [_paidpunch unregisterHTTPOperationClass:[AFXMLRequestOperation class]];
}

- (NSString*) getPaidPunchURL
{
    return [NSString stringWithFormat:@"%@", kPaidPunchBaseURLString];
}

- (void) resetPaidPunchWithIp:(NSString *)serverIp
{
    if(_paidpunch)
    {
        [_paidpunch unregisterHTTPOperationClass:[AFXMLRequestOperation class]];
    }

#if defined(FINAL) || defined(USE_PRODUCTION_SERVER)
    NSString* urlString = [NSString stringWithFormat:@"https://%@:%@/", serverIp, kTraderPogPort];
#else
    NSString* urlString = [NSString stringWithFormat:@"http://%@:%@/", serverIp, kPaidPunchPort];
#endif
    NSLog(@"traderpog client reset with server ip %@", urlString);
    
    _paidpunch = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [_paidpunch registerHTTPOperationClass:[AFXMLRequestOperation class]];
    
    //  Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [_paidpunch setDefaultHeader:@"Accept" value:@"application/json"];
    [_paidpunch setDefaultHeader:@"expected-traderpog-version" value:@"1.0"];
    
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

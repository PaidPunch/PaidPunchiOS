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
static NSString* const kKeyUserId = @"user_id";
static NSString* const kKeyPunchId = @"punchcardid";
static NSString* const kKeyStatusMessage = @"statusMessage";
static NSString* const kKeyUniqueId = @"sessionid";

@implementation Punches

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
    NSString* path = @"paid_punch/Punches";
    [httpClient postPath:path
              parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"%@", responseObject);
                     [delegate didCompleteHttpCallback:TRUE, [responseObject valueForKeyPath:kKeyStatusMessage]];
                 }
                 failure:^(AFHTTPRequestOperation* operation, NSError* error){
                     NSLog(@"Punch purchase failed with code: %d", [operation.response statusCode]);
                     [delegate didCompleteHttpCallback:FALSE, [Utilities getStatusMessageFromResponse:operation]];
                 }
     ];
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

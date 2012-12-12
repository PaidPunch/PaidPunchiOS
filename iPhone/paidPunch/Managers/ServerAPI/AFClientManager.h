//
//  AFClientManager.h
//
//  Created by Aaron Khoo on 12/11/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "AFHTTPClient.h"

@class AFHTTPClient;
@interface AFClientManager : NSObject
{
    AFHTTPClient* _paidpunch;
}
@property (nonatomic,readonly) AFHTTPClient* paidpunch;

- (NSString*) getPaidPunchURL;
- (void) resetPaidPunchWithIp:(NSString*)serverIp;

// singelton
+ (AFClientManager*) sharedInstance;
+ (void) destroyInstance;

@end

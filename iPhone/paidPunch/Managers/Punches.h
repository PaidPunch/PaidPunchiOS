//
//  Punches.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/15/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"
#import "NetworkManager.h"
#import "NetworkManagerDelegate.h"

static NSString* const kKeyPunchesPurchase = @"punches_purchase";
static NSString* const kKeyPunchesRetrieve = @"punches_retrieve";

@interface Punches : NSObject<NetworkManagerDelegate>
{
    // internal
    NSString* _createdVersion;
    
    NSDate* _lastUpdate;
    NSMutableArray* _punchesArray;
    
    NetworkManager* _networkManager;
    
    // Couple hacks to handle mypunches for now
    __weak NSObject<HttpCallbackDelegate>* _mypunchesDelegate;
    NSUInteger _numPunches;
}
@property (nonatomic,readonly) NSDate* lastUpdate;
@property (nonatomic,strong) NSArray* punchesArray;

- (BOOL) needsRefresh;
-(void)getMyPunches:(NSObject<HttpCallbackDelegate>*)delegate;
- (void) purchasePunchWithCredit:(NSObject<HttpCallbackDelegate>*)delegate punchid:(NSString*)punchid;

+ (Punches*) getInstance;
+ (void) destroyInstance;

@end

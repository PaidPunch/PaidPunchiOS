//
//  Businesses.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/8/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"
#import "NetworkManager.h"
#import "NetworkManagerDelegate.h"

static NSString* const kKeyBusinessesRetrieval = @"businesses_retrieval";

@interface Businesses : NSObject<NetworkManagerDelegate>
{
    // internal
    NSString* _createdVersion;
    
    NSDate* _lastUpdate;
    
    NetworkManager* _networkManager;
    
    __weak NSObject<HttpCallbackDelegate>* _businessesDelegate;
    
    NSMutableDictionary* _businessesDict;
}

- (BOOL) needsRefresh;
- (void) forceRefresh;
- (void) retrieveBusinessesFromServer:(NSObject<HttpCallbackDelegate>*)delegate;
- (NSArray*) getBusinessesCloseby:(CLLocation*)location;

+ (Businesses*) getInstance;
+ (void) destroyInstance;
@end

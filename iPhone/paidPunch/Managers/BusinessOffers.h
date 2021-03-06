//
//  BusinessOffers.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/9/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Business.h"
#import "HttpCallbackDelegate.h"
#import "NetworkManager.h"
#import "PunchCard.h"

static NSString* const kKeyBusinessOffersRetrieval = @"businessoffer_retrieval";

@interface BusinessOffers : NSObject<NetworkManagerDelegate>
{
    Business* _business;
    PunchCard* _offer;
    NSDate* _lastUpdate;
    __weak NSObject<HttpCallbackDelegate>* _delegate;
    NetworkManager* _networkManager;
    NSNumber* _diff_in_miles;
}
@property (nonatomic,strong) Business* business;
@property (nonatomic, strong) NSNumber* diff_in_miles;

- (id) initWithBusiness:(Business*)current;
- (BOOL) needsRefresh;
- (void) forceRefresh;
- (BOOL) matchBusinessId:(NSString*)bizId;
- (BOOL) matchBusinessName:(NSString*)name;
- (NSArray*) getOffers;
- (void) retrieveOffersFromServer:(NSObject<HttpCallbackDelegate>*)delegate;

@end

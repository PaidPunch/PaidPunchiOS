//
//  BusinessOffers.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/9/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "BusinessOffers.h"
#import "User.h"

// 1 hour refresh schedule
static double const refreshTime = -(60 * 60);

@implementation BusinessOffers
@synthesize business = _business;
@synthesize diff_in_miles = _diff_in_miles;

- (id) initWithBusiness:(Business*)current
{
    self = [super init];
    if(self)
    {
        _business = current;
        _offer = nil;
        
        _networkManager=[[NetworkManager alloc] init];
        _networkManager.delegate = self;
    }
    return self;
}

- (BOOL) needsRefresh
{
    return (!_lastUpdate) || ([_lastUpdate timeIntervalSinceNow] < refreshTime);
}

- (void) forceRefresh
{
    _lastUpdate = nil;
}

- (BOOL) matchBusinessId:(NSString*)bizId
{
    return ([bizId compare:[_business business_id]] == NSOrderedSame);
}

- (BOOL) matchBusinessName:(NSString*)name
{
    return ([name compare:[_business business_name]] == NSOrderedSame);
}

- (NSArray*) getOffers
{
    // Built this way in prepartion of the time when businesses can have more than one active offer.
    NSMutableArray* _offerArray = nil;
    if (_offer)
    {
        _offerArray = [[NSMutableArray alloc] init];
        [_offerArray addObject:_offer];
    }
    return _offerArray;
}

- (void) retrieveOffersFromServer:(NSObject<HttpCallbackDelegate>*)delegate
{
    _delegate = delegate;
    [_networkManager getBusinessOffer:_business.business_name loggedInUserId:[[User getInstance] userId]];
}

#pragma make Event actions

- (void) didFinishLoadingBusinessOffer:(NSString *)statusCode statusMessage:(NSString *)message punchCardDetails:(PunchCard*)punchCard
{
    if ([statusCode rangeOfString:@"00"].location == NSNotFound || punchCard == nil)
    {
        // Some failure occurred
        NSLog(@"Loading Biz Offer: Error: %@", message);
        [_delegate didCompleteHttpCallback:kKeyBusinessOffersRetrieval success:FALSE message:message];
    }
    else
    {
        _offer = punchCard;
        [_delegate didCompleteHttpCallback:kKeyBusinessOffersRetrieval success:TRUE message:message];
    }
}

@end

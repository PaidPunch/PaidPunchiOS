//
//  ProposedBusinesses.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/26/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"

static NSString* const kKeyProposedBusinessesRetrieve = @"proposedbusinesses_retrieve";
static NSString* const kKeyProposedBusinessesVote = @"proposedbusinesses_vote";

@interface ProposedBusinesses : NSObject
{
    // internal
    NSString* _createdVersion;
    
    NSDate* _lastUpdate;
    NSMutableArray* _proposedBusinessesArray;
    NSMutableDictionary* _votedBusinesses;
}
@property (nonatomic,strong) NSMutableArray* proposedBusinessesArray;
@property (nonatomic,readonly) NSDate* lastUpdate;

- (void) retrieveProposedBusinesses:(NSObject<HttpCallbackDelegate>*) delegate;
- (void) voteBusiness:(NSObject<HttpCallbackDelegate>*) delegate index:(NSUInteger)index;
- (BOOL) needsRefresh;
- (BOOL) alreadyVoted:(NSString*)businessId;
- (void) recordVote:(NSString*)businessId;

+ (ProposedBusinesses*) getInstance;
+ (void) destroyInstance;

@end

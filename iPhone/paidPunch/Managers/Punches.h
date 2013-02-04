//
//  Punches.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/15/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"

static NSString* const kKeyPunchesPurchase = @"punches_purchase";

@interface Punches : NSObject
{
    // internal
    NSString* _createdVersion;
    
    NSDate* _lastUpdate;
    NSArray* _punchesArray;
}
@property (nonatomic,readonly) NSDate* lastUpdate;
@property (nonatomic,strong) NSArray* punchesArray;

- (void) updateDate;
- (BOOL) needsRefresh;
- (void) purchasePunchWithCredit:(NSObject<HttpCallbackDelegate>*)delegate punchid:(NSString*)punchid;

+ (Punches*) getInstance;
+ (void) destroyInstance;

@end

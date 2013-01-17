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
    // HACK: This is a hack to mirror a legacy situation
    //       involving UI refresh of punches. Unfortunately,
    //       we are stuck with it until we have a chance to
    //       to redesign the UI.
    BOOL _justPurchased;
}
@property(nonatomic) BOOL justPurchased;

- (void) purchasePunchWithCredit:(NSObject<HttpCallbackDelegate>*)delegate punchid:(NSString*)punchid;

+ (Punches*) getInstance;
+ (void) destroyInstance;

@end

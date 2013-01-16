//
//  Punches.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/15/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpCallbackDelegate.h"

@interface Punches : NSObject

- (void) purchasePunchWithCredit:(NSObject<HttpCallbackDelegate>*)delegate punchid:(NSString*)punchid;

+ (Punches*) getInstance;
+ (void) destroyInstance;

@end

//
//  HiAccuracyLocatorDelegate.h
//  traderpog
//
//  Created by Shu Chiun Cheah on 7/20/12.
//  Copyright (c) 2012 GeoloPigs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kStopReasonDesiredAccuracy = 0,
    kStopReasonTimedOut,
    kStopReasonLocationUnknown,
    kStopReasonDenied,
    
    kStopReasonNum
} StopReason;

@class HiAccuracyLocator;
@protocol HiAccuracyLocatorDelegate <NSObject>

- (void) locator:(HiAccuracyLocator*)locator didLocateUser:(BOOL)didLocateUser reason:(StopReason)reason;

@end

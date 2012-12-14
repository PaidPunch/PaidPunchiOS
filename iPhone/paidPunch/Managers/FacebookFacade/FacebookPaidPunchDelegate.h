//
//  FacebookPaidPunchDelegate.h
//  paidPunch
//
//  Created by Aaron Khoo on 12/13/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FacebookPaidPunchDelegate <NSObject>
- (void) didCompleteFacebookLogin:(BOOL) success;
@end

//
//  MyCouponViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "PunchCard.h"

@interface MyCouponViewController : BaseWithNavBarViewController
{
    UILabel* _remainingAmountBar;
}

- (id)initWithPunchcard:(PunchCard *)current;

@end

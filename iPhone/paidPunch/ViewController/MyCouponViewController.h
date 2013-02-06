//
//  MyCouponViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "NetworkManagerDelegate.h"
#import "PunchCard.h"

@interface MyCouponViewController : BaseWithNavBarViewController<UIAlertViewDelegate,NetworkManagerDelegate>
{
    UILabel* _remainingAmountBar;
    NetworkManager* _networkManager;
    MBProgressHUD* _hud;
}

- (id)initWithPunchcard:(PunchCard *)current;

@end

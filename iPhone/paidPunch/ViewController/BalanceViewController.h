//
//  BalanceViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/30/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface BalanceViewController : BaseWithNavBarViewController<HttpCallbackDelegate,UIAlertViewDelegate>
{
    MBProgressHUD* _hud;
    UILabel* _whitebarLabel;
}

@end

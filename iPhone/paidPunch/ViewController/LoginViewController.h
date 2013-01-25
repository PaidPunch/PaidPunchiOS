//
//  LoginViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/24/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "FacebookPaidPunchDelegate.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"

@interface LoginViewController : BaseWithNavBarViewController<HttpCallbackDelegate,NetworkManagerDelegate>
{
    MBProgressHUD* _hud;
    NetworkManager* _networkManager;
}

@end

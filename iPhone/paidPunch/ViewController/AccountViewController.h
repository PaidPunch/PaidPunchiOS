//
//  AccountViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "HiAccuracyLocatorDelegate.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"

@interface AccountViewController : BaseWithNavBarViewController<UIAlertViewDelegate,HiAccuracyLocatorDelegate,UITableViewDataSource,UITableViewDelegate,NetworkManagerDelegate>
{
    UITableView* _tableView;
    MBProgressHUD* _hud;
    UIAlertView* _locationAlertView;
    NetworkManager *_networkManager;
}

@end

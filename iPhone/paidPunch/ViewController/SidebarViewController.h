//
//  SidebarViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiAccuracyLocatorDelegate.h"
#import "MBProgressHUD.h"

@interface SidebarViewController : UITableViewController<UIAlertViewDelegate,HiAccuracyLocatorDelegate>
{
    MBProgressHUD* _hud;
    UIAlertView* _locationAlertView;
}

@end

//
//  AccountViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"

@interface AccountViewController : BaseWithNavBarViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,NetworkManagerDelegate,MFMailComposeViewControllerDelegate,HttpCallbackDelegate>
{
    UITableView* _tableView;
    MBProgressHUD* _hud;
    UIAlertView* _locationAlertView;
    UIAlertView* _feedbackAlertView;
    NetworkManager *_networkManager;
    __weak UIViewController* _parentController;
}
@property(nonatomic,weak) UIViewController* parentController;

@end

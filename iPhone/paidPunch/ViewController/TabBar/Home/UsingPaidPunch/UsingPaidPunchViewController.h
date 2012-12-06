//
//  UsingPaidPunchViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 14/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoExpert.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface UsingPaidPunchViewController : UIViewController<UIWebViewDelegate>
{
    UIView *activityView;
    MBProgressHUD *popupHUD;
}
@property (strong, nonatomic) IBOutlet UIWebView *usingPaidPunchWebView;

@end

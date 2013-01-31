//
//  PaidPunchHomeViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface PaidPunchHomeViewController : UIViewController<HttpCallbackDelegate>
{
    UIView* _mainView;
    CGFloat _lowestYPos;
    MBProgressHUD* _hud;
    UIButton* _creditsButton;
}

@end

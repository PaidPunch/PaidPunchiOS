//
//  PaidPunchHomeViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HiAccuracyLocatorDelegate.h"
#import "HomePaidPunchButton.h"
#import "HomePaidPunchButtonDelegate.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface PaidPunchHomeViewController : UIViewController<HttpCallbackDelegate,HomePaidPunchButtonDelegate,HiAccuracyLocatorDelegate>
{
    UIView* _mainView;
    UIView* _bizBaseView;
    UIView* _currentBizView;
    CGFloat _lowestYPos;
    MBProgressHUD* _hud;
    UIButton* _creditsButton;
    HomePaidPunchButton* _paidpunchButton;
    BOOL _launchMyCouponsOnWillAppear;
    
    // Tracking server requests
    BOOL _updatingUserInfo;
    BOOL _updatingBusinesses;
}
@property (nonatomic) BOOL launchMyCouponsOnWillAppear;

@end

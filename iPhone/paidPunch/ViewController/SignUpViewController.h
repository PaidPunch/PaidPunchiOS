//
//  SignUpViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/23/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "FacebookPaidPunchDelegate.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface SignUpViewController : BaseWithNavBarViewController<HttpCallbackDelegate,UIAlertViewDelegate>
{
    NSString* _inviteCode;
    MBProgressHUD* _hud;
}

- (id)initWithInviteCode:(NSString*)inviteCode;

@end

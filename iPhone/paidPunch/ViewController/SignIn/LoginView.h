//
//  LoginView.h
//  paidPunch
//
//  Created by Aaron Khoo on 12/8/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "FacebookPaidPunchDelegate.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"

@interface LoginView : BaseView<HttpCallbackDelegate,NetworkManagerDelegate>
{
    UITextField* _emailTextField;
    UITextField* _passwordTextField;
    
    MBProgressHUD* _hud;
    
    NetworkManager* _networkManager;
}

- (void) dismissKeyboard;

@end

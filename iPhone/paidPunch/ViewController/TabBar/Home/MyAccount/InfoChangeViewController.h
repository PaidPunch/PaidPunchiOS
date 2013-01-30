//
//  InfoChangeViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/10/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface InfoChangeViewController : BaseWithNavBarViewController<HttpCallbackDelegate,UITextFieldDelegate>
{
    //UIScrollView *_scrollview;
    UITextField *_usernameTF;
    UITextField *_mobilenoTF;
    UITextField *_oldpasswordTF;
    UITextField *_newpasswordTF;
    UIButton* _passwordBtn;
    UIButton *_updateBtn;
    MBProgressHUD* _hud;
}

@end

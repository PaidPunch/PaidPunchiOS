//
//  SignupView.h
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

@interface SignupView : BaseView<HttpCallbackDelegate>
{
    UIImage *uncheckedImage;
    UIImage *checkedImage;
    BOOL checked;
    
    UIButton* checkbox;
    UITextField *referralTextField;
    
    MBProgressHUD *hud;
}

- (void) dismissKeyboard;

@end

//
//  SuggestBusinessView.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/30/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"
#import "PopUpBaseView.h"

@interface SuggestBusinessView : PopUpBaseView<UITextFieldDelegate,UIAlertViewDelegate,HttpCallbackDelegate>
{
    UITextField* _nameField;
    UITextField* _infoField;
    MBProgressHUD* _hud;
}

@end

//
//  RequestInviteView.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/31/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpBaseView.h"

@interface RequestInviteView : PopUpBaseView<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField* _emailField;
}

@end

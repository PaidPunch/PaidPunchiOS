//
//  SignupView.h
//  paidPunch
//
//  Created by Aaron Khoo on 12/8/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface SignupView : BaseView
{
    UIImage *uncheckedImage;
    UIImage *checkedImage;
    BOOL checked;
    
    UIButton* checkbox;
    UITextField *referralTextField;
}

- (void) dismissKeyboard;

@end

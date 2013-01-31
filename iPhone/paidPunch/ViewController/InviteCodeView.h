//
//  InviteCodeView.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/31/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpBaseView.h"

@interface InviteCodeView : PopUpBaseView<UITextFieldDelegate>
{
    UITextField* _inviteCodeTextField;
    UIButton* _continueButton;
    UIButton* _requestInviteButton;
    UINavigationController* _controller;
}
@property(nonatomic,strong) UINavigationController* controller;

@end

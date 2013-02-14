//
//  InviteFriendsViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/25/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface InviteFriendsViewController : BaseWithNavBarViewController<HttpCallbackDelegate, UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    UIView* _inviteButtonsView;
    CGRect _offscreenRect;
    CGRect _onscreenRect;
    UIButton* _btnInvite;
    UITapGestureRecognizer* _dismissTap;
    UILabel* _invisibleLayer;
    
    MBProgressHUD* _hud;
}

- (id)init:(BOOL)popWhenDone duringSignup:(BOOL)duringSignup;

@end

//
//  BusinessDescView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface BusinessDescView : UIView<UIAlertViewDelegate,HttpCallbackDelegate>
{
    Business* _business;
    CGFloat _lowestYPos;
    
    UIAlertView* _notEnoughCreditsAlert;
    UIAlertView* _confirmPurchaseAlert;
    
    MBProgressHUD* _hud;
}

- (id)initWithFrameAndBusiness:(CGRect)frame business:(Business*)business;

@end

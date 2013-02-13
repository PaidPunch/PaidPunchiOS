//
//  MyCouponsView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/1/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"
#import "MyCouponsTableView.h"
#import "PopUpBaseView.h"

@interface MyCouponsView : PopUpBaseView<HttpCallbackDelegate>
{
    CGFloat _lowestYPos;
    MyCouponsTableView* _myCouponsTable;
    MBProgressHUD* _hud;
}

@end

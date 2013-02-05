//
//  MyCouponsView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/1/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MyCouponsTableView.h"
#import "NetworkManager.h"
#import "NetworkManagerDelegate.h"
#import "PopUpBaseView.h"

@interface MyCouponsView : PopUpBaseView<NetworkManagerDelegate>
{
    CGFloat _lowestYPos;
    UIScrollView* _myCouponsScrollView;
    MyCouponsTableView* _myCouponsTable;
    NetworkManager* _networkManager;
    MBProgressHUD* _hud;
    UINavigationController* _controller;
}
@property(nonatomic,strong) UINavigationController* controller;

@end

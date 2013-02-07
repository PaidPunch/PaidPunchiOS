//
//  BusinessPageViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "Business.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"

@interface BusinessPageViewController : BaseWithNavBarViewController<NetworkManagerDelegate>
{
    NSString* _bizId;
    NSString* _bizname;
    Business* _business;
    UIButton* _descButton;
    UIButton* _mapButton;
    UIButton* _callButton;
    
    NetworkManager* _networkManager;
    MBProgressHUD* _hud;
    
    UIView* _descView;
    UIView* _mapView;
    UIView* _callView;
    UIView* _currentView;
}

- (id)initWithBusiness:(NSString*)business_id business_name:(NSString*)business_name;

@end

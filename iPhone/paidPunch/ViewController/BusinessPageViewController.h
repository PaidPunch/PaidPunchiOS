//
//  BusinessPageViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "BusinessOffers.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface BusinessPageViewController : BaseWithNavBarViewController<HttpCallbackDelegate>
{
    NSString* _bizId;
    NSString* _bizname;
    BusinessOffers* _business;
    UIButton* _descButton;
    UIButton* _mapButton;
    UIButton* _callButton;
    
    MBProgressHUD* _hud;
    
    UIView* _descView;
    UIView* _mapView;
    UIView* _callView;
    UIView* _currentView;
}

- (id)initWithBusiness:(NSString*)business_id business_name:(NSString*)business_name;

@end

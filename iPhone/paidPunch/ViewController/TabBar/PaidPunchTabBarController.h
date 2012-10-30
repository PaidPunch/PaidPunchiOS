//
//  PaidPunchTabBarController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPunchesViewController.h"
#import "NetworkManager.h"
#import "FBConnect.h"

@class MyPunchesViewController;
@class NetworkManager;
@protocol NetworkManagerDelegate;

@interface PaidPunchTabBarController : UIViewController<UITabBarControllerDelegate,NetworkManagerDelegate,FBSessionDelegate>
{
    UITabBarController *tabBarController;  
    NetworkManager *networkManager;
}
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *myPunchesNavigationController;


-(void) requestAppIp;

@end

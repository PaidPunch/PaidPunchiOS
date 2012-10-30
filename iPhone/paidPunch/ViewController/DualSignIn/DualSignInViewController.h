//
//  DualSignInViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 14/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "NetworkManager.h"
#import "InfoExpert.h"
#import "MBProgressHUD.h"

@interface DualSignInViewController : UIViewController<NetworkManagerDelegate,FBRequestDelegate,UIAlertViewDelegate>
{
    NetworkManager *networkManager;  
//    UIView *activityView;
    MBProgressHUD *popupHUD;
}
@property (retain, nonatomic) IBOutlet UILabel *highlyrecommendedLbl;

- (IBAction)signInWithFacebookBtnTouchUpInsideHandler:(id)sender;
- (IBAction)signInWithoutFacebookBtnTouchUpInsideHandler:(id)sender;

- (IBAction)goBack:(id)sender;

-(void)goToSignView;
-(void)getUserProfileInfo;
-(void)apiGraphUserPermissions;
-(void)goToTabBarView;
-(void)showPopup;
-(void)removePopup;
-(void)loggedIn;
-(void)requestAppIp;

@end

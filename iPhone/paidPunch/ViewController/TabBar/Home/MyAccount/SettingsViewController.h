//
//  SettingsViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "SignInViewController.h"
#import "ChangePasswordViewController.h"
#import "AppDelegate.h"
#import "SDImageCache.h"
#import "Reachability.h"
#import "CreditCardSettingsViewController.h"
#import "MBProgressHUD.h"
#import "HttpCallbackDelegate.h"

@interface SettingsViewController : UIViewController<HttpCallbackDelegate,NetworkManagerDelegate,UITextFieldDelegate>
{
    NetworkManager *networkManager;
    
    MBProgressHUD *hud;
}
@property (strong, nonatomic) IBOutlet UILabel *usernameLbl;
@property (strong, nonatomic) IBOutlet UILabel *creditLbl;

@property (strong, nonatomic) IBOutlet UIButton *updateBtn;
@property (strong, nonatomic) IBOutlet UIButton *changePwdBtn;
@property (strong, nonatomic) IBOutlet UIButton *creditCardBtn;
@property (strong, nonatomic) IBOutlet UIButton *signOutBtn;

@property (strong, nonatomic) IBOutlet UIButton *product1Btn;
@property (strong, nonatomic) IBOutlet UIButton *product2Btn;
@property (strong, nonatomic) IBOutlet UIButton *product3Btn;
@property (strong, nonatomic) IBOutlet UIButton *product4Btn;

- (IBAction)changePwdBtnTouchUpInsideHandler:(id)sender;
- (IBAction)saveBtnTouchUpInsideHandler:(id)sender;
- (IBAction)signOutBtnTouchUpInsideHandler:(id)sender;
- (IBAction)creditCardBtnTouchUpInsideHandler:(id)sender;
- (IBAction)freeCreditBtnTouchUpInsideHandler:(id)sender;

- (void)goToSignInView;
- (void)goToChangePasswordView;
- (void) goToCreditCardSettingsView:(NSString *)maskedId;
@end

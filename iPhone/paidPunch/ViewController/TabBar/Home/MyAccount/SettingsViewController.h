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
#import "InfoExpert.h"
#import "AppDelegate.h"
#import "SDImageCache.h"
#import "Reachability.h"
#import "CreditCardSettingsViewController.h"

@interface SettingsViewController : UIViewController<NetworkManagerDelegate,UITextFieldDelegate>
{
    NetworkManager *networkManager;
}
@property (retain, nonatomic) IBOutlet UILabel *usernameLbl;

@property (retain, nonatomic) IBOutlet UITextField *mobileNoTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UILabel *emailLbl;
@property (retain, nonatomic) IBOutlet UILabel *mobileNoLbl;
@property (retain, nonatomic) IBOutlet UIButton *updateBtn;
@property (retain, nonatomic) IBOutlet UIButton *changePwdBtn;
@property (retain, nonatomic) IBOutlet UIButton *creditCardBtn;
@property (retain, nonatomic) IBOutlet UIButton *signOutBtn;
@property (retain, nonatomic) IBOutlet UIImageView *myAccountsBg;

- (IBAction)changePwdBtnTouchUpInsideHandler:(id)sender;
- (IBAction)saveBtnTouchUpInsideHandler:(id)sender;
- (IBAction)signOutBtnTouchUpInsideHandler:(id)sender;
- (IBAction)creditCardBtnTouchUpInsideHandler:(id)sender;

- (void)goToDualSignInView;
- (void)goToChangePasswordView;
- (void) goToCreditCardSettingsView:(NSString *)maskedId;
- (void)requestAppIp;
@end

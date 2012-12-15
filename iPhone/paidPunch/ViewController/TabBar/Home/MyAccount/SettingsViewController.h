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

@interface SettingsViewController : UIViewController<NetworkManagerDelegate,UITextFieldDelegate>
{
    NetworkManager *networkManager;
}
@property (strong, nonatomic) IBOutlet UILabel *usernameLbl;

@property (strong, nonatomic) IBOutlet UITextField *mobileNoTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *emailLbl;
@property (strong, nonatomic) IBOutlet UILabel *mobileNoLbl;
@property (strong, nonatomic) IBOutlet UIButton *updateBtn;
@property (strong, nonatomic) IBOutlet UIButton *changePwdBtn;
@property (strong, nonatomic) IBOutlet UIButton *creditCardBtn;
@property (strong, nonatomic) IBOutlet UIButton *signOutBtn;
@property (strong, nonatomic) IBOutlet UIImageView *myAccountsBg;

- (IBAction)changePwdBtnTouchUpInsideHandler:(id)sender;
- (IBAction)saveBtnTouchUpInsideHandler:(id)sender;
- (IBAction)signOutBtnTouchUpInsideHandler:(id)sender;
- (IBAction)creditCardBtnTouchUpInsideHandler:(id)sender;

- (void)goToDualSignInView;
- (void)goToChangePasswordView;
- (void) goToCreditCardSettingsView:(NSString *)maskedId;
- (void)requestAppIp;
@end

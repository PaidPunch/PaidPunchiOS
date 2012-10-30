//
//  SignInViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaidPunchTabBarController.h"
#import "NetworkManager.h"
#import "InfoExpert.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;

@interface SignInViewController : UIViewController<UITextFieldDelegate,NetworkManagerDelegate>
{
    IBOutlet UITableView *signInTableView;
    NetworkManager  *networkManager;
    
    UITextField *passwordTextField;
    UITextField *usernameTextField;
    UIButton *signInBtn;
    
    NSString *username;
    NSString *password;
}

@property (nonatomic, retain) IBOutlet UITableView *signInTableView;
@property(retain,nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)forgotPasswordTouchUpInsideHandler:(id)sender;
- (IBAction)signInBtnTouchUpInsideHandler:(id)sender;
- (IBAction)signUpBtnTouchUpInsideHandler:(id)sender;

- (void)goToSignUpView;
- (void)goToTabBarView;
- (void)populateFields;
- (BOOL)validate;
- (BOOL)validateEmail: (NSString *) emailId;
- (void)forgotPasswordRequest:(NSString *)emailId;
- (void)requestAppIp;
- (void)loginButtonTouched:(id)sender;

@end

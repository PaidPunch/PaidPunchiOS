//
//  RegistrationViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "CustomTextFieldCell.h"
#import "Registration.h"
#import "DatabaseManager.h"
#import "NetworkManager.h"
#import "TermsAndConditionsViewController.h"

@interface RegistrationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NetworkManagerDelegate,UINavigationBarDelegate>
{
    /*NSString *username;
    NSString *password;
    NSString *confirmPassword;
    NSString *email;
    NSString *mobileNumber;
    NSString *zipcode;*/
    NetworkManager *networkManager;
    int regFlag;
    
    UITextField *usernameTF;
    UITextField *passwordTF;
    UITextField *confirmPasswordTF;
    UITextField *emailTF;
    UITextField *mobileNumberTF;
    UITextField *zipcodeTF;
}
@property (retain, nonatomic) IBOutlet UIButton *registerBtn;

@property (retain, nonatomic) IBOutlet UIButton *agreeBtn;
@property (retain, nonatomic) IBOutlet UITableView *registrationFieldsTableView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)agreeBtnTouchUpInsideHandler:(id)sender;
- (IBAction)continueBtnTouchUpInsideHandler:(id)sender;
- (IBAction)termsAndConditionsTouchUpInsideHandler:(id)sender;

- (BOOL) validate;
- (BOOL) validateEmail: (NSString *) emailId;
- (Registration *)populate;
- (void)dismissKeyboard;

-(void) goToTermsAndConditionsView;

@end

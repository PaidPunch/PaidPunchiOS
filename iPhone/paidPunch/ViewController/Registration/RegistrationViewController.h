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
#import "DatabaseManager.h"
#import "HttpCallbackDelegate.h"
#import "NetworkManager.h"
#import "TermsAndConditionsViewController.h"

@interface RegistrationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NetworkManagerDelegate,UINavigationBarDelegate,HttpCallbackDelegate>
{
    NetworkManager *networkManager;
    
    UITextField *usernameTF;
    UITextField *passwordTF;
    UITextField *confirmPasswordTF;
    UITextField *emailTF;
    UITextField *mobileNumberTF;
    UITextField *zipcodeTF;
}
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong, nonatomic) IBOutlet UITableView *registrationFieldsTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)continueBtnTouchUpInsideHandler:(id)sender;

- (BOOL) validate;
- (BOOL) validateEmail: (NSString *) emailId;
- (void)dismissKeyboard;

@end

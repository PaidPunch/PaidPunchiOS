//
//  ChangePasswordViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "InfoExpert.h"
#import "CustomScrollView.h"

@interface ChangePasswordViewController : UIViewController<NetworkManagerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    NetworkManager *networkManager;
}

@property (retain, nonatomic) IBOutlet UITextField *oldPasswordTextField;

@property (retain, nonatomic) IBOutlet UITextField *nwPasswordTextField;

@property (retain, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property(retain,nonatomic) IBOutlet CustomScrollView *scrollView;

- (IBAction)saveBtnTouchUpInsideHandler:(id)sender;
- (BOOL)validate;
@end

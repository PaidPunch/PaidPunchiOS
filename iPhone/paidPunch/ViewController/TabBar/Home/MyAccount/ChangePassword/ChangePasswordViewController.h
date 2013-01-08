//
//  ChangePasswordViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomScrollView.h"
#import "HttpCallbackDelegate.h"

@interface ChangePasswordViewController : UIViewController<HttpCallbackDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *nwPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property(strong,nonatomic) IBOutlet CustomScrollView *scrollView;

- (IBAction)saveBtnTouchUpInsideHandler:(id)sender;
- (BOOL)validate;
@end

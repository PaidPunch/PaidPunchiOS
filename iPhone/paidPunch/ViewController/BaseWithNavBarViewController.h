//
//  BaseWithNavBarViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/23/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import <UIKit/UIKit.h>

@interface BaseWithNavBarViewController : UIViewController<UITextFieldDelegate>
{
    UIView* _mainView;
    CGFloat _lowestYPos;
    
    // Used in the sign in/up view
    UIScrollView* _scrollview;
    UIButton* _btnFacebook;
    UIButton* _btnEmail;
    UILabel* _orLabel;
    UITextField* _emailTextField;
    UITextField* _passwordTextField;
    
    UILabel* _notificationLabel;
}
@property(nonatomic,strong) UITextField* emailTextField;
@property(nonatomic,strong) UITextField* passwordTextField;
@property(nonatomic) CGFloat lowestYPos;

- (void) dismissKeyboard;
- (void)createMainView:(UIColor*)backgroundColor;
- (void)createNavBar:(NSString*)leftString rightString:(NSString*)rightString middle:(NSString*)middle isMiddleImage:(BOOL)isMiddleImage leftAction:(SEL)leftAction rightAction:(SEL)rightAction;
- (void)createSignInOrUpButtons:(NSString*)currentText fbAction:(SEL)fbAction emailAction:(SEL)emailAction;
- (void)createNotificationBar:(NSString*)barText color:(UIColor*)color;
- (void) createSilverBackgroundWithImage;

@end

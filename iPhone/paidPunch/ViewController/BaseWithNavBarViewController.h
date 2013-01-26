//
//  BaseWithNavBarViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/23/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const stdiPhoneWidth = 320.0;
static CGFloat const stdiPhoneHeight = 480.0;

typedef enum
{
    leftJustify,
    centerJustify,
    rightJustify
} JustificationType;

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
}
@property(nonatomic,strong) UITextField* emailTextField;
@property(nonatomic,strong) UITextField* passwordTextField;
@property(nonatomic) CGFloat lowestYPos;

- (void) dismissKeyboard;
- (void)createNavBar:(NSString*)leftString rightString:(NSString*)rightString middle:(NSString*)middle isMiddleImage:(BOOL)isMiddleImage leftAction:(SEL)leftAction rightAction:(SEL)rightAction;
- (void)createSignInOrUpButtons:(NSString*)currentText fbAction:(SEL)fbAction emailAction:(SEL)emailAction;
- (void)createGreenNotificationBar:(NSString*)barText;

@end

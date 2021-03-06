//
//  WelcomePageViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/22/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomePageViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIView* _mainView;
    NSTimer* _fadeTimer;
    NSArray* _imageFiles;
    NSArray* _businessTypeTexts;
    UILabel* _businessTypeLabel;
    NSUInteger _currentIndex;
    UIView* _imageContainerView;
    UIImageView* _mainImageView;
    UILabel* _greyoutLabel;
    UIButton* _signinButton;
    UIButton* _signupButton;
}

@end

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

@interface BaseWithNavBarViewController : UIViewController
{
    UIView* _mainView;
    CGFloat _navBarHeight;
    CGFloat _notifyBarHeight;
}

- (void)createNavBar:(NSString*)leftString rightString:(NSString*)rightString middle:(NSString*)middle isMiddleImage:(BOOL)isMiddleImage;

@end

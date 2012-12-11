//
//  BaseView.h
//  paidPunch
//
//  Created by Aaron Khoo on 12/9/12.
//  Copyright (c) 2012 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView<UITextFieldDelegate>
{
    UINavigationController* _navigationController;
    UIButton* _btnFacebook;
}
@property (nonatomic,strong) UINavigationController* navigationController;
@property (nonatomic,strong) UIButton* btnFacebook;

- (UITextField*) initializeUITextField:(CGRect)frame placeholder:(NSString*)placeholder font:(UIFont*)font;
- (void) createFacebookButton:(NSString*)text framewidth:(CGFloat)framewidth yPos:(CGFloat)yPos textFont:(UIFont*)textFont action:(SEL)action;

@end

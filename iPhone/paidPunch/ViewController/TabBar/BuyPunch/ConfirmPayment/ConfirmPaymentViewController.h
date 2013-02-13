//
//  ConfirmPaymentViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 21/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CongratulationsViewController.h"
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;

@interface ConfirmPaymentViewController : UIViewController<HttpCallbackDelegate,UIAlertViewDelegate>
{
    MBProgressHUD* _hud;
    NSUInteger _index;
    BOOL _popBackToHome;
}
@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (strong, nonatomic) IBOutlet UILabel *valueLbl;
@property (strong, nonatomic) IBOutlet UILabel *pinLbl;
@property (strong, nonatomic) IBOutlet UILabel *creditCardLbl;

- (id)init:(NSUInteger)index;

- (IBAction)purchaseBtnTouchUpInsideHandler:(id)sender;
- (IBAction)cancelBtnTouchUpInsideHandler:(id)sender;

- (void)setUpUI;
- (void)buy;

@end

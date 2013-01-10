//
//  FreeCreditViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/8/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface FreeCreditViewController : UIViewController<HttpCallbackDelegate, UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{
    UIButton* _btnFacebook;
    UIButton* _btnEmail;
    UIButton* _btnBusiness;
    UILabel* _lblFreeCredit;
    
    MBProgressHUD* _hud;
}
@property (nonatomic,strong) UIButton* btnFacebook;

- (IBAction)goBack:(id)sender;

@end

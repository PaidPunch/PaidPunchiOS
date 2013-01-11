//
//  InfoChangeViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/10/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface InfoChangeViewController : UIViewController<HttpCallbackDelegate,UITextFieldDelegate>
{
    UIScrollView *_scrollview;
    UITextField *_usernameTF;
    UITextField *_mobilenoTF;
    UITextField *_zipcodeTF;
    UIButton *_updateBtn;
    MBProgressHUD* _hud;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)goBack:(id)sender;

@end

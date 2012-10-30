//
//  FAQViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 14/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoExpert.h"
#import "AppDelegate.h"

@interface FAQViewController : UIViewController<UIWebViewDelegate>
{
//    UIView *activityView;
    MBProgressHUD *popupHUD;
}
@property (retain, nonatomic) IBOutlet UIWebView *faqWebView;

- (IBAction)goBack:(id)sender;

@end

//
//  FeedBackViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "InfoExpert.h"

@interface FeedBackViewController : UIViewController<NetworkManagerDelegate,UITextViewDelegate>
{
    NetworkManager *networkManager;
}

@property (retain, nonatomic) IBOutlet UITextView *feedbackTextView;

- (IBAction)submitFeedBackBtnTouchUpInsideHandler:(id)sender;

@end

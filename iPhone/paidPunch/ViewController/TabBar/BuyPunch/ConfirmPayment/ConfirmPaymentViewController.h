//
//  ConfirmPaymentViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 21/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CongratulationsViewController.h"
#import "NetworkManager.h"
#import "InfoExpert.h"
#import "SDWebImageManagerDelegate.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;

@interface ConfirmPaymentViewController : UIViewController<NetworkManagerDelegate,SDWebImageManagerDelegate>
{
    NetworkManager *networkManager;
}
@property (retain, nonatomic) IBOutlet UIImageView *businessLogoImageView;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (retain, nonatomic) IBOutlet UILabel *valueLbl;
@property (retain, nonatomic) IBOutlet UILabel *pinLbl;
@property (retain, nonatomic) IBOutlet UILabel *creditCardLbl;
@property (nonatomic,retain) PunchCard *punchCardDetails;
@property (nonatomic,retain) NSString *maskedId;
@property (nonatomic,retain) NSString *paymentId;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (id)init:(PunchCard *)punchCard withMaskedId:(NSString *)mid withPaymentId:(NSString *)pid;

- (IBAction)purchaseBtnTouchUpInsideHandler:(id)sender;
- (IBAction)cancelBtnTouchUpInsideHandler:(id)sender;

- (void)setUpUI;
- (void)buy;
- (void)goToCongratulationsView;

@end

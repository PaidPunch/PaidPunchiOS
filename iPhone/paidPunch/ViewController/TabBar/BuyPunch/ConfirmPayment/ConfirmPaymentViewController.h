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
@property (strong, nonatomic) IBOutlet UIImageView *businessLogoImageView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (strong, nonatomic) IBOutlet UILabel *valueLbl;
@property (strong, nonatomic) IBOutlet UILabel *pinLbl;
@property (strong, nonatomic) IBOutlet UILabel *creditCardLbl;
@property (nonatomic,strong) PunchCard *punchCardDetails;
@property (nonatomic,strong) NSString *maskedId;
@property (nonatomic,strong) NSString *paymentId;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (id)init:(PunchCard *)punchCard withMaskedId:(NSString *)mid withPaymentId:(NSString *)pid;

- (IBAction)purchaseBtnTouchUpInsideHandler:(id)sender;
- (IBAction)cancelBtnTouchUpInsideHandler:(id)sender;

- (void)setUpUI;
- (void)buy;
- (void)goToCongratulationsView;

@end

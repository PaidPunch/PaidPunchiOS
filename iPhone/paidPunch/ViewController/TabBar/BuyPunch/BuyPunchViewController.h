//
//  BuyPunchViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/15/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CongratulationsViewController.h"
#import "NetworkManager.h"
#import "SDWebImageManagerDelegate.h"

@interface BuyPunchViewController : UIViewController<NetworkManagerDelegate,SDWebImageManagerDelegate>
{
    NetworkManager *networkManager;
}
@property (strong, nonatomic) IBOutlet UIImageView *businessLogoImageView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (strong, nonatomic) IBOutlet UILabel *valueLbl;
@property (strong, nonatomic) IBOutlet UILabel *pinLbl;
@property (strong, nonatomic) IBOutlet UILabel *creditCardLbl;
@property (nonatomic,strong) PunchCard *punchCardDetails;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (id)init:(PunchCard *)punchCard;

- (IBAction)purchaseBtnTouchUpInsideHandler:(id)sender;
- (IBAction)cancelBtnTouchUpInsideHandler:(id)sender;

- (void)setUpUI;
- (void)buy;
- (void)goToCongratulationsView;

@end

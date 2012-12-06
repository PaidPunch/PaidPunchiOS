//
//  PayToCashierViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CongratulationsViewController.h"
#import "NetworkManager.h"
#import "PunchCard.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;

@interface PayToCashierViewController : UIViewController<NetworkManagerDelegate,UITextFieldDelegate>
{
    NSString *offerQrCode;
    PunchCard *punchCardDetails;
    NetworkManager *networkManager;
    UIAlertView *orangeCodeAlert; 
    UITextField *orangeCodeTextField;
    int attempts;
}
@property(nonatomic,strong) NSString *offerQrCode;
@property(nonatomic,strong) NSString *punchId;
@property(nonatomic,strong) NSString *businessName;
@property(nonatomic,strong) PunchCard *punchCardDetails;
@property (strong, nonatomic) IBOutlet UILabel *punchCardValueLbl;
@property (strong, nonatomic) IBOutlet UILabel *punchCardNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *noOfPunchesLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)nextBtnTouchUpInsideHandler:(id)sender;

- (id)init:(NSString *)offerCode punchCardDetailsObj:(PunchCard *)punchCard punchCardId:(NSString *)pid businessName:(NSString *)bName;

- (void)goToCongratulationsView;
- (void)goToScanQRCodeView;
- (void)buy:(NSString *)orangeQrCode;
- (void)setUpUI;
@end

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
@property(nonatomic,retain) NSString *offerQrCode;
@property(nonatomic,retain) NSString *punchId;
@property(nonatomic,retain) NSString *businessName;
@property(nonatomic,retain) PunchCard *punchCardDetails;
@property (retain, nonatomic) IBOutlet UILabel *punchCardValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *punchCardNameLbl;
@property (retain, nonatomic) IBOutlet UILabel *noOfPunchesLbl;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)nextBtnTouchUpInsideHandler:(id)sender;

- (id)init:(NSString *)offerCode punchCardDetailsObj:(PunchCard *)punchCard punchCardId:(NSString *)pid businessName:(NSString *)bName;

- (void)goToCongratulationsView;
- (void)goToScanQRCodeView;
- (void)buy:(NSString *)orangeQrCode;
- (void)setUpUI;
@end

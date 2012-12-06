//
//  BuyPunchViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchByBusinessViewController.h"
//#import <ZXingWidgetController.h>
//#import <QRCodeReader.h>
#import "PunchCardOfferViewController.h"
#import "NetworkManager.h"
#import "PunchCard.h"

@interface BuyPunchViewController : UIViewController<NetworkManagerDelegate>
{
    NSString *qrCode;
    NetworkManager *networkManager;
}

@property(nonatomic,strong)NSString *qrCode;

- (IBAction)searchByQrCodeBtnTouchUpInsideHandler:(id)sender;
- (IBAction)searchByBusinessBtnTouchUpInsideHandler:(id)sender;
- (void)goToScanQRCodeView;
- (void)goToSearchByBusinessView;
- (void)goToPunchCardOfferView:(NSString *)offerQrCode punchCardDetails:(PunchCard *)punchCard;
-(void) getBusinessOffer;
@end

//
//  PunchCardOfferViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "InfoExpert.h"
#import "PunchCard.h"
#import "PayToCashierViewController.h"
#import "PunchesViewCell.h"
#import "AddCardViewController.h"
#import "ConfirmPurchaseView.h"
#import "ConfirmPaymentViewController.h"
#import "Reachability.h"
#import "BusinessLocatorViewController.h"
#import "SDWebImageManagerDelegate.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;

@interface PunchCardOfferViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FBRequestDelegate,FBDialogDelegate,NetworkManagerDelegate,SDWebImageManagerDelegate>
{
    NSString *qrCode;
    PunchCard *punchCardDetails;
    int rowCnt;
    NetworkManager *networkManager;
    bool isFreePunch;
    int cnt;
    
}
@property (retain, nonatomic) IBOutlet UIScrollView *contentsScrollView;
@property (retain, nonatomic) IBOutlet UILabel *freePunchLbl;
@property (retain, nonatomic) IBOutlet UIImageView *buisnesslogoImageView;
@property(nonatomic,retain) PunchCard *punchCardDetails;
@property(nonatomic,retain) NSString *qrCode;

@property (retain, nonatomic) IBOutlet UILabel *expiryLbl;
@property (nonatomic, retain) IBOutlet UIWebView *finePrintView;
@property (nonatomic, retain) UIImageView *finePrintDivider;

@property (retain, nonatomic) IBOutlet UILabel *punchCardNameLbl;
@property (nonatomic, retain) IBOutlet UIWebView *payValueView;
@property (nonatomic, retain) IBOutlet UIWebView *getValueView;
@property (nonatomic, retain) IBOutlet UILabel *totalValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *savingsValueLabel;
@property (nonatomic, retain) IBOutlet UILabel *punchCardContentsLabel;
@property (nonatomic, retain) IBOutlet UIWebView *punchCardContentsView;
@property (nonatomic, retain) IBOutlet UIImageView *punchCardContentsBG;

@property (retain, nonatomic) IBOutlet UITableView *punchesListTableView;
@property (retain, nonatomic) IBOutlet UIButton *getFreePunchBtn;
@property (retain, nonatomic) IBOutlet UIImageView *lockImageView;
@property (retain, nonatomic) IBOutlet UIView *cardView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)buyBtnTouchUpInsideHandler:(id)sender;
- (IBAction)getFreePunchBtnTouchUpInsideHandler:(id)sender;
- (IBAction)goBack:(id)sender;

- (id)init:(NSString *)offerCode punchCardDetails:(PunchCard *)punchCard;
- (void)goToPayToCashierView;
- (void)setUpUI;
- (void)shareOnFacebook;
- (void)buy:(NSString *)orangeQrCode isFreePunch:(BOOL)unlockedFreePunch;
- (void)goToCongratulationsView;
- (void)goToAddCardView;
- (void)goToConfirmPurchaseView;
- (void)goToConfirmPaymentView:(NSString *)paymentId withMaskedId:(NSString *)maskedId;
- (void)setUpConfirmPurchaseUI:(ConfirmPurchaseView *)cview;
- (void)loggedIn;
- (void)goToMapView;

@end

//
//  PunchCardOfferViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
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
@property (strong, nonatomic) IBOutlet UIScrollView *contentsScrollView;
@property (strong, nonatomic) IBOutlet UILabel *freePunchLbl;
@property (strong, nonatomic) IBOutlet UIImageView *buisnesslogoImageView;
@property(nonatomic,strong) PunchCard *punchCardDetails;
@property(nonatomic,strong) NSString *qrCode;

@property (strong, nonatomic) IBOutlet UILabel *expiryLbl;
@property (nonatomic, strong) IBOutlet UIWebView *finePrintView;
@property (nonatomic, strong) UIImageView *finePrintDivider;

@property (strong, nonatomic) IBOutlet UILabel *punchCardNameLbl;
@property (nonatomic, strong) IBOutlet UIWebView *payValueView;
@property (nonatomic, strong) IBOutlet UIWebView *getValueView;
@property (nonatomic, strong) IBOutlet UILabel *totalValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *savingsValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *punchCardContentsLabel;
@property (nonatomic, strong) IBOutlet UIWebView *punchCardContentsView;
@property (nonatomic, strong) IBOutlet UIImageView *punchCardContentsBG;

@property (strong, nonatomic) IBOutlet UITableView *punchesListTableView;
@property (strong, nonatomic) IBOutlet UIButton *getFreePunchBtn;
@property (strong, nonatomic) IBOutlet UIImageView *lockImageView;
@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

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

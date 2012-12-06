//
//  PunchViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 01/12/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "PunchCard.h"
#import "InfoExpert.h"
#import "PunchUsedViewController.h"
#import "PunchesViewCell.h"
#import "DatabaseManager.h"
#import "UILabelStrikethrough.h"
#import "SDWebImageManager.h"
#import "SDWebImageManagerDelegate.h"
#import "SlideToConfirmDialog.h"
#import "MarqueeLabel.h"

@class NetworkManager;
@protocol NetworkManagerDelegate;

@interface PunchViewController : UIViewController<NetworkManagerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,SDWebImageManagerDelegate>
{
    PunchCard *punchCardDetails;
    int rowCnt;
    int usedCnt;
    NetworkManager *networkManager;
    UIAlertView *passwordAlert; 
    UITextField *passwordTextField;
    UIActivityIndicatorView *activityIndicator;
}
@property (strong, nonatomic) IBOutlet UILabel *punchDiscountValueLbl;
@property(nonatomic,copy) NSString *punchId;
@property(nonatomic,strong) PunchCard *punchCardDetails;
@property(strong,nonatomic) IBOutlet UIImageView *buisnesslogoImageView;
@property(strong,nonatomic) IBOutlet UITableView *punchesListTableView;
@property (nonatomic, strong) MarqueeLabel *businessNameMarqueeLabel;
@property(nonatomic,strong) IBOutlet UILabelStrikethrough *eachPunchValueLbl;
@property(nonatomic,strong) IBOutlet UILabel *remainingPunchesLbl;
@property(nonatomic, strong) IBOutlet UILabel *remainingMysterPunchesLbl;
//@property(nonatomic,retain) IBOutlet UILabel *usedPunchesLbl;
@property(nonatomic,strong) IBOutlet UILabel *expiryLbl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIImageView *usingPunchesInstructionsImage;
@property (nonatomic, strong) IBOutlet UIButton *doneUsingPunchesInstructionsButton;

- (IBAction)doneWithUsingPunchesInstructions:(id)sender;

- (IBAction)punchBtnTouchUpInsideHandler:(id)sender;
- (IBAction)goBack:(id)sender;
- (void) goToPunchUsedView:(PunchCard *)punchCard barcodeImage:(NSData *)imageData barcodeValue:(NSString *)barcode;
- (void)setUpUI;
- (void)goToConfirmView:(NSString *)moffer;

@end

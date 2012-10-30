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
@property (retain, nonatomic) IBOutlet UILabel *punchDiscountValueLbl;
@property(nonatomic,assign) NSString *punchId;
@property(nonatomic,retain) PunchCard *punchCardDetails;
@property(retain,nonatomic) IBOutlet UIImageView *buisnesslogoImageView;
@property(retain,nonatomic) IBOutlet UITableView *punchesListTableView;
@property (nonatomic, retain) MarqueeLabel *businessNameMarqueeLabel;
@property(nonatomic,retain) IBOutlet UILabelStrikethrough *eachPunchValueLbl;
@property(nonatomic,retain) IBOutlet UILabel *remainingPunchesLbl;
@property(nonatomic, retain) IBOutlet UILabel *remainingMysterPunchesLbl;
//@property(nonatomic,retain) IBOutlet UILabel *usedPunchesLbl;
@property(nonatomic,retain) IBOutlet UILabel *expiryLbl;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *usingPunchesInstructionsImage;
@property (nonatomic, retain) IBOutlet UIButton *doneUsingPunchesInstructionsButton;

- (IBAction)doneWithUsingPunchesInstructions:(id)sender;

- (IBAction)punchBtnTouchUpInsideHandler:(id)sender;
- (IBAction)goBack:(id)sender;
- (void) goToPunchUsedView:(PunchCard *)punchCard barcodeImage:(NSData *)imageData barcodeValue:(NSString *)barcode;
- (void)setUpUI;
- (void)goToConfirmView:(NSString *)moffer;

@end

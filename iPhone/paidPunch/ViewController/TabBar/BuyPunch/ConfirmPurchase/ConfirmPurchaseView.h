//
//  ConfirmPurchaseView.h
//  paidPunch
//
//  Created by mobimedia technologies on 21/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPurchaseView : UIView

@property (strong, nonatomic) IBOutlet UILabel *totalSavingsLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalSavingsValueLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalCostOfPunchesLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalCostOfPunchesValueLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalRedeemablePunchesValueLbl;
@property (strong, nonatomic) IBOutlet UILabel *totalCostOfRedeemablePunches;
@property (strong, nonatomic) IBOutlet UIButton *payBtn;
@property (strong, nonatomic) IBOutlet UILabel *expiryDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *minimumPurchaseLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeDiffLbl;

- (IBAction)payBtnTouchUpInsideHandler:(id)sender;
- (IBAction)cancelBtnTouchUpInsideHandler:(id)sender;


@end

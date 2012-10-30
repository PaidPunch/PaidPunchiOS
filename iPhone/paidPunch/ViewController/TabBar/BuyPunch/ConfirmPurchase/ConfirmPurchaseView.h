//
//  ConfirmPurchaseView.h
//  paidPunch
//
//  Created by mobimedia technologies on 21/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPurchaseView : UIView

@property (retain, nonatomic) IBOutlet UILabel *totalSavingsLbl;
@property (retain, nonatomic) IBOutlet UILabel *totalSavingsValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *totalCostOfPunchesLbl;
@property (retain, nonatomic) IBOutlet UILabel *totalCostOfPunchesValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *totalRedeemablePunchesValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *totalCostOfRedeemablePunches;
@property (retain, nonatomic) IBOutlet UIButton *payBtn;
@property (retain, nonatomic) IBOutlet UILabel *expiryDateLbl;
@property (retain, nonatomic) IBOutlet UILabel *minimumPurchaseLbl;
@property (retain, nonatomic) IBOutlet UILabel *timeDiffLbl;

- (IBAction)payBtnTouchUpInsideHandler:(id)sender;
- (IBAction)cancelBtnTouchUpInsideHandler:(id)sender;


@end

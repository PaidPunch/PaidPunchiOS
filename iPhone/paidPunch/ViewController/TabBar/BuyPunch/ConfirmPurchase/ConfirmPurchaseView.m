//
//  ConfirmPurchaseView.m
//  paidPunch
//
//  Created by mobimedia technologies on 21/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "ConfirmPurchaseView.h"

@implementation ConfirmPurchaseView
@synthesize totalSavingsLbl;
@synthesize totalSavingsValueLbl;
@synthesize totalCostOfPunchesLbl;
@synthesize totalCostOfPunchesValueLbl;
@synthesize totalRedeemablePunchesValueLbl;
@synthesize totalCostOfRedeemablePunches;
@synthesize payBtn;
@synthesize expiryDateLbl;
@synthesize minimumPurchaseLbl;
@synthesize timeDiffLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    [totalSavingsLbl release];
    [totalSavingsValueLbl release];
    [totalCostOfPunchesLbl release];
    [totalCostOfPunchesValueLbl release];
    [totalRedeemablePunchesValueLbl release];
    [totalCostOfRedeemablePunches release];
    [payBtn release];
    [expiryDateLbl release];
    [minimumPurchaseLbl release];
    [timeDiffLbl release];
    [super dealloc];
}

#pragma mark -

- (IBAction)payBtnTouchUpInsideHandler:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)cancelBtnTouchUpInsideHandler:(id)sender {
    [self removeFromSuperview];
}
@end

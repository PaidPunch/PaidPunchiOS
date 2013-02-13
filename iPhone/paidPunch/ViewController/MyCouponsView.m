//
//  MyCouponsView.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/1/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "MyCouponsView.h"
#import "Punches.h"

@implementation MyCouponsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _lowestYPos = 0;
        
        [self createMyCouponsLabel];
        
        if ([[Punches getInstance] needsRefresh])
        {
            _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            _hud.labelText = @"Retrieving Coupons";
            
            [[DatabaseManager sharedInstance] deleteMyPunches];
            [self getMyPunches];
        }
        else
        {
            [self createCouponsTable];
        }
    }
    return self;
}

#pragma mark - private functions

- (void)createMyCouponsLabel
{
    CGFloat myCouponsLabelHeight = 30;
    UILabel* myCouponsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _popupView.frame.size.width, myCouponsLabelHeight)];
    myCouponsLabel.text = @"My Coupons";
    [myCouponsLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17.0f]];
    [myCouponsLabel setTextAlignment:UITextAlignmentCenter];
    [myCouponsLabel setBackgroundColor:[UIColor blackColor]];
    [myCouponsLabel setTextColor:[UIColor whiteColor]];
    [_popupView addSubview:myCouponsLabel];
    _lowestYPos = myCouponsLabelHeight;
}

- (void)createCouponsTable
{
    if ([[[Punches getInstance] validPunchesArray] count] > 0)
    {
        // create a scrollview
        CGRect myCouponsRect = CGRectMake(0, _lowestYPos, _popupView.frame.size.width, _popupView.frame.size.height - _lowestYPos);
        _myCouponsScrollView = [[UIScrollView alloc] initWithFrame:myCouponsRect];
        _myCouponsScrollView.backgroundColor = [UIColor clearColor];
        [_myCouponsScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        _myCouponsScrollView.scrollEnabled = FALSE;
        [_popupView addSubview:_myCouponsScrollView];
        
        _myCouponsTable = [[MyCouponsTableView alloc] initWithFrame:CGRectMake(0, 0, _popupView.frame.size.width, _popupView.frame.size.height)];
        [_myCouponsScrollView addSubview:_myCouponsTable];
        
        _myCouponsScrollView.contentSize = _myCouponsTable.contentSize;
    }
    else
    {
        // Handle the case where there are no punches
        UILabel* noCouponLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos, _popupView.frame.size.width, 50)];
        [noCouponLabel setBackgroundColor:[UIColor clearColor]];
        [noCouponLabel setText:@"No Current Coupons"];
        [noCouponLabel setTextAlignment:UITextAlignmentCenter];
        [_popupView addSubview:noCouponLabel];
    }
}

-(void)getMyPunches
{
    [[Punches getInstance] retrievePunchesFromServer:self];
}

#pragma mark - network manager delegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{
    [MBProgressHUD hideHUDForView:self animated:NO];
    
    if(success)
    {
        [self createCouponsTable];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end

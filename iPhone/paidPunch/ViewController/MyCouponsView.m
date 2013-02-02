//
//  MyCouponsView.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/1/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "MyCouponsView.h"

@implementation MyCouponsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _lowestYPos = 0;
        
        [self createMyCouponsLabel];
        
        [self createCouponsTable];
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
    // create a scrollview
    CGRect myCouponsRect = CGRectMake(0, _lowestYPos, _popupView.frame.size.width, _popupView.frame.size.height - _lowestYPos);
    _myCouponsScrollView = [[UIScrollView alloc] initWithFrame:myCouponsRect];
    _myCouponsScrollView.backgroundColor = [UIColor clearColor];
    [_myCouponsScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
	_myCouponsScrollView.scrollEnabled = FALSE;
    _myCouponsScrollView.contentSize = CGSizeMake(_popupView.frame.size.width, stdiPhoneHeight);
    [_popupView addSubview:_myCouponsScrollView];
    
    _myCouponsTable = [[MyCouponsTableView alloc] initWithFrame:myCouponsRect];
    [_myCouponsScrollView addSubview:_myCouponsTable];
}

@end

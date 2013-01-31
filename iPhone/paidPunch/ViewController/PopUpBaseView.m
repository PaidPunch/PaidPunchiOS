//
//  PopUpBaseView.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/30/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import <QuartzCore/QuartzCore.h>
#import "PopUpBaseView.h"

@implementation PopUpBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createPopUpView];
    }
    return self;
}

#pragma mark - private functions

- (void) createPopUpView
{
    // Create gesture recognizers to handle tap-to-dismiss when inviteView is up
    _dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    // create a scrollview
    CGRect scrollRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    _scrollview = [[UIScrollView alloc] initWithFrame:scrollRect];
    _scrollview.backgroundColor = [UIColor clearColor];
    [_scrollview setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
	_scrollview.scrollEnabled = FALSE;
    _scrollview.contentSize = CGSizeMake(stdiPhoneWidth, stdiPhoneHeight);
    [self addSubview:_scrollview];
    
    // Create invisible label layer
    _greyoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight)];
    _greyoutLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.70];
    _greyoutLabel.enabled = TRUE;
    [_greyoutLabel addGestureRecognizer:_dismissTap];
    [_greyoutLabel setUserInteractionEnabled:TRUE];
    [_scrollview addSubview:_greyoutLabel];
    
    // Create invite view popup frame
    CGFloat popupViewWidth = stdiPhoneWidth - 40;
    CGFloat popupViewHeight = stdiPhoneHeight - 160;
    CGRect popupRect = CGRectMake((stdiPhoneWidth - popupViewWidth)/2, (stdiPhoneHeight - popupViewHeight)/2, popupViewWidth, popupViewHeight);
    _popupView = [[UIView alloc] initWithFrame:popupRect];
    _popupView.backgroundColor = [UIColor whiteColor];
    _popupView.layer.cornerRadius = 5;
    _popupView.layer.masksToBounds = NO;
    _popupView.layer.shadowOffset = CGSizeMake(-10, 10);
    _popupView.layer.shadowRadius = 5;
    _popupView.layer.shadowOpacity = 0.5;
    [_scrollview addSubview:_popupView];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self removeFromSuperview];
}

@end

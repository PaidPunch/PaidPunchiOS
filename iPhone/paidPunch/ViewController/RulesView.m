//
//  RulesView.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#include "CommonDefinitions.h"
#import "RulesView.h"
#import "Utilities.h"

static CGFloat const kRowHeight = 40;
static CGFloat const kFinalPurchaseRulesRowHeight = 125;
static CGFloat const kOrangeBoxWidth = 60;
static NSUInteger const kRowCount = 4;

@implementation RulesView

- (id)initWithPunchcard:(CGRect)frame current:(PunchCard *)current purchaseRules:(BOOL)purchaseRules 
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _punchcard = current;
        // The rules can be for purchase or usage. The display to the user is slight different in either case
        _purchaseRules = purchaseRules;
        
        CGFloat totalHeight;
        if (_purchaseRules)
        {
            totalHeight = (kRowHeight * (kRowCount - 1)) + kFinalPurchaseRulesRowHeight + 100;
        }
        else
        {
            totalHeight = kRowHeight * kRowCount + 50;
        }
        
        _rulesScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_rulesScroller];
        
        _rulesList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _rulesScroller.frame.size.width, totalHeight)];
        [_rulesScroller setContentSize:_rulesList.frame.size];
        _rulesList.dataSource = self;
        _rulesList.delegate = self;
        _rulesList.rowHeight = kRowHeight;
        [_rulesScroller addSubview:_rulesList];
    }
    return self;
}

- (UILabel*)createWhiteBox:(NSString*)boxText
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    UILabel* box = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kOrangeBoxWidth, kRowHeight)];
    [box setText:boxText];
    [box setTextColor:[UIColor blackColor]];
    [box setBackgroundColor:[UIColor whiteColor]];
    [box setFont:textFont];
    [box setTextAlignment:UITextAlignmentCenter];
    
    return box;
}

- (UILabel*)createWhiteLabel:(NSString*)explainText
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    UILabel* newLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOrangeBoxWidth, 0, stdiPhoneWidth - kOrangeBoxWidth, kRowHeight)];
    [newLabel setText:explainText];
    [newLabel setTextColor:[UIColor blackColor]];
    [newLabel setBackgroundColor:[UIColor whiteColor]];
    [newLabel setFont:textFont];
    [newLabel setTextAlignment:UITextAlignmentLeft];
    return newLabel;
}

#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RuleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel* whiteBox;
    UILabel* whiteLabel;
    if (indexPath.row == 0)
    {
        if (_purchaseRules)
        {
            whiteBox = [self createWhiteBox:@"1"];
            whiteLabel = [self createWhiteLabel:@"  Coupon"];
            [cell addSubview:whiteBox];
            [cell addSubview:whiteLabel];
        }
        else
        {
            NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd-yyyy"];
            NSString* expireDaysString = [NSString stringWithFormat:@"Coupons Expire: %@", [dateFormat stringFromDate:[_punchcard expiry_date]]];
            UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:16.0];
            whiteBox = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, stdiPhoneWidth, kRowHeight)];
            [whiteBox setText:expireDaysString];
            [whiteBox setTextColor:[UIColor blackColor]];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            [whiteBox setFont:textFont];
            [whiteBox setTextAlignment:UITextAlignmentCenter];
            [cell addSubview:whiteBox];
        }
    }
    else if (indexPath.row == 1)
    {
        NSString *amountAsString = [Utilities currencyAsString:[_punchcard minimum_value]];
        whiteBox = [self createWhiteBox:amountAsString];
        whiteLabel = [self createWhiteLabel:@"  Minimum spend to use each coupon"];
        [cell addSubview:whiteBox];
        [cell addSubview:whiteLabel];
    }
    else if (indexPath.row == 2)
    {
        whiteBox = [self createWhiteBox:[_punchcard redeem_time_diff]];
        whiteLabel = [self createWhiteLabel:@"  Minutes between each coupon use"];
        [cell addSubview:whiteBox];
        [cell addSubview:whiteLabel];
    }
    else
    {
        UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:13.0];
        if (_purchaseRules)
        {
            whiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, stdiPhoneWidth - 10, kFinalPurchaseRulesRowHeight)];
            [whiteLabel setText:[NSString stringWithFormat:@"You are purchasing a set of coupons. The Promotional Value of the coupons will expire in %d days. The PaidPunch coupon applies to the total guest check before tips and taxes. Discount applies only to orders placed during the valid time period of the PaidPunch offer. Only one PaidPunch coupon may be redeemed per guest check.", [[_punchcard expire_days] intValue]]];
            [whiteLabel setNumberOfLines:0];
        }
        else
        {
            whiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, stdiPhoneWidth - 10, kRowHeight)];
            [whiteLabel setText:@"Cannot be used in combination with other coupons or discounts."];
            [whiteLabel setNumberOfLines:2];
        }
        [whiteLabel setTextColor:[UIColor blackColor]];
        [whiteLabel setBackgroundColor:[UIColor whiteColor]];
        [whiteLabel setFont:textFont];
        [whiteLabel setAdjustsFontSizeToFitWidth:YES];
        [whiteLabel setTextAlignment:UITextAlignmentLeft];
        [cell addSubview:whiteLabel];
    }
    
   	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == (kRowCount - 1) && _purchaseRules)
    {
        return kFinalPurchaseRulesRowHeight;
    }
    else
    {
        return tableView.rowHeight;
    }
}

@end

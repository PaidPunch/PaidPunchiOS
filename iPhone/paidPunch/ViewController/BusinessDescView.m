//
//  BusinessDescView.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <QuartzCore/CAGradientLayer.h>
#include "CommonDefinitions.h"
#import "AppDelegate.h"
#import "BalanceViewController.h"
#import "BusinessDescView.h"
#import "PunchCard.h"
#import "Punches.h"
#import "PunchPurchaseCompleteViewController.h"
#import "RulesView.h"
#import "UrlImage.h"
#import "UrlImageManager.h"
#import "Utilities.h"

static CGFloat const kImageHeight = 150;
static CGFloat const kLabelHeight = 40;

@implementation BusinessDescView

- (id)initWithFrameAndBusiness:(CGRect)frame business:(Business*)business punchcard:(PunchCard*)punchcard
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _business = business;
        _punchcard = punchcard;
        [self createBackgroundImage];
        [self createBusinessDescriptionLabel];
        [self createInfoLabels];
        [self createBuyCouponButton];
        [self createRulesBar];
        
        RulesView* rulesView = [[RulesView alloc] initWithPunchcard:CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos) current:_punchcard purchaseRules:TRUE];
        [self addSubview:rulesView];
    }
    return self;
}

#pragma mark - private functions

- (void)createBackgroundImage
{
    UIImageView* bizImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, stdiPhoneWidth, kImageHeight)];
    bizImageView.backgroundColor = [UIColor blackColor];
    UrlImage* urlImage = [[UrlImageManager getInstance] getCachedImage:[_punchcard business_logo_url]];
    if(urlImage)
    {
        if (urlImage.image)
        {
            [bizImageView setImage:[urlImage image]];
        }
        else
        {
            [urlImage addImageView:bizImageView];
        }
    }
    else
    {
        UrlImage* urlImage = [[UrlImage alloc] initWithUrl:[_punchcard business_logo_url] forImageView:bizImageView];
        [[UrlImageManager getInstance] insertImageToCache:[_punchcard business_logo_url] image:urlImage];
    }
    [self addSubview:bizImageView];
    
    _lowestYPos = kImageHeight;
}

- (void)createBusinessDescriptionLabel
{
    CGFloat labelHeight = 50;
    UILabel* descBackgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, stdiPhoneWidth, labelHeight)];
    descBackgroundLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    CGFloat textlabelHeight = labelHeight - 10;
    CGFloat textlabelWidth = stdiPhoneWidth - 20;
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    UILabel* descLabel = [[UILabel alloc] initWithFrame:CGRectMake((stdiPhoneWidth - textlabelWidth)/2, (descBackgroundLabel.frame.size.height - textlabelHeight)/2, textlabelWidth , textlabelHeight)];
    [descLabel setFont:textFont];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.text = [_punchcard punch_card_desc];
    descLabel.textColor = [UIColor whiteColor];
    [descLabel setNumberOfLines:2];
    [descLabel setAdjustsFontSizeToFitWidth:TRUE];
    [descLabel setFont:textFont];
    descLabel.textAlignment = UITextAlignmentCenter;
    
    [self addSubview:descBackgroundLabel];
    [self addSubview:descLabel];
}

- (void)createInfoLabels
{
    CGFloat leftLabelWidth = (stdiPhoneWidth/5) * 3;
    CGFloat rightLabelWidth = (stdiPhoneWidth/5) * 2;
    
    // Create left label
    NSString *amountAsString = [Utilities currencyAsString:[NSNumber numberWithFloat:[[_punchcard each_punch_value] doubleValue]]];
    
    NSString* numPunchesText = [NSString stringWithFormat:@"%d x %@ Coupons", [[_punchcard total_punches] integerValue], amountAsString];
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    UILabel* numPunchesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kImageHeight, leftLabelWidth, kLabelHeight)];
    [numPunchesLabel setFont:textFont];
    numPunchesLabel.backgroundColor = [UIColor whiteColor];
    numPunchesLabel.text = numPunchesText;
    numPunchesLabel.textColor = [UIColor blackColor];
    [numPunchesLabel setNumberOfLines:1];
    [numPunchesLabel setFont:textFont];
    numPunchesLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:numPunchesLabel];
    
    // Create right label
    NSString *totalAmountAsString = [Utilities currencyAsString:[NSNumber numberWithFloat:([[_punchcard each_punch_value] doubleValue] * [[_punchcard total_punches] integerValue])]];
    
    NSString* totalAmountText = [NSString stringWithFormat:@"%@ value", totalAmountAsString];
    UILabel* totalAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabelWidth, kImageHeight, rightLabelWidth, kLabelHeight)];
    [totalAmountLabel setFont:textFont];
    totalAmountLabel.backgroundColor = [UIColor orangeColor];
    totalAmountLabel.text = totalAmountText;
    totalAmountLabel.textColor = [UIColor whiteColor];
    [totalAmountLabel setNumberOfLines:1];
    [totalAmountLabel setFont:textFont];
    totalAmountLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:totalAmountLabel];
    
    _lowestYPos =  _lowestYPos + kLabelHeight;
}

- (void)createBuyCouponButton
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
    NSString* couponText = [NSString stringWithFormat:@"Buy now for only %@", [Utilities currencyAsString:[NSNumber numberWithFloat:[[_punchcard selling_price] doubleValue]]]];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"large-green-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 60) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    finalRect.origin.y = _lowestYPos + 10;
    
    buyButton.frame = finalRect;
    [buyButton setBackgroundImage:image forState:UIControlStateNormal];
    [buyButton setTitle:couponText forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = textFont;
    [buyButton.titleLabel setAdjustsFontSizeToFitWidth:TRUE];
    [buyButton addTarget:self action:@selector(didPressBuyCouponButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:buyButton];
    
    _lowestYPos = buyButton.frame.origin.y + buyButton.frame.size.height;
}

- (void)createRulesBar
{
    CGFloat barHeight = 20;
    UILabel* rulesBar = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos + 10, stdiPhoneWidth, barHeight)];
    rulesBar.backgroundColor = [UIColor whiteColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = rulesBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f] CGColor],
                       (id)[[UIColor whiteColor] CGColor], nil];
    gradient.startPoint = CGPointMake(0.5f, 0.5f);
    gradient.endPoint = CGPointMake(0.5f, 0.0f);
    [rulesBar.layer addSublayer:gradient];
    [self addSubview:rulesBar];
    
    NSString* rulesText = @"Rules";
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:16.0];
    CGSize sizeRules = [rulesText sizeWithFont:textFont
                             constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                 lineBreakMode:UILineBreakModeWordWrap];
    CGFloat textYPos = (rulesBar.frame.size.height - sizeRules.height)/2;
    UILabel* rulesLabel = [[UILabel alloc] initWithFrame:CGRectMake((stdiPhoneWidth - sizeRules.width)/2, textYPos, sizeRules.width, sizeRules.height)];
    rulesLabel.backgroundColor = [UIColor clearColor];
    rulesLabel.text = rulesText;
    rulesLabel.textColor = [UIColor blackColor];
    [rulesLabel setNumberOfLines:1];
    [rulesLabel setFont:textFont];
    rulesLabel.textAlignment = UITextAlignmentCenter;
    [rulesBar addSubview:rulesLabel];
    
    _lowestYPos = barHeight + rulesBar.frame.origin.y;
}

- (void)completeCouponPurchase
{
    PunchPurchaseCompleteViewController* purchaseCompleteView = [[PunchPurchaseCompleteViewController alloc] init];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate navigationController] pushViewController:purchaseCompleteView animated:NO];
}

- (void)getMoreCredits
{
    BalanceViewController* balanceView = [[BalanceViewController alloc] init];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate navigationController] pushViewController:balanceView animated:NO];
}

#pragma mark - event actions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == _confirmPurchaseAlert && buttonIndex == 0)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _hud.labelText = @"Purchasing Coupon";
        
        [[Punches getInstance] purchasePunchWithCredit:self punchid:_punchcard.punch_card_id];
    }
    else if (alertView == _notEnoughCreditsAlert && buttonIndex == 0)
    {
        [self getMoreCredits];
    }
    else
    {
        NSLog(@"Unknown alert pressed");
    }
}

- (void) didPressBuyCouponButton:(id)sender
{
    double credits = [[[User getInstance] credits] doubleValue];
    if (credits < [_punchcard.selling_price doubleValue])
    {
        // Not enough credits to purchase
        _notEnoughCreditsAlert = [[UIAlertView alloc] initWithTitle:@"Insufficient Credits"
                                                          message:@"You don't have enough credits. Would you like to add more credits to your account?"
                                                         delegate:self
                                                cancelButtonTitle:@"YES"
                                                otherButtonTitles:@"Cancel",nil];
        
        [_notEnoughCreditsAlert show];
    }
    else
    {
        NSString* confirmString = [NSString stringWithFormat:@"This transaction will deduct $%.2f from your credit balance. Continue?", [_punchcard.selling_price doubleValue]];
        _confirmPurchaseAlert = [[UIAlertView alloc] initWithTitle:@"Confirm Purchase"
                                                          message:confirmString
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:@"Cancel",nil];
        
        [_confirmPurchaseAlert show];
    }
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{
    [MBProgressHUD hideHUDForView:self animated:NO];
    if ([type compare:kKeyPunchesPurchase] == NSOrderedSame)
    {
        if(success)
        {
            [self completeCouponPurchase];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

@end

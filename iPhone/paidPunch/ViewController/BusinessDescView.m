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
#import "BusinessDescView.h"
#import "PunchCard.h"
#import "PunchPurchaseCompleteViewController.h"
#import "RulesView.h"
#import "UrlImage.h"
#import "UrlImageManager.h"
#import "Utilities.h"

static CGFloat const kImageHeight = 120;
static CGFloat const kLabelHeight = 40;

@implementation BusinessDescView

- (id)initWithFrameAndBusiness:(CGRect)frame business:(Business*)business
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _business = business;
        [self createBackgroundImage];
        [self createBusinessDescriptionLabel];
        [self createInfoLabels];
        [self createBuyCouponButton];
        [self createRulesBar];
        
        RulesView* rulesView = [[RulesView alloc] initWithPunchcard:CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos) current:_business.punchCard purchaseRules:TRUE];
        [self addSubview:rulesView];
    }
    return self;
}

#pragma mark - private functions

- (void)createBackgroundImage
{
    UIImageView* bizImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, stdiPhoneWidth, kImageHeight)];
    bizImageView.backgroundColor = [UIColor blackColor];
    UrlImage* urlImage = [[UrlImageManager getInstance] getCachedImage:[[_business punchCard] business_logo_url]];
    if(urlImage)
    {
        if (urlImage.image)
        {
            [bizImageView setImage:[urlImage image]];
        }
        else
        {
            // HACK: There is a situation where the image might be loading when it is requested from
            //       UrlImageManager. This needs to be fixed inside UrlImageManager itself.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
            UrlImage* urlImage = [[UrlImage alloc] initWithUrl:[[_business punchCard] business_logo_url] forImageView:bizImageView];
#pragma clang diagnostic pop
        }
    }
    else
    {
        UrlImage* urlImage = [[UrlImage alloc] initWithUrl:[[_business punchCard] business_logo_url] forImageView:bizImageView];
        [[UrlImageManager getInstance] insertImageToCache:[[_business punchCard] business_logo_url] image:urlImage];
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
    descLabel.text = [[_business punchCard] punch_card_desc];
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
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *amountAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[_business.punchCard each_punch_value] doubleValue]]];
    
    NSString* numPunchesText = [NSString stringWithFormat:@"%d x %@ Coupons", [[_business.punchCard total_punches] integerValue], amountAsString];
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
    NSString *totalAmountAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:([[_business.punchCard each_punch_value] doubleValue] * [[_business.punchCard total_punches] integerValue])]];
    
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
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString* couponText = [NSString stringWithFormat:@"Buy now for only %@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[_business.punchCard selling_price] doubleValue]]]];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"green-suggest-button" ofType:@"png"];
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

#pragma mark - event actions

- (void) didPressBuyCouponButton:(id)sender
{
    PunchPurchaseCompleteViewController* purchaseCompleteView = [[PunchPurchaseCompleteViewController alloc] init];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate navigationController] pushViewController:purchaseCompleteView animated:NO];
}

@end

//
//  MyCouponViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import <QuartzCore/CAGradientLayer.h>
#import "MyCouponViewController.h"
#import "RulesView.h"
#import "UrlImageManager.h"
#import "Utilities.h"

static CGFloat const kImageHeight = 200;
static CGFloat const barHeight = 30;

@interface MyCouponViewController ()
{
    PunchCard* _punchcard;
}
@end

@implementation MyCouponViewController

- (id)initWithPunchcard:(PunchCard *)current
{
    self = [super init];
    if (self)
    {
        _punchcard = current;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createMainView:[UIColor whiteColor]];
    
    // Create nav bar on top
    UIFont* middleFont = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
    [self createNavBar:@"Back" rightString:@"Business" middle:[_punchcard business_name] middleFont:middleFont isMiddleImage:FALSE leftAction:nil rightAction:@selector(didPressBusinessButton:)];
    
    [self createRemainingAmountBar];
    
    [self createBackgroundImage];
    
    [self createNumPunchesLabel];
    
    [self createUseCouponButton];
    
    [self createRulesBar];
    
    RulesView* rulesView = [[RulesView alloc] initWithPunchcard:CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos) current:_punchcard];
    [_mainView addSubview:rulesView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (UILabel*)createSilverBar
{
    UILabel* silverbar = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos, stdiPhoneWidth, barHeight)];
    silverbar.backgroundColor = [UIColor whiteColor];
    
    [self drawGradient:silverbar];
    
    return silverbar;
}

- (void)createRemainingAmountBar
{
    NSString* remainingText = @"Remaining Coupons: ";
    NSString* amount = [_punchcard getRemainingAmountAsString];
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:16.0];
    UIFont* textBoldFont = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    CGSize sizeRemaining = [remainingText sizeWithFont:textFont
                                     constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                         lineBreakMode:UILineBreakModeWordWrap];
    CGSize sizeAmount = [amount sizeWithFont:textBoldFont
                           constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                               lineBreakMode:UILineBreakModeWordWrap];
    CGFloat textStartXPos = (stdiPhoneWidth - (sizeRemaining.width + sizeAmount.width + 5))/2;
    _remainingAmountBar = [self createSilverBar];
    [_mainView addSubview:_remainingAmountBar];
    _lowestYPos = barHeight + _remainingAmountBar.frame.origin.y;
    CGFloat textYPos = (_remainingAmountBar.frame.size.height - sizeRemaining.height)/2;
    
    // Put in remaining text
    UILabel* remainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(textStartXPos, textYPos, sizeRemaining.width, sizeRemaining.height)];
    remainingLabel.backgroundColor = [UIColor clearColor];
    remainingLabel.text = remainingText;
    remainingLabel.textColor = [UIColor blackColor];
    [remainingLabel setNumberOfLines:1];
    [remainingLabel setFont:textFont];
    remainingLabel.textAlignment = UITextAlignmentCenter;
    [_remainingAmountBar addSubview:remainingLabel];
    
    // Put in amount
    UILabel* amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(textStartXPos + remainingLabel.frame.size.width + 5, textYPos, sizeAmount.width, sizeAmount.height)];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.text = amount;
    amountLabel.textColor = [UIColor colorWithRed:0.0f green:153.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    [amountLabel setNumberOfLines:1];
    [amountLabel setFont:textBoldFont];
    amountLabel.textAlignment = UITextAlignmentCenter;
    [_remainingAmountBar addSubview:amountLabel];
}

- (void)drawGradient:(UILabel*)current
{    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = current.bounds; 
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f] CGColor],
                       (id)[[UIColor whiteColor] CGColor], nil];
    gradient.startPoint = CGPointMake(0.5f, 0.5f);
    gradient.endPoint = CGPointMake(0.5f, 0.0f);
    [current.layer addSublayer:gradient];
}

- (void)createBackgroundImage
{
    // Draw the player's facebook image
    UIImageView* bizImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _lowestYPos, stdiPhoneWidth, kImageHeight)];
    bizImageView.backgroundColor = [UIColor blackColor];
    UrlImage* urlImage = [[UrlImageManager getInstance] getCachedImage:[_punchcard business_logo_url]];
    if(urlImage)
    {
        [bizImageView setImage:[urlImage image]];
    }
    else
    {
        UrlImage* urlImage = [[UrlImage alloc] initWithUrl:[_punchcard business_logo_url] forImageView:bizImageView];
        [[UrlImageManager getInstance] insertImageToCache:[_punchcard business_logo_url] image:urlImage];
    }
    [_mainView addSubview:bizImageView];
    _lowestYPos = _lowestYPos + kImageHeight;
}

- (void)createUseCouponButton
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString* couponText = [NSString stringWithFormat:@"Use a %@ coupon", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[_punchcard each_punch_value] doubleValue]]]];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"green-suggest-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* suggestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 60) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    finalRect.origin.y = _lowestYPos - (finalRect.size.height + 20);
    
    suggestButton.frame = finalRect;
    [suggestButton setBackgroundImage:image forState:UIControlStateNormal];
    [suggestButton setTitle:couponText forState:UIControlStateNormal];
    [suggestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    suggestButton.titleLabel.font = textFont;
    [suggestButton addTarget:self action:@selector(didPressUseCouponButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainView addSubview:suggestButton];
}

- (void)createNumPunchesLabel
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *amountAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[_punchcard each_punch_value] doubleValue]]];
    
    NSString* numPunchesText = [NSString stringWithFormat:@"%d x %@ Coupons Remaining", ([[_punchcard total_punches] integerValue] - [[_punchcard total_punches_used] integerValue]), amountAsString];
    CGFloat labelWidth = stdiPhoneWidth - 30;
    CGFloat labelHeight = 60;
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    UILabel* numPunchesLabel = [[UILabel alloc] initWithFrame:CGRectMake((stdiPhoneWidth - labelWidth)/2, _remainingAmountBar.frame.origin.y + _remainingAmountBar.frame.size.height + 40, labelWidth, labelHeight)];
    [numPunchesLabel setFont:textFont];
    numPunchesLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    numPunchesLabel.text = numPunchesText;
    numPunchesLabel.textColor = [UIColor whiteColor];
    [numPunchesLabel setNumberOfLines:1];
    [numPunchesLabel setFont:textFont];
    numPunchesLabel.textAlignment = UITextAlignmentCenter;
    
    numPunchesLabel.layer.cornerRadius = 5;
    numPunchesLabel.layer.masksToBounds = YES;
    
    [_mainView addSubview:numPunchesLabel];
}

- (void)createRulesBar
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:16.0];
    UILabel* rulesBar = [self createSilverBar];
    [rulesBar setFont:textFont];
    [_mainView addSubview:rulesBar];
    
    NSString* rulesText = @"Rules";
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

@end
//
//  PunchCompleteViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/5/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "AppDelegate.h"
#import "PunchCard.h"
#import "PunchCompleteViewController.h"
#import "Punches.h"
#import "Utilities.h"

@interface PunchCompleteViewController ()
{
    PunchCard* _punchcard;
}
@end

@implementation PunchCompleteViewController

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
    
    [self createSilverBackgroundWithImage];
    
    [self createBanners];
    
    [self createLabels];
    
    [self createDoneButton];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_secImage startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (void)createBanners
{
    UIImageView* banner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"graybanner.png"]];
    banner.frame = [Utilities resizeProportionally:banner.frame maxWidth:stdiPhoneWidth maxHeight:stdiPhoneHeight];
    [_mainView addSubview:banner];
    
    UILabel* textLabel = [[UILabel alloc] initWithFrame:banner.frame];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.text = @"Show Phone To Cashier";
    [textLabel setAdjustsFontSizeToFitWidth:YES];
    [_mainView addSubview:textLabel];
    
    _secImage = [[SecurityImageView alloc] initWithImage:[UIImage imageNamed:@"l.png"]];
    CGRect finalRect = [Utilities resizeProportionally:_secImage.frame maxWidth:stdiPhoneWidth maxHeight:stdiPhoneHeight];
    finalRect.origin.y = banner.frame.size.height + 20;
    _secImage.frame = finalRect;
    [_secImage prepareAnimation];
    [_mainView addSubview:_secImage];
    
    _lowestYPos = _secImage.frame.size.height + _secImage.frame.origin.y;
}

- (void) createLabels
{
    CGFloat gapsBetweenLabels;
    if ([[_punchcard code] length] > 0)
    {
        gapsBetweenLabels = 10;
    }
    else
    {
        gapsBetweenLabels = 15;
    }
    
    // Name of business
    UIFont* bizFont = [UIFont fontWithName:@"Helvetica-Bold" size:30.0f];
    CGSize sizeBizText = [[_punchcard business_name] sizeWithFont:bizFont
                                                constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                                    lineBreakMode:UILineBreakModeWordWrap];
    UILabel* bizLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos + gapsBetweenLabels, stdiPhoneWidth, sizeBizText.height + 2)];
    bizLabel.backgroundColor = [UIColor clearColor];
    bizLabel.textColor = [UIColor blackColor];
    bizLabel.textAlignment = UITextAlignmentCenter;
    bizLabel.text = [_punchcard business_name];
    [bizLabel setAdjustsFontSizeToFitWidth:YES];
    [bizLabel setFont:bizFont];
    [_mainView addSubview:bizLabel];
    _lowestYPos = bizLabel.frame.size.height + bizLabel.frame.origin.y;
    
    // terms
    UIFont* termsFont = [UIFont fontWithName:@"Helvetica-Bold" size:30.0f];
    NSString* termsText = [NSString stringWithFormat:@"%@ off purchase of\n %@ or more", [Utilities currencyAsString:[_punchcard each_punch_value]], [Utilities currencyAsString:[_punchcard minimum_value]]];
    CGSize sizeTermsText = [termsText sizeWithFont:termsFont
                                 constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                     lineBreakMode:UILineBreakModeWordWrap];
    UILabel* termsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos + gapsBetweenLabels, stdiPhoneWidth, sizeTermsText.height + 2)];
    termsLabel.backgroundColor = [UIColor clearColor];
    termsLabel.textColor = [UIColor orangeColor];
    termsLabel.textAlignment = UITextAlignmentCenter;
    termsLabel.text = termsText;
    [termsLabel setAdjustsFontSizeToFitWidth:YES];
    [termsLabel setNumberOfLines:2];
    [termsLabel setFont:termsFont];
    [_mainView addSubview:termsLabel];
    _lowestYPos = termsLabel.frame.size.height + termsLabel.frame.origin.y;
    
    // Code
    if ([[_punchcard code] length] > 0)
    {
        UIFont* codeFont = [UIFont fontWithName:@"ArialMT" size:30.0f];
        NSString* codeText = [NSString stringWithFormat:@"CODE: %@", [_punchcard code]];
        CGSize sizeCodeText = [codeText sizeWithFont:codeFont
                                   constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                       lineBreakMode:UILineBreakModeWordWrap];
        UILabel* codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos + gapsBetweenLabels, stdiPhoneWidth, sizeCodeText.height + 2)];
        codeLabel.backgroundColor = [UIColor clearColor];
        codeLabel.textColor = [UIColor blackColor];
        codeLabel.textAlignment = UITextAlignmentCenter;
        codeLabel.text = codeText;
        [codeLabel setAdjustsFontSizeToFitWidth:YES];
        [codeLabel setNumberOfLines:1];
        [codeLabel setFont:codeFont];
        [_mainView addSubview:codeLabel];
        _lowestYPos = codeLabel.frame.size.height + codeLabel.frame.origin.y;
    }
    
    // condition
    UIFont* conditionFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
    NSString* conditionText = @"Cannot be used in combination with\n other coupons or discounts";
    CGSize sizeConditionText = [conditionText sizeWithFont:conditionFont
                                         constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                             lineBreakMode:UILineBreakModeWordWrap];
    UILabel* conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos + gapsBetweenLabels, stdiPhoneWidth, sizeConditionText.height + 2)];
    conditionLabel.backgroundColor = [UIColor clearColor];
    conditionLabel.textColor = [UIColor blackColor];
    conditionLabel.textAlignment = UITextAlignmentCenter;
    conditionLabel.text = conditionText;
    [conditionLabel setAdjustsFontSizeToFitWidth:YES];
    [conditionLabel setFont:conditionFont];
    [conditionLabel setNumberOfLines:2];
    [_mainView addSubview:conditionLabel];
    _lowestYPos = conditionLabel.frame.size.height + conditionLabel.frame.origin.y;
}

- (void)createDoneButton
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    NSString* couponText = @"Done";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"large-green-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 60) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    finalRect.origin.y = stdiPhoneHeight - (finalRect.size.height + 30);
    
    doneButton.frame = finalRect;
    [doneButton setBackgroundImage:image forState:UIControlStateNormal];
    [doneButton setTitle:couponText forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = textFont;
    [doneButton addTarget:self action:@selector(didPressDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainView addSubview:doneButton];
}

#pragma mark - event actions

- (void) didPressDoneButton:(id)sender
{
    [[Punches getInstance] forceRefresh];
    [[User getInstance] forceRefresh];
    [[User getInstance] forceLocationRefresh];
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initView];
}

@end

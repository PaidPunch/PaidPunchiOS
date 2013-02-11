//
//  BizView.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/10/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "BizView.h"
#import "BusinessOffers.h"
#import "Utilities.h"

static const NSUInteger kDistances[] = {1,5,10,20};
static const NSUInteger kDistancesSize = 4;
static const NSUInteger kBannerHeight = 50;
static const NSUInteger kGapBetweenElements = 10;
static const NSUInteger kHalfScreen = (stdiPhoneWidth/2);
static const NSUInteger kMaxButtonWidth = kHalfScreen - 15;

@implementation BizView

- (id)initWithFrameAndBusinesses:(CGRect)frame businesses:(NSArray*)businesses
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Create a backing scrollview first
        _bizScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _bizScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bizScrollView];
        
        NSUInteger bizIndex = 0;
        _lowestYPos = 0;
        for (int i = 0; i < kDistancesSize; i++)
        {
            // First, check that there is at least one business in this distance range
            if ([[[businesses objectAtIndex:bizIndex] diff_in_miles] doubleValue] <= kDistances[i])
            {
                // Second, create a banner to group the businesses in this distance range
                [self createBanner:kDistances[i]];
                
                // Finally, create two columns of businesses
                bizIndex = [self createBusinessButtonsForDistance:kDistances[i] businesses:businesses startIndex:bizIndex];
            }
        }
        
        _bizScrollView.contentSize = CGSizeMake(stdiPhoneWidth, _lowestYPos);
    }
    return self;
}

- (void)createBanner:(int)dist
{
    // Add silver banner
    UIImageView* silverBanner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner.png"]];
    silverBanner.frame = CGRectMake(0, _lowestYPos, silverBanner.frame.size.width, silverBanner.frame.size.height);
    silverBanner.frame = [Utilities resizeProportionally:silverBanner.frame maxWidth:stdiPhoneWidth maxHeight:kBannerHeight];
    [self addSubview:silverBanner];
    
    _lowestYPos = silverBanner.frame.origin.y + silverBanner.frame.size.height + kGapBetweenElements;
    
    UIFont* textFont = [UIFont fontWithName:@"ArialMT" size:15.0f];
    UILabel* silverBannerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, stdiPhoneWidth, silverBanner.frame.size.height)];
    silverBannerLabel.backgroundColor = [UIColor clearColor];
    
    NSString* bannerText;
    if (dist == 1)
    {
        bannerText = @"1 mile";
    }
    else
    {
        bannerText = [NSString stringWithFormat:@"%d miles", dist];
    }
    
    silverBannerLabel.text = bannerText;
    silverBannerLabel.textColor = [UIColor blackColor];
    [silverBannerLabel setNumberOfLines:1];
    [silverBannerLabel setFont:textFont];
    silverBannerLabel.textAlignment = UITextAlignmentCenter;
    [silverBanner addSubview:silverBannerLabel];
}

- (NSUInteger)createBusinessButtonsForDistance:(NSUInteger)distance businesses:(NSArray*)businesses startIndex:(NSUInteger)startIndex
{
    CGFloat lowestLeftYPos = _lowestYPos;
    CGFloat lowestRightYPos = _lowestYPos;
    
    BusinessOffers* current;
    NSUInteger arraySize = [businesses count];
    NSUInteger i = startIndex;
    while (i < arraySize)
    {
        UIFont* buttonFont = [UIFont systemFontOfSize:13];
        
        // Do left side
        current = [businesses objectAtIndex:i];
        if ([[current diff_in_miles] doubleValue] > distance)
        {
            break;
        }
        else
        {
            UIButton* leftbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            NSString* leftText = [[current business] business_name];
            CGSize sizeLeftText = [leftText sizeWithFont:buttonFont
                                       constrainedToSize:CGSizeMake(kMaxButtonWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
            [leftbutton setFrame:CGRectMake((kHalfScreen - kMaxButtonWidth)/2, lowestLeftYPos, kMaxButtonWidth, sizeLeftText.height)];
            [leftbutton setTitle:leftText forState:UIControlStateNormal];
            leftbutton.titleLabel.font = buttonFont;
            [self addSubview:leftbutton];
            
            lowestLeftYPos = leftbutton.frame.origin.y + leftbutton.frame.size.height + kGapBetweenElements;
            
            i++;
        }
        
        // Check that we haven't reached the end of the array
        if (i >= arraySize)
        {
            break;
        }
        
        // Do right side
        current = [businesses objectAtIndex:i];
        if ([[current diff_in_miles] doubleValue] > distance)
        {
            break;
        }
        else
        {
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            NSString* rightText = [[current business] business_name];
            CGSize sizeRightText = [rightText sizeWithFont:buttonFont
                                       constrainedToSize:CGSizeMake(kMaxButtonWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
            [rightButton setFrame:CGRectMake((kHalfScreen - kMaxButtonWidth)/2 + kHalfScreen, lowestRightYPos, kMaxButtonWidth, sizeRightText.height)];
            [rightButton setTitle:rightText forState:UIControlStateNormal];
            rightButton.titleLabel.font = buttonFont;
            [self addSubview:rightButton];
            
            lowestRightYPos = rightButton.frame.origin.y + rightButton.frame.size.height + kGapBetweenElements;
            
            i++;
        }
    }
    
    // At least one business was added to the current group
    if (_lowestYPos != lowestLeftYPos)
    {
        _lowestYPos = MAX(lowestLeftYPos, lowestRightYPos);
    }
    
    return i;
}

@end

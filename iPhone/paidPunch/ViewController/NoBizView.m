//
//  NoBizView.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#include "CommonDefinitions.h"
#import "NoBizView.h"
#import "Utilities.h"

@implementation NoBizView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Add silver banner        
        UIImageView* silverBanner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner.png"]];
        silverBanner.frame = CGRectMake(0, 0, silverBanner.frame.size.width, silverBanner.frame.size.height);
        silverBanner.frame = [Utilities resizeProportionally:silverBanner.frame maxWidth:stdiPhoneWidth maxHeight:50];
        [self addSubview:silverBanner];
        
        UIFont* textFont = [UIFont fontWithName:@"ArialMT" size:15.0f];
        UILabel* silverBannerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, stdiPhoneWidth, silverBanner.frame.size.height)];
        silverBannerLabel.backgroundColor = [UIColor clearColor];
        silverBannerLabel.text = @"We'll be in your city soon!";
        silverBannerLabel.textColor = [UIColor blackColor];
        [silverBannerLabel setNumberOfLines:1];
        [silverBannerLabel setFont:textFont];
        silverBannerLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:silverBannerLabel];
        
        // Add background image
        UIImageView* bgrdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-biz.png"]];
        bgrdImage.frame = CGRectMake(0, silverBanner.frame.size.height, stdiPhoneWidth, frame.size.height - silverBanner.frame.size.height);
        [self addSubview:bgrdImage];
        
        // Add All About You label
        UIFont* allaboutyouFont = [UIFont fontWithName:@"Arial-BoldMT" size:18.0f];
        NSString* allaboutyouText = @"PaidPunch is all about YOU!";
        CGSize sizeText = [allaboutyouText sizeWithFont:allaboutyouFont
                                      constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                          lineBreakMode:UILineBreakModeWordWrap];
        UILabel* allaboutyouLabel = [[UILabel alloc] initWithFrame:CGRectMake((stdiPhoneWidth - sizeText.width)/2, bgrdImage.frame.origin.y + 60, sizeText.width, sizeText.height)];
        allaboutyouLabel.backgroundColor = [UIColor clearColor];
        allaboutyouLabel.text = allaboutyouText;
        allaboutyouLabel.textColor = [UIColor whiteColor];
        [allaboutyouLabel setNumberOfLines:1];
        [allaboutyouLabel setFont:allaboutyouFont];
        allaboutyouLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:allaboutyouLabel];
        
        // Add black rounded bar
        UIFont* blackbarFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
        CGFloat blackbarWidth = stdiPhoneWidth - 20;
        CGFloat blackbarHeight = 75;
        CGRect blackbarRect = CGRectMake((stdiPhoneWidth - blackbarWidth)/2, bgrdImage.frame.origin.y + 120, blackbarWidth, blackbarHeight);
        UILabel* blackbar = [[UILabel alloc] initWithFrame:blackbarRect];
        blackbar.backgroundColor = [UIColor blackColor];
        blackbar.layer.cornerRadius = 5;
        blackbar.layer.masksToBounds = YES;
        [blackbar setText:@"Tell us where you want to save by\rclicking on the Suggest A Business button"];
        blackbar.textColor = [UIColor whiteColor];
        [blackbar setNumberOfLines:2];
        [blackbar setFont:blackbarFont];
        blackbar.textAlignment = UITextAlignmentCenter;
        [self addSubview:blackbar];
        
        // Add save-every-visit image
        UIImageView* saveEveryVisitImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save-every-visit.png"]];
        saveEveryVisitImage.frame  = CGRectMake(0, frame.size.height - (saveEveryVisitImage.frame.size.height + 10), saveEveryVisitImage.frame.size.width, saveEveryVisitImage.frame.size.height);
        saveEveryVisitImage.frame = [Utilities resizeProportionally:saveEveryVisitImage.frame maxWidth:stdiPhoneWidth maxHeight:saveEveryVisitImage.frame.size.height];
        [self addSubview:saveEveryVisitImage];
    }
    return self;
}

@end

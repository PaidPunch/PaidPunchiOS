//
//  HomePaidPunchButton.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/8/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "UIView+Glow.h"
#import "HomePaidPunchButton.h"
#import "Utilities.h"

@implementation HomePaidPunchButton

- (id)initCustom:(CGRect)frame image:(UIImage*)image delegate:(NSObject<HomePaidPunchButtonDelegate>*)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _delegate = delegate;
        [self addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setFrame:frame];
    }
    return self;
}

- (void)startPPGlow
{
    [self startGlowing];
}

- (void)stopPPGlow
{
    [self stopGlowing];
}

#pragma mark - event actions

- (void)didPressButton:(id)sender
{
    [_delegate didPressHomePaidPunchButton];
}

@end

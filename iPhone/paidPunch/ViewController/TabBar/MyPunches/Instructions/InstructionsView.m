//
//  InstructionsView.m
//  paidPunch
//
//  Created by mobimedia technologies on 26/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "InstructionsView.h"

@implementation InstructionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -

- (IBAction)okBtnTouchUpInsideHandler:(id)sender {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:@"YES" forKey:@"isManualShown"];
    [ud synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sliderInstructionsCompleted" object:nil];
    [self removeFromSuperview];
}
@end

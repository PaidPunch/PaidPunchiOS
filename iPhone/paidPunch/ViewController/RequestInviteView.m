//
//  RequestInviteView.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/31/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Twitter/TWTweetComposeViewController.h>
#import "RequestInviteView.h"

@implementation RequestInviteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if ([TWTweetComposeViewController canSendTweet])
        {
            
        }
        else
        {
            
        }
    }
    return self;
}

@end

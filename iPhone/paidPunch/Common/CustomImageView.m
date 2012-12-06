//
//  CustomImageView.m
//  paidPunch
//
//  Created by mobimedia technologies on 16/01/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView

-(void) awakeFromNib
{
        NSArray *myImages=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"1.png"],
                           [UIImage imageNamed:@"2.png"],
                           [UIImage imageNamed:@"3.png"],
                           [UIImage imageNamed:@"4.png"],
                           [UIImage imageNamed:@"5.png"],
                           [UIImage imageNamed:@"6.png"],
                           [UIImage imageNamed:@"7.png"],
                           [UIImage imageNamed:@"8.png"],
                           nil];
        [self setAnimationImages:myImages];
        [self setAnimationDuration:0.50];
        self.animationRepeatCount=0;
        [self startAnimating];

}
-(void) stop
{
    [self stopAnimating];
}

@end

//
//  SecurityImageView.m
//  paidPunch
//
//  Created by mobimedia technologies on 16/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "SecurityImageView.h"

@implementation SecurityImageView

-(void) awakeFromNib
{
    NSArray *myImages=[[NSArray alloc] initWithObjects:[UIImage imageNamed:@"a.png"],
                       [UIImage imageNamed:@"b.png"],
                       [UIImage imageNamed:@"c.png"],
                       [UIImage imageNamed:@"d.png"],
                       [UIImage imageNamed:@"e.png"],
                       [UIImage imageNamed:@"f.png"],
                       [UIImage imageNamed:@"g.png"],
                       [UIImage imageNamed:@"h.png"],
                       [UIImage imageNamed:@"i.png"],
                       [UIImage imageNamed:@"j.png"],
                       [UIImage imageNamed:@"k.png"],
                       [UIImage imageNamed:@"l.png"],
                       nil];
    [self setAnimationImages:myImages];
    [myImages release];
    [self setAnimationDuration:1.50];
    self.animationRepeatCount=0;
    [self startAnimating];
    
}
-(void) stop
{
    [self stopAnimating];
}


@end

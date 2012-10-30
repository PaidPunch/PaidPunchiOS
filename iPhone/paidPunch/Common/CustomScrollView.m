//
//  CustomScrollView.m
//  paidPunch
//
//  Created by mobimedia technologies on 15/12/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView


-(id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //if not dragging ,send event to next responder
    if(!self.dragging)
    {
        [self.nextResponder touchesEnded:touches withEvent:event];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollViewTouchEvent" object:nil];
    }
    else
        [super touchesEnded:touches withEvent:event];
}   
@end

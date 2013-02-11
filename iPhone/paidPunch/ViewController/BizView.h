//
//  BizView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/10/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizView : UIView
{
    UIScrollView* _bizScrollView;
    CGFloat _lowestYPos;
}

- (id)initWithFrameAndBusinesses:(CGRect)frame businesses:(NSArray*)businesses;

@end

//
//  BusinessDescView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessDescView : UIView
{
    Business* _business;
    CGFloat _lowestYPos;
}

- (id)initWithFrameAndBusiness:(CGRect)frame business:(Business*)business;

@end

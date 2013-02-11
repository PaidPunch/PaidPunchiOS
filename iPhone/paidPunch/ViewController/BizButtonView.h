//
//  BizButtonView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/10/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessOffers.h"
#import "HttpCallbackDelegate.h"

@interface BizButtonView : UIView<HttpCallbackDelegate>
{
    BusinessOffers* _businessOffers;
    CGFloat _width;
    
    UILabel* _upsellLabel;
    UIImageView* _logoImage;
}

- (id)initWithFrameAndBusiness:(CGRect)frame current:(BusinessOffers*)current;

@end

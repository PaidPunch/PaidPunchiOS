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
    
    UILabel* _upsellTextLabel;
    UIImageView* _nameLabel;
    UIImageView* _logoImage;
    UIImageView* _upsellLabel;
    UIActivityIndicatorView* _spinner;
    UIButton* _overlayButton;
}

- (id)initWithFrameAndBusiness:(CGRect)frame current:(BusinessOffers*)current;

@end

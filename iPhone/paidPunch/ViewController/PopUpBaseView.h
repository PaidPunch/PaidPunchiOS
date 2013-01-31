//
//  PopUpBaseView.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/30/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpBaseView : UIView
{
    UIScrollView* _scrollview;
    UILabel* _greyoutLabel;
    UIView* _popupView;
    UITapGestureRecognizer* _dismissTap;
}

@end

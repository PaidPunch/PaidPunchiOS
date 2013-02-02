//
//  MyCouponsView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/1/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCouponsTableView.h"
#import "PopUpBaseView.h"

@interface MyCouponsView : PopUpBaseView
{
    CGFloat _lowestYPos;
    UIScrollView* _myCouponsScrollView;
    MyCouponsTableView* _myCouponsTable;
}

@end

//
//  PunchCompleteViewController.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/5/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseWithNavBarViewController.h"
#import "SecurityImageView.h"

@interface PunchCompleteViewController : BaseWithNavBarViewController
{
    SecurityImageView* _secImage;
}

- (id)initWithPunchcard:(PunchCard *)current;

@end

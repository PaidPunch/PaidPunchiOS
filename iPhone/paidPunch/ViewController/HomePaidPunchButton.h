//
//  HomePaidPunchButton.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/8/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePaidPunchButtonDelegate.h"

@interface HomePaidPunchButton : UIButton
{
    __weak NSObject<HomePaidPunchButtonDelegate>* _delegate;
}

- (id)initCustom:(CGRect)frame image:(UIImage*)image delegate:(NSObject<HomePaidPunchButtonDelegate>*)delegate;
- (void)startPPGlow;
- (void)stopPPGlow;

@end

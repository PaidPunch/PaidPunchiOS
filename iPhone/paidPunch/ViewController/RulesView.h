//
//  RulesView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunchCard.h"

@interface RulesView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    UIScrollView* _rulesScroller;
    UITableView* _rulesList;
    PunchCard* _punchcard;
}

- (id)initWithPunchcard:(CGRect)frame current:(PunchCard *)current;

@end

//
//  RulesView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/4/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunchCard.h"

@interface RulesView : UITableView<UITableViewDelegate, UITableViewDataSource>
{
    PunchCard* _punchcard;
    BOOL _purchaseRules;
}

- (id)initWithPunchcard:(CGRect)frame current:(PunchCard *)current purchaseRules:(BOOL)purchaseRules;

@end

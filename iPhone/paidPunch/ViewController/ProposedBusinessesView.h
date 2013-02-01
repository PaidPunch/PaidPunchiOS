//
//  ProposedBusinessesView.h
//  paidPunch
//
//  Created by Aaron Khoo on 1/26/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpCallbackDelegate.h"
#import "MBProgressHUD.h"

@interface ProposedBusinessesView : UITableView<UITableViewDelegate, UITableViewDataSource,HttpCallbackDelegate>
{
    UIButton* currentVotingButton;
    NSUInteger currentBusinessIndex;
    MBProgressHUD* _hud;
}

@end

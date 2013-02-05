//
//  MyCouponsTableView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/1/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponsTableView : UITableView<UITableViewDelegate, UITableViewDataSource>
{
    UINavigationController* _controller;
}
@property(nonatomic,strong) UINavigationController* controller;

@end

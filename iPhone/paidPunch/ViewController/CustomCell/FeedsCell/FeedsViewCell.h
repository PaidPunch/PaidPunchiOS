//
//  FeedsViewCell.h
//  paidPunch
//
//  Created by mobimedia technologies on 04/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface FeedsViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIWebView *contentsWebView;
@property (retain, nonatomic) IBOutlet OHAttributedLabel *contentsLbl;

@end

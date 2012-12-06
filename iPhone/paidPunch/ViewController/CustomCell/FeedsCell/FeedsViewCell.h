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

@property (strong, nonatomic) IBOutlet UIWebView *contentsWebView;
@property (strong, nonatomic) IBOutlet OHAttributedLabel *contentsLbl;

@end

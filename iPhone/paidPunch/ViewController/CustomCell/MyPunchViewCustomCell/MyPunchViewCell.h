//
//  MyPunchViewCell.h
//  paidPunch
//
//  Created by mobimedia technologies on 01/12/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunchCard.h"
#import "DatabaseManager.h"
#import "SDWebImageManager.h"
#import "SDWebImageManagerDelegate.h"
#import "MarqueeLabel.h"

@interface MyPunchViewCell : UITableViewCell<SDWebImageManagerDelegate>
{
    PunchCard *punchCardDetails;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) MarqueeLabel *businessMarqueeLabel;
@property (retain, nonatomic) IBOutlet UILabel *remainingPunchesLabel;
@property (assign, nonatomic) PunchCard *punchCardDetails;
@property (nonatomic,retain) NSString *punchId;
-(void) setData;
@end

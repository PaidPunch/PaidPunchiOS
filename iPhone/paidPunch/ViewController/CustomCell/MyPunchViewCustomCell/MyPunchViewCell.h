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
    PunchCard *__weak punchCardDetails;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) MarqueeLabel *businessMarqueeLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainingPunchesLabel;
@property (weak, nonatomic) PunchCard *punchCardDetails;
@property (nonatomic,strong) NSString *punchId;
-(void) setData;
@end

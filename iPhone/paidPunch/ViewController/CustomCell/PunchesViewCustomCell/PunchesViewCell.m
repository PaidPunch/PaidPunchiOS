//
//  PunchesViewCell.m
//  paidPunch
//
//  Created by mobimedia technologies on 02/12/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "PunchesViewCell.h"

@implementation PunchesViewCell

@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Cleanup


@end

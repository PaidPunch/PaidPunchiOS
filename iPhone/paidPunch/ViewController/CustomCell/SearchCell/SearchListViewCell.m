//
//  SearchListViewCell.m
//  paidPunch
//
//  Created by mobimedia technologies on 02/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "SearchListViewCell.h"

@implementation SearchListViewCell
@synthesize businessNameLbl;
@synthesize milesLbl;

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

- (void)dealloc {
    [milesLbl release];
    [businessNameLbl release];
    [super dealloc];
}
@end

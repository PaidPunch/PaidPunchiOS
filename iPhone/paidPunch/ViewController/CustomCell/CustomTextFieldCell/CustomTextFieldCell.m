//
//  CustomTextFieldCell.m
//  paidPunch
//
//  Created by mobimedia technologies on 28/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "CustomTextFieldCell.h"

@implementation CustomTextFieldCell

@synthesize headingLabel;
@synthesize valueTextField;

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

- (void)dealloc {
     NSLog(@"In dealloc of CustomTextFieldCell");
}

@end

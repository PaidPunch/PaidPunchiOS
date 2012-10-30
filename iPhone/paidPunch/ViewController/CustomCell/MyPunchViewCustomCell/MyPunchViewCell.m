//
//  MyPunchViewCell.m
//  paidPunch
//
//  Created by mobimedia technologies on 01/12/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "MyPunchViewCell.h"

@implementation MyPunchViewCell
@synthesize businessMarqueeLabel;
@synthesize remainingPunchesLabel;
@synthesize punchCardDetails;
@synthesize punchId;

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
    [businessMarqueeLabel release];
    [punchId release];
    [super dealloc];
    //NSLog(@"In dealloc of MyPunchViewCell");
}

#pragma mark -

-(void) setData
{
    @try {
        businessMarqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(20.0, 11.0, 215.0, 37.0) rate:20.0f andFadeLength:10.0f];
        [businessMarqueeLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        self.businessMarqueeLabel.text=self.punchCardDetails.business_name;
        [self addSubview:businessMarqueeLabel];
        
        self.remainingPunchesLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        int remaining=[punchCardDetails.total_punches intValue]-[punchCardDetails.total_punches_used intValue];
        if([self.punchCardDetails.is_mystery_punch intValue]==1)
        {
            remaining-=1;
        }
        
        if (remaining > 0) {
            self.remainingPunchesLabel.textColor = [UIColor colorWithRed:244.0 green:123.0/255.0 blue:39.0/255.0 alpha:1.0];
            [self.remainingPunchesLabel setText:[NSString stringWithFormat:@"%d", remaining]];
        }
        else if(remaining == 0 && [punchCardDetails.is_mystery_punch intValue] == 1 && [punchCardDetails.is_mystery_used intValue] == 0) {
            self.remainingPunchesLabel.textColor = [UIColor colorWithRed:0.0 green:132.0/255.0 blue:204.0/255.0 alpha:1.0];
            [self.remainingPunchesLabel setText:@"1"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception reason]);
    }
}

#pragma mark -
#pragma mark SDWebImageManagerDelegate methods Implementation

-(void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

@end

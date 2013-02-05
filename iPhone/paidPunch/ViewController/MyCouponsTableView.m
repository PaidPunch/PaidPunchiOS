//
//  MyCouponsTableView.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/1/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "MyCouponsTableView.h"
#import "MyCouponViewController.h"
#import "PunchCard.h"
#import "Punches.h"

static CGFloat const kAmountSize = 100.0;
static CGFloat const kCellHeight = 60.0;

@implementation MyCouponsTableView
@synthesize controller = _controller;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[Punches getInstance] punchesArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];    
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"MyCouponCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PunchCard* currentPunchcard = [[[Punches getInstance] punchesArray] objectAtIndex:indexPath.row];
    UILabel* nameLabel = [self createNameLabel:currentPunchcard.punch_card_name];
    [cell addSubview:nameLabel];
    
    // Create amount label
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    UILabel* amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - kAmountSize, 5, kAmountSize - 10  , kCellHeight)];
    amountLabel.text = [currentPunchcard getRemainingAmountAsString];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.textColor = [UIColor colorWithRed:0.0f green:153.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    [amountLabel setNumberOfLines:1];
    [amountLabel setFont:textFont];
    amountLabel.textAlignment = UITextAlignmentRight;
    [cell addSubview:amountLabel];
    
   	return cell;
}

- (UILabel*)createNameLabel:(NSString*)name
{
    CGFloat maxWidth = self.frame.size.width - kAmountSize;
    float startingSize = 18.0f;
    UIFont* textFont = [UIFont fontWithName:@"Helvetica" size:startingSize];
    CGSize sizeText = [name sizeWithFont:textFont
                       constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                           lineBreakMode:UILineBreakModeWordWrap];
    while (sizeText.width > maxWidth && startingSize > 12.0f)
    {
        startingSize -= 1.0f;
        textFont = [UIFont fontWithName:@"Helvetica" size:startingSize];
        sizeText = [name sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                        lineBreakMode:UILineBreakModeWordWrap];
    }
    UILabel* newLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, maxWidth, kCellHeight)];
    newLabel.text = name;
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.textColor = [UIColor blackColor];
    [newLabel setNumberOfLines:1];
    [newLabel setFont:textFont];
    newLabel.textAlignment = UITextAlignmentLeft;
    
    return newLabel;
}

#pragma mark UITableViewDelegate methods Implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self goToPunchView:[[[Punches getInstance] punchesArray] objectAtIndex:indexPath.row]];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

-(void) goToPunchView:(PunchCard *)punchCard
{
    MyCouponViewController* myCoupon = [[MyCouponViewController alloc] initWithPunchcard:punchCard];
    [_controller pushViewController:myCoupon animated:NO];
    
    /*
    PunchViewController *punchView = [[PunchViewController alloc] initWithNibName:nil bundle:nil];
    punchView.punchCardDetails=punchCard;
    punchView.punchId=punchCard.punch_card_download_id;
    [self.navigationController pushViewController:punchView animated:YES];
    [punchView setUpUI];
    */
}
@end

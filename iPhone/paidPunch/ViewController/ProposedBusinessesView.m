//
//  ProposedBusinessesView.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/26/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "ProposedBusiness.h"
#import "ProposedBusinesses.h"
#import "ProposedBusinessesView.h"

static CGFloat const kRowHeight = 70.0;
static CGFloat const kImageSize = 50.0;
static CGFloat const kVoteButtonWidth = 40.0;

@implementation ProposedBusinessesView

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

#pragma mark - delegate/data source functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ProposedBusinesses getInstance] proposedBusinessesArray] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProposedBusinessCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ProposedBusiness* current = [[[ProposedBusinesses getInstance] proposedBusinessesArray] objectAtIndex:indexPath.row];
    
    // Display business image
    // TODO: Replace filepath with logopath
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pp_icon" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIImageView *lbImgView = [[UIImageView alloc] initWithImage:image];
    //set contentMode to scale aspect to fit
    lbImgView.contentMode = UIViewContentModeScaleAspectFit;
    //change width of frame
    CGRect frame = lbImgView.frame;
    frame.origin.x = 5.0;
    frame.origin.y = (kRowHeight - kImageSize)/2;
    frame.size.height = kImageSize;
    frame.size.width = kImageSize;
    lbImgView.frame = frame;
    [cell.contentView addSubview:lbImgView];
    
    // Display business name
    CGFloat textXPos = kImageSize + 20;
    UIFont* name_font = [UIFont fontWithName:@"Helvetica" size:19.0f];
    CGFloat constrainedSize = 265.0f;
    NSString* nameText = [current name];
    CGSize sizenameText = [nameText sizeWithFont:name_font
                               constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)
                                   lineBreakMode:UILineBreakModeWordWrap];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textXPos, 0.0, sizenameText.width, kRowHeight/2)];
    label.text = nameText;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [label setNumberOfLines:1];
    [label setFont:name_font];
    label.textAlignment = UITextAlignmentLeft;
    [cell.contentView addSubview:label];
    
    // Display business desc
    UIFont* desc_font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    NSString* descText = [current desc];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(textXPos, kRowHeight/2, stdiPhoneWidth-kVoteButtonWidth - textXPos, kRowHeight/2)];
    descLabel.text = descText;
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.textColor = [UIColor blackColor];
    [descLabel setNumberOfLines:0];
    [descLabel setFont:desc_font];
    descLabel.textAlignment = UITextAlignmentLeft;
    [descLabel sizeToFit];
    [cell.contentView addSubview:descLabel];
    
    // Display voting button    
    UIButton* voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voteButton addTarget:self action:@selector(didPressVoteButton:event:) forControlEvents:UIControlEventTouchUpInside];
    [voteButton setImage:[UIImage imageNamed:@"grey-vote.png"] forState:UIControlStateNormal];
    [voteButton setImage:[UIImage imageNamed:@"orange-vote.png"] forState:UIControlStateSelected];
    [voteButton setImage:[UIImage imageNamed:@"orange-vote.png"] forState:UIControlStateHighlighted];
    [voteButton setImage:[UIImage imageNamed:@"orange-vote.png"] forState:UIControlStateSelected | UIControlStateDisabled];
    [voteButton setImage:[UIImage imageNamed:@"orange-vote.png"] forState:UIControlStateDisabled];
    [voteButton setImage:[UIImage imageNamed:@"orange-vote.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    if ([[ProposedBusinesses getInstance] alreadyVoted:[current proposedBusinessId]])
    {
        [voteButton setSelected:TRUE];
        voteButton.enabled = FALSE;
    }
    voteButton.contentMode = UIViewContentModeScaleAspectFit;
    //change width of frame
    CGRect voteFrame = voteButton.frame;
    voteFrame.origin.x = stdiPhoneWidth - (kVoteButtonWidth + 10);
    voteFrame.origin.y = (kRowHeight - kVoteButtonWidth)/2;
    voteFrame.size.height = kVoteButtonWidth;
    voteFrame.size.width = kVoteButtonWidth;
    voteButton.frame = voteFrame;
    [cell.contentView addSubview:voteButton];
    
    return cell;
}

- (void)didPressVoteButton:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        currentVotingButton = (UIButton*)sender;
        currentBusinessIndex = indexPath.row;
        
        _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _hud.labelText = @"Registering Vote";
        
        [[ProposedBusinesses getInstance] voteBusiness:self index:currentBusinessIndex];
    }
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{
    if(success)
    {
        // Store the vote
        ProposedBusiness* current = [[[ProposedBusinesses getInstance] proposedBusinessesArray] objectAtIndex:currentBusinessIndex];
        [[ProposedBusinesses getInstance] recordVote:[current proposedBusinessId]];
        
        // Update the button 
        [currentVotingButton setSelected:TRUE];
        currentVotingButton.enabled = FALSE;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Vote registered" message:@"Thanks for voting!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [MBProgressHUD hideHUDForView:self animated:NO];
}

@end

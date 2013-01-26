//
//  InviteFriendsViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/25/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "User.h"
#import "Utilities.h"

@implementation InviteFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create nav bar on top
    [self createNavBar:nil rightString:@"Next" middle:@"Give $5, Get $5" isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    // Create green notification bar
    [self createGreenNotificationBar:@"Sign Up Successful!"];
    
    // Create text labels
    [self createInviteFriendsText];
    
    // Insert background image
    UIImageView* bkgdImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup-redcarpet-img.png"]];
    CGRect originalRect = CGRectMake(0, 0, bkgdImage.frame.size.width, bkgdImage.frame.size.height);
    originalRect = [Utilities resizeProportionally:originalRect maxWidth:stdiPhoneWidth maxHeight:stdiPhoneHeight];
    originalRect.origin.y = stdiPhoneHeight - originalRect.size.height;
    bkgdImage.frame = originalRect;
    [_mainView addSubview:bkgdImage];
    
    // Grey background bar for textfield
    UIFont* textFont = [UIFont fontWithName:@"ArialMT" size:17.0f];
    NSString* invitecodeText = [NSString stringWithFormat:@"Your Invitation Code: %@", [[User getInstance] referralCode]];
    CGSize sizeInvitecodeText = [invitecodeText sizeWithFont:textFont
                                                    forWidth:stdiPhoneWidth
                                               lineBreakMode:UILineBreakModeWordWrap];
    UILabel *invitecodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (stdiPhoneHeight - (sizeInvitecodeText.height + 60)), stdiPhoneWidth, sizeInvitecodeText.height + 18)];
    invitecodeLabel.backgroundColor = [UIColor whiteColor];
    [invitecodeLabel setText:invitecodeText];
    [invitecodeLabel setTextColor:[UIColor blackColor]];
    [invitecodeLabel setTextAlignment:NSTextAlignmentCenter];
    [_mainView addSubview:invitecodeLabel];
    
    // Create orange sign in/up button
    UIFont* orangeButtonFont = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"orange-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* btnInvite = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect originalInviteButtonRect = CGRectMake(0, _lowestYPos + 100, image.size.width, image.size.height);
    CGRect finalInviteButtonRect = [Utilities resizeProportionally:originalInviteButtonRect maxWidth:(stdiPhoneWidth - 80) maxHeight:160];
    finalInviteButtonRect.origin.x = (stdiPhoneWidth - finalInviteButtonRect.size.width)/2;
    btnInvite.frame = finalInviteButtonRect;
    [btnInvite setBackgroundImage:image forState:UIControlStateNormal];
    [btnInvite setTitle:@"Invite Friends" forState:UIControlStateNormal];
    [btnInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnInvite.titleLabel.font = orangeButtonFont;
    [btnInvite addTarget:self action:@selector(didPressInviteFriendsButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:btnInvite];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (void)createInviteFriendsText
{
    NSString* inviteText = @"Invite friends with your invitation code!\rThey get $5 free.";
    NSString* upsellText = @"You get $5 free per signup!";
    
    // Create non-bold label
    UIFont* nonboldFont = [UIFont fontWithName:@"ArialMT" size:16.0f];
    CGSize sizeInviteText = [inviteText sizeWithFont:nonboldFont
                                   constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                       lineBreakMode:UILineBreakModeWordWrap];
    UILabel* inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos + 8, stdiPhoneWidth, sizeInviteText.height)];
    inviteLabel.text = inviteText;
    inviteLabel.backgroundColor = [UIColor clearColor];
    inviteLabel.textColor = [UIColor blackColor];
    [inviteLabel setNumberOfLines:0];
    [inviteLabel setFont:nonboldFont];
    inviteLabel.textAlignment = UITextAlignmentCenter;
    [_mainView addSubview:inviteLabel];
    
    // Create bold label
    UIFont* boldFont = [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    CGSize sizeUpsellText = [upsellText sizeWithFont:boldFont
                                   constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                       lineBreakMode:UILineBreakModeWordWrap];
    UILabel* upsellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lowestYPos + sizeInviteText.height + 10, stdiPhoneWidth, sizeUpsellText.height)];
    upsellLabel.text = upsellText;
    upsellLabel.backgroundColor = [UIColor clearColor];
    upsellLabel.textColor = [UIColor blackColor];
    [upsellLabel setNumberOfLines:0];
    [upsellLabel setFont:boldFont];
    upsellLabel.textAlignment = UITextAlignmentCenter;
    [_mainView addSubview:upsellLabel];
    
    _lowestYPos = _lowestYPos + inviteLabel.frame.size.height + upsellLabel.frame.size.height;
}

#pragma mark - event actions

- (void)didPressInviteFriendsButton:(id)sender
{

}

@end

//
//  InviteFriendsViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/25/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "VoteBusinessesViewController.h"
#import "InviteFriendsViewController.h"
#import "Templates.h"
#import "User.h"
#import "Utilities.h"

static const CGFloat kButtonSize = 50;
static const int kButtonsPerRow = 3;
static const CGFloat kHorizontalSpacing = 40;
static const CGFloat kVerticalSpacing = 30;
static const CGFloat kInviteViewVerticalStartPos = 20;

typedef enum
{
    no_response,
    facebook_response,
    email_response,
    sms_response
} AlertType;

@interface InviteFriendsViewController ()
{
    AlertType _alertType;
    BOOL _popWhenDone;
}
@end

@implementation InviteFriendsViewController

- (id)init:(BOOL)popWhenDone
{
    self = [super init];
    if (self)
    {
        _alertType = no_response;
        _popWhenDone = popWhenDone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self createMainView:[UIColor whiteColor]];
    
    // Create nav bar on top
    [self createNavBar:nil rightString:@"Next" middle:@"Give $5, Get $5" isMiddleImage:FALSE leftAction:nil rightAction:@selector(didPressNextButton:)];
    
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
    _btnInvite = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect originalInviteButtonRect = CGRectMake(0, _lowestYPos + 100, image.size.width, image.size.height);
    CGRect finalInviteButtonRect = [Utilities resizeProportionally:originalInviteButtonRect maxWidth:(stdiPhoneWidth - 80) maxHeight:160];
    finalInviteButtonRect.origin.x = (stdiPhoneWidth - finalInviteButtonRect.size.width)/2;
    _btnInvite.frame = finalInviteButtonRect;
    [_btnInvite setBackgroundImage:image forState:UIControlStateNormal];
    [_btnInvite setTitle:@"Invite Friends" forState:UIControlStateNormal];
    [_btnInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnInvite.titleLabel.font = orangeButtonFont;
    [_btnInvite addTarget:self action:@selector(didPressInviteFriendsButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_btnInvite];
    
    // Create the view that contains the invite friend buttons
    [self createInviteFriendsView];
    
    // Create gesture recognizers to handle tap-to-dismiss when inviteView is up
    _dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    // Create an invisible label to capture the tap-to-dismiss events
    _invisibleLayer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneWidth)];
    [_invisibleLayer setBackgroundColor:[UIColor clearColor]];
    [_mainView addSubview:_invisibleLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (void)sendInvite
{
    if (_alertType == facebook_response)
    {
        [[User getInstance] updateFacebookFeed:[[Templates getInstance] getTemplateByName:@"facebook"]];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invite posted to your Facebook wall"
                                                          message:@"When your friends sign up with PaidPunch using your invite code, you'll earn free credit."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else if (_alertType == email_response)
    {
        // Show the composer
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"My Subject"];
        [controller setMessageBody:[[Templates getInstance] getTemplateByName:@"email"] isHTML:YES];
        if (controller)
        {
            [self presentModalViewController:controller animated:YES];
        }
    }
    else if (_alertType == sms_response)
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.body = @"Use my code and get $5 free! http://goo.gl/NOuKr";
		//controller.recipients = [NSArray arrayWithObjects:@"12345678", @"87654321", nil];
		controller.messageComposeDelegate = self;
        if (controller)
        {
            [self presentModalViewController:controller animated:YES];
        }
    }
    else
    {
        NSLog(@"FreeCreditView: Unknown alert type");
    }
    _alertType = no_response;
}

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

- (CGFloat)computeXPosByIndex:(int)index
{
    int position = index % kButtonsPerRow;
    return ((position * kButtonSize) + ((position + 1) * kHorizontalSpacing));
}

- (CGFloat)computeYPosByIndex:(int)index
{
    int position = index / kButtonsPerRow;
    return ((position + 1) * kVerticalSpacing) + kInviteViewVerticalStartPos;
}

- (void)createInviteFriendsView
{
    _offscreenRect = CGRectMake(0, stdiPhoneHeight + 100, stdiPhoneWidth, stdiPhoneHeight);
    _onscreenRect = CGRectMake(0, (stdiPhoneHeight*2)/3, stdiPhoneWidth, stdiPhoneHeight);
    _inviteButtonsView = [[UIView alloc] initWithFrame:_offscreenRect];
    [_inviteButtonsView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    
    // Create invite friends label
    UILabel* inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, stdiPhoneWidth, 20)];
    [inviteLabel setTextColor:[UIColor whiteColor]];
    [inviteLabel setFont:[UIFont fontWithName:@"ArialMT" size:15.0f]];
    [inviteLabel setText:@"Choose Invite Method"];
    [inviteLabel setTextAlignment:UITextAlignmentCenter];
    [inviteLabel setBackgroundColor:[UIColor clearColor]];
    [_inviteButtonsView addSubview:inviteLabel];
    
    // Create facebook button
    int index = 0;
    UIButton* facebookButton = [self createInviteButton:@"facebook-post" xpos:[self computeXPosByIndex:index] ypos:[self computeYPosByIndex:index] action:@selector(didPressFacebookButton:)];
    [_inviteButtonsView addSubview:facebookButton];
    
    UILabel* facebookLabel = [self createInviteButtonLabel:facebookButton currentText:@"facebook"];
    [_inviteButtonsView addSubview:facebookLabel];
    
    index++;
    
    // Create email button
    UIButton* emailButton = [self createInviteButton:@"email" xpos:[self computeXPosByIndex:index] ypos:[self computeYPosByIndex:index] action:@selector(didPressEmailButton:)];
    [_inviteButtonsView addSubview:emailButton];
    
    UILabel* emailLabel = [self createInviteButtonLabel:emailButton currentText:@"email"];
    [_inviteButtonsView addSubview:emailLabel];
    
    index++;
    
    // Create SMS button
    UIButton* smsButton = [self createInviteButton:@"text-message" xpos:[self computeXPosByIndex:index] ypos:[self computeYPosByIndex:index] action:@selector(didPressSMSButton:)];
    [_inviteButtonsView addSubview:smsButton];
    
    UILabel* smsLabel = [self createInviteButtonLabel:smsButton currentText:@"SMS"];
    [_inviteButtonsView addSubview:smsLabel];
    
    [self.view addSubview:_inviteButtonsView];
}

- (void)toggleInviteFriendsView:(BOOL)display
{
    if (display)
    {
        [_invisibleLayer addGestureRecognizer:_dismissTap];
        [_invisibleLayer setUserInteractionEnabled:TRUE];
        _btnInvite.enabled = FALSE;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _inviteButtonsView.frame = _onscreenRect;
                         }];
    }
    else
    {
        [_invisibleLayer removeGestureRecognizer:_dismissTap];
        [_invisibleLayer setUserInteractionEnabled:FALSE];
        _btnInvite.enabled = TRUE;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _inviteButtonsView.frame = _offscreenRect;
                         }];
    }
}

- (UIButton*)createInviteButton:(NSString*)imageFile xpos:(CGFloat)xpos ypos:(CGFloat)ypos action:(SEL)action
{
    // Get imagedata
    NSString *filePath = [[NSBundle mainBundle] pathForResource:imageFile ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    UIButton* newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [newButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [newButton setFrame:CGRectMake(xpos, ypos, kButtonSize, kButtonSize)];
    
    return newButton;
}

- (UILabel*)createInviteButtonLabel:(UIButton*)currentButton currentText:(NSString*)currentText
{
    CGFloat additionalButtonWidth = 10;
    CGFloat buttonWidth = currentButton.frame.size.width + additionalButtonWidth;
    CGFloat buttonHeight = 15;
    CGFloat buttonXPos = currentButton.frame.origin.x - (additionalButtonWidth/2);
    CGFloat buttonYPos = currentButton.frame.origin.y + currentButton.frame.size.height + 2;
    
    UILabel* currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonXPos, buttonYPos, buttonWidth, buttonHeight)];
    [currentLabel setTextColor:[UIColor whiteColor]];
    [currentLabel setFont:[UIFont fontWithName:@"ArialMT" size:12.0f]];
    [currentLabel setText:currentText];
    [currentLabel setTextAlignment:UITextAlignmentCenter];
    [currentLabel setBackgroundColor:[UIColor clearColor]];
    
    return currentLabel;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Email Sent"
                                                          message:@"When your friends sign up with PaidPunch using your invite code, you'll earn free credit."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Text Sent"
                                                          message:@"When your friends sign up with PaidPunch using your invite code, you'll earn free credit."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - event actions

- (void)didPressInviteFriendsButton:(id)sender
{
    [self toggleInviteFriendsView:TRUE];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if ([[Templates getInstance] needsRefresh])
        {
            _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"";
            [[Templates getInstance] retrieveTemplatesFromServer:self];
        }
        else
        {
            [self sendInvite];
        }
    }
    else
    {
        // The cancel button was pressed. Clear the alert type
        _alertType = no_response;
    }
}

-(IBAction)didPressFacebookButton:(id)sender
{
    _alertType = facebook_response;
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invite Your Friends"
                                                      message:@"Get free credits by inviting your friends to download the PaidPunch app. Clicking OK will post a invitation to your Facebook wall."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK",nil];
    
    [message show];
}

-(IBAction)didPressEmailButton:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        _alertType = email_response;
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invite Your Friends"
                                                          message:@"Get free credits by inviting your friends to download the PaidPunch app. Clicking OK will open your email client. Fill in your friends' emails and invite them!"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"OK",nil];
        
        [message show];
    }
    else
    {
        // Current device is not configured for email
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Email Available"
                                                          message:@"Your current device does not have an email client configured."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

-(IBAction)didPressSMSButton:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
    {
        _alertType = sms_response;
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invite Your Friends"
                                                          message:@"Get free credits by inviting your friends to download the PaidPunch app. Clicking OK will open your SMS client. Fill in your friends' numbers and invite them!"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"OK",nil];
        
        [message show];
    }
    else
    {
        // Current device is not configured for email
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No SMS Available"
                                                          message:@"Your current device does not have an SMS client configured."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

-(IBAction)didPressNextButton:(id)sender
{
    VoteBusinessesViewController *voteBizViewController = [[VoteBusinessesViewController alloc] init:_popWhenDone];
    [self.navigationController pushViewController:voteBizViewController animated:NO];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (sender == _dismissTap)
    {
        [self toggleInviteFriendsView:FALSE];
    }
    
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type, BOOL success, NSString* message
{
    if(success)
    {
        [self sendInvite];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
}

@end

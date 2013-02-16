//
//  AccountViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAGradientLayer.h>
#import "AccountViewController.h"
#import "ATConnect.h"
#import "BalanceViewController.h"
#import "CreditCardSettingsViewController.h"
#import "HiAccuracyLocator.h"
#import "InfoChangeViewController.h"
#import "InviteFriendsViewController.h"
#import "PaidPunchHomeViewController.h"
#import "Punches.h"
#import "User.h"

static NSUInteger const kSections = 2;
static NSUInteger const kCellsInSection1 = 3;
static NSUInteger const kCellsInSection2 = 5;
static NSUInteger const kSizeOfCells = 37;
static NSString* const kTextSpacing = @"  ";

@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize parentController = _parentController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _networkManager=[[NetworkManager alloc] initWithView:self.view];
    _networkManager.delegate=self;
    
    [self createMainView:[UIColor whiteColor]];
    
    [self createNavBar:@"Back" rightString:nil middle:@"Account Info" isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    [self createSilverBackgroundWithImage];
    
    [self createAccountTable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - private functions

- (void) createAccountTable
{
    CGFloat tableWidth = stdiPhoneWidth - 40;
    CGFloat verticalSpacing = 00;
    CGFloat tableHeight = stdiPhoneHeight - (verticalSpacing * 2) - _lowestYPos;
    CGRect tableViewRect = CGRectMake((stdiPhoneWidth - tableWidth)/2, _lowestYPos + verticalSpacing, tableWidth, tableHeight);
    _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setOpaque:NO];
    [_tableView setScrollEnabled:NO];
    [_tableView setRowHeight:kSizeOfCells];
    
    [_mainView addSubview:_tableView];
}

- (void) showLocationSelector
{
    _locationAlertView = [[UIAlertView alloc] initWithTitle:@"Enter your zip code."
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Current location"
                                                      otherButtonTitles:@"Okay", nil];
    [_locationAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[_locationAlertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[_locationAlertView textFieldAtIndex:0] setKeyboardAppearance:UIKeyboardAppearanceDefault];
    [[_locationAlertView textFieldAtIndex:0] setText:[[User getInstance] zipcode]];
    [_locationAlertView show];
}

- (void) showInfoChangeView
{
    InfoChangeViewController *infoChangeViewController = [[InfoChangeViewController alloc] init];
    [self.navigationController pushViewController:infoChangeViewController animated:NO];
}

- (void) showFreeCreditViews
{
    InviteFriendsViewController *inviteFriendsViewController = [[InviteFriendsViewController alloc] init:TRUE duringSignup:FALSE];
    [self.navigationController pushViewController:inviteFriendsViewController animated:NO];
}

- (void) showBalanceView
{
    BalanceViewController *balanceViewController = [[BalanceViewController alloc] init];
    [self.navigationController pushViewController:balanceViewController animated:NO];
}

- (void) signOut
{
    [[User getInstance] clearUser];
    [[Punches getInstance] forceRefresh];
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initView];
}

- (void) sendFeedbackCheck
{
    ATConnect *connection = [ATConnect sharedConnection];
    [connection presentFeedbackControllerFromViewController:self];
}

- (void) showCreditCardSettings
{
    if([[User getInstance] isPaymentProfileCreated])
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"Retrieving credit card info";
        [_networkManager getProfileRequest:[[User getInstance] userId] withName:@""];
    }
    else
    {
        [self goToCreditCardSettingsView:nil];
    }
}

- (void) showMyCoupons
{
    // BIG NOTE: This is a hacky way of causing the coupons pop-up to show up on returning
    // to the super view, but it's the only way I know of to do it.
    PaidPunchHomeViewController* parent = (PaidPunchHomeViewController*)_parentController;
    [parent setLaunchMyCouponsOnWillAppear:TRUE];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) goToCreditCardSettingsView:(NSString *)maskedId
{
    CreditCardSettingsViewController *creditCardSettingsView = [[CreditCardSettingsViewController alloc] init:maskedId];
    [self.navigationController pushViewController:creditCardSettingsView animated:YES];
}

#pragma mark - Event actions

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Email Sent"
                                                          message:@"Thank you for your feedback"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _locationAlertView)
    {
        [[User getInstance] forceLocationRefresh];
        if (buttonIndex == 0)
        {
            [[User getInstance] setUseZipcodeForLocation:FALSE];
        }
        else if (buttonIndex == 1)
        {
            [[User getInstance] setZipcode:[[alertView textFieldAtIndex:0] text]];
            [[User getInstance] setUseZipcodeForLocation:TRUE];
            
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"Updating zipcode";
            
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            [dict setObject:[[User getInstance] zipcode] forKey:@"zipcode"];
            [[User getInstance] changeInfo:self parameters:dict];
        }
    }
    else if (alertView == _feedbackAlertView)
    {
        if (buttonIndex == 0)
        {
            // Show the composer
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setToRecipients:[[NSArray alloc] initWithObjects:@"tony@paidpunch.com", @"aaron@paidpunch.com", nil]];
            [controller setSubject:@"PaidPunch feedback"];
            if (controller)
            {
                [self presentModalViewController:controller animated:YES];
            }
        }
    }
}

-(void) didFinishGettingProfile:(NSString *)statusCode statusMessage:(NSString *)message withMaskedId:(NSString *)maskedId withPaymentId:(NSString *)paymentId
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if([statusCode isEqualToString:@"00"])
    {
        [self goToCreditCardSettingsView:maskedId];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return kCellsInSection1;
    }
    else
    {
        return kCellsInSection2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PaidPunchSidebarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1.0]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {                
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Manage Credit Card", kTextSpacing];
                break;
                
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Get FREE Credit", kTextSpacing];
                break;
                
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Purchase More Credit", kTextSpacing];
                break;
                
            default:
                NSLog(@"Unknown indexPath.row %d detected in section 1!", indexPath.row);
                break;
        };
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%@My Coupons", kTextSpacing];
                break;
                
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Change My Location", kTextSpacing];
                break;
                
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Settings", kTextSpacing];
                break;
                
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Share Feedback", kTextSpacing];
                break;
                
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Sign Out", kTextSpacing];
                break;
                
            default:
                NSLog(@"Unknown indexPath.row %d detected in section 0!", indexPath.row);
                break;
        }
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0,200,300,244)];
    hView.backgroundColor=[UIColor clearColor];
    
    UILabel *hLabel=[[UILabel alloc] initWithFrame:CGRectMake(15,0,300,44)];
    
    hLabel.backgroundColor=[UIColor clearColor];
    hLabel.textColor = [UIColor grayColor];  // or whatever you want
    hLabel.font = [UIFont boldSystemFontOfSize:17];
    
    switch (section)
    {
        case 0:
            hLabel.text = @"Credits";
            break;
        case 1:
            hLabel.text = @"Account Info";
            break;
        default:
            hLabel.text = @"";
            break;
    }
    
    [hView addSubview:hLabel];
    
    return hView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSizeOfCells;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {                
            case 0:
                [self showCreditCardSettings];
                break;
                
            case 1:
                [self showFreeCreditViews];
                break;
                
            case 2:
                [self showBalanceView];
                break;
                
            default:
                NSLog(@"Unknown indexPath.row %d detected in section 1!", indexPath.row);
                break;
        };
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                [self showMyCoupons];
                break;
                
            case 1:
                [self showLocationSelector];
                break;
                
            case 2:
                [self showInfoChangeView];
                break;
                
            case 3:
                [self sendFeedbackCheck];
                break;
                
            case 4:
                [self signOut];
                break;
                
            default:
                NSLog(@"Unknown indexPath.row %d detected in section 0!", indexPath.row);
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type success:(BOOL)success message:(NSString*)message
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];

    // Display no message. Even if the update to server fails, this is only to update the user's
    // zipcode and isn't a catastrophic failure.
}

@end

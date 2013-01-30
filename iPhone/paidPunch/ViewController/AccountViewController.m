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
#import "InfoChangeViewController.h"
#import "HiAccuracyLocator.h"
#import "AccountViewController.h"
#import "User.h"

static NSUInteger const kSections = 2;
static NSUInteger const kCellsInSection1 = 4;
static NSUInteger const kCellsInSection2 = 2;
static NSUInteger const kSizeOfCells = 40;
static NSString* const kTextSpacing = @"  ";

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createMainView:[UIColor blackColor]];
    
    [self createNavBar:@"Back" rightString:nil middle:@"Account Info" isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    // Add a background to the mainview
    UIImageView* backgrdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    backgrdImg.frame = CGRectMake(0, _lowestYPos, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos);
    [_mainView addSubview:backgrdImg];
    
    [self createAccountTable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - private functions

- (void)createMainView:(UIColor*)backgroundColor
{
    CGRect mainRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    _mainView = [[UIView alloc] initWithFrame:mainRect];
    
    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.frame = _mainView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor blackColor] CGColor],
                       (id)[[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0] CGColor], nil];
    [_mainView.layer insertSublayer:gradient atIndex:0];
    
    self.view = _mainView;
}

- (void) createAccountTable
{
    CGFloat tableWidth = stdiPhoneWidth - 40;
    CGFloat verticalSpacing = 25;
    CGFloat tableHeight = stdiPhoneHeight - (verticalSpacing * 2) - _lowestYPos;
    CGRect tableViewRect = CGRectMake((stdiPhoneWidth - tableWidth)/2, _lowestYPos + verticalSpacing, tableWidth, tableHeight);
    _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setOpaque:NO];
    [_tableView setScrollEnabled:NO];
    
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

#pragma mark - Event actions

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _locationAlertView)
    {
        if (buttonIndex == 0)
        {
            // Start by locating user
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.labelText = @"Locating user";
            
            [[HiAccuracyLocator getInstance] setDelegate:self];
            [[HiAccuracyLocator getInstance] startUpdatingLocation];
        }
        else if (buttonIndex == 1)
        {
            [[User getInstance] setZipcode:[[alertView textFieldAtIndex:0] text]];
            // TODO: refresh business list
            //[self refreshBusinessList];
        }
    }
}

#pragma mark - HiAccuracyLocatorDelegate
- (void) locator:(HiAccuracyLocator *)locator didLocateUser:(BOOL)didLocateUser reason:(StopReason)reason
{
    if(didLocateUser)
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:[[HiAccuracyLocator getInstance] bestLocation] completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"**reverseGeocodeLocation:completionHandler: Completion Handler called!");
            
            if (error)
            {
                NSLog(@"**Geocode failed with error: %@", error);
                return;
                
            }
            
            if(placemarks && placemarks.count > 0)
                
            {
                //do something
                CLPlacemark *topResult = [placemarks objectAtIndex:0];
                NSLog(@"**Geocode successful; zip code: %@", [topResult postalCode]);
                
                [[User getInstance] setZipcode:[topResult postalCode]];
                [[User getInstance] saveUserData];
                
                // TODO: Refresh business list
                //[self refreshBusinessList];
            }
        }];
    }
    else
    {
        if (reason == kStopReasonDenied)
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"We could not find your current location. Make sure you are sharing your location with us. Go to Settings >> Location Services >> PaidPunch." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Unable to locate!" message:@"We were not find your current location. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSizeOfCells;
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
                
            default:
                NSLog(@"Unknown indexPath.row %d detected in section 0!", indexPath.row);
                break;
        };
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Get FREE Credit", kTextSpacing];
                break;
                
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Purchase More Credit", kTextSpacing];
                break;
                
            default:
                NSLog(@"Unknown indexPath.row %d detected in section 1!", indexPath.row);
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
    hLabel.shadowColor = [UIColor grayColor];
    hLabel.shadowOffset = CGSizeMake(0.5,1);  // closest as far as I could tell
    hLabel.textColor = [UIColor whiteColor];  // or whatever you want
    hLabel.font = [UIFont boldSystemFontOfSize:17];
    
    switch (section)
    {
        case 0:
            hLabel.text = @"Account Info";
            break;
        case 1:
            hLabel.text = @"Credits";
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
                
                break;
                
            case 1:
                [self showLocationSelector];
                break;
                
            case 2:
                [self showInfoChangeView];
                break;
                
            case 3:
                
                break;
                
            default:
                NSLog(@"Unknown indexPath.row %d detected in section 0!", indexPath.row);
                break;
        };
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                
                break;
                
            case 1:
                
                break;
                
            default:
                NSLog(@"Unknown indexPath.row %d detected in section 1!", indexPath.row);
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
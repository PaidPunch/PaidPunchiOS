//
//  SidebarViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "HiAccuracyLocator.h"
#import "PPRevealSideViewController.h"
#import "SidebarViewController.h"
#import "User.h"

static NSUInteger const kSections = 2;
static NSUInteger const kCellsInSection1 = 7;
static NSUInteger const kCellsInSection2 = 1;
static NSUInteger const kSizeOfCellsInSection1 = 50;
static NSString* const kTextSpacing = @"  ";

@interface SidebarViewController ()

@end

@implementation SidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - private functions

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
            
            // Pop the sidebar to go back to main view
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
    }
    else
    {
        // This codepath handles error alert views from the locating user call
        // Pop the sidebar to go back to main view
        [self.revealSideViewController popViewControllerAnimated:YES];
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
                
                // TODO: Refresh business list
                //[self refreshBusinessList];
                
                [self.revealSideViewController popViewControllerAnimated:YES];
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
    if (indexPath.section == 0)
    {
        return kSizeOfCellsInSection1;
    }
    else
    {
        return (stdiPhoneHeight - (kSizeOfCellsInSection1 * kCellsInSection1));
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
    
    [cell.contentView setBackgroundColor:[UIColor orangeColor]];
    if (indexPath.section == 0)
    {
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
        switch (indexPath.row)
        {
            case 0:
                // Can't select name
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = [[User getInstance] username];
                [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                break;
                
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Change My Location", kTextSpacing];
                break;
                
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"%@My Coupons", kTextSpacing];
                break;
                
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Share Feedback", kTextSpacing];
                break;
                
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Get FREE Credit", kTextSpacing];
                break;
                
            case 5:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Purchase More Credit", kTextSpacing];
                break;
                
            case 6:
                cell.textLabel.text = [NSString stringWithFormat:@"%@Settings", kTextSpacing];
                break;
                
            default:
                NSLog(@"Unknown indexPath.row %d detected!", indexPath.row);
                break;
        };
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.textLabel setBackgroundColor:[UIColor orangeColor]];
    }
    else
    {
        // Can't select the bottom large cell
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 1:
                [self showLocationSelector];
                break;
                
            case 2:
                break;
                
            case 3:
                break;
                
            case 4:
                break;
                
            case 5:
                break;
                
            case 6:
                break;
                
            default:
                NSLog(@"Unknown indexPath.row %d detected!", indexPath.row);
                break;
        };
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

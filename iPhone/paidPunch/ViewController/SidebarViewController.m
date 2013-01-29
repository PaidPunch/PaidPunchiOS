//
//  SidebarViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#include "CommonDefinitions.h"
#import "SidebarViewController.h"
#import "User.h"

static NSUInteger const kSections = 2;
static NSUInteger const kCellsInSection1 = 6;
static NSUInteger const kCellsInSection2 = 1;
static NSUInteger const kSizeOfCellsInSection1 = 50;
static NSString* const kTextSpacing = @"   ";

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
        switch (indexPath.row)
        {
            case 0:
                // Can't select name
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = [[User getInstance] username];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

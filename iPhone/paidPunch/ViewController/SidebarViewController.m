//
//  SidebarViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/28/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "SidebarViewController.h"

static CGFloat const stdiPhoneWidth = 320.0;
static CGFloat const stdiPhoneHeight = 480.0;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.navigationController)
        cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    else
        cell.textLabel.text = [NSString stringWithFormat:@"Left %d", indexPath.row];
    
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

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect mainRect = CGRectMake(0, 0, stdiPhoneWidth, stdiPhoneHeight);
    UIView* _mainView = [[UIView alloc] initWithFrame:mainRect];
    self.view = _mainView;

    NSString* inviteText = @"Testing";
    
    // Create non-bold label
    UIFont* testFont = [UIFont fontWithName:@"ArialMT" size:16.0f];
    CGSize sizeInviteText = [inviteText sizeWithFont:testFont
                                   constrainedToSize:CGSizeMake(stdiPhoneWidth, CGFLOAT_MAX)
                                       lineBreakMode:UILineBreakModeWordWrap];
    UILabel* inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, sizeInviteText.width, sizeInviteText.height)];
    inviteLabel.text = inviteText;
    inviteLabel.backgroundColor = [UIColor clearColor];
    inviteLabel.textColor = [UIColor blackColor];
    [inviteLabel setNumberOfLines:1];
    [inviteLabel setFont:testFont];
    inviteLabel.textAlignment = UITextAlignmentCenter;
    [_mainView addSubview:inviteLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

@end

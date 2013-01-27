//
//  VoteBusinessesViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/25/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "ProposedBusinesses.h"
#import "Utilities.h"
#import "VoteBusinessesViewController.h"

@interface VoteBusinessesViewController ()

@end

@implementation VoteBusinessesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create nav bar on top
    [self createNavBar:@"Back" rightString:@"Done" middle:@"Give Free Credit" isMiddleImage:FALSE leftAction:nil rightAction:@selector(didPressDoneButton:)];
    
    // Create green notification bar
    [self createGreenNotificationBar:@"Vote for the businesses you want to be on PaidPunch. When they join, you get $2 each!"];
    
    // Create suggest button
    [self createSuggestBusinessButton];
    
    // load proposed businesses if necessary
    if ([[ProposedBusinesses getInstance] needsRefresh])
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"";
        
        [[ProposedBusinesses getInstance] retrieveProposedBusinesses:self];
    }
    else
    {
        [self displayProposeBusinessesList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions

- (void)createSuggestBusinessButton
{
    UIFont* textFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"green-suggest-button" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIButton* suggestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect originalRect = CGRectMake(0, _lowestYPos + 10, image.size.width, image.size.height);
    CGRect finalRect = [Utilities resizeProportionally:originalRect maxWidth:(stdiPhoneWidth - 60) maxHeight:stdiPhoneHeight];
    finalRect.origin.x = (stdiPhoneWidth - finalRect.size.width)/2;
    
    suggestButton.frame = finalRect;
    [suggestButton setBackgroundImage:image forState:UIControlStateNormal];
    [suggestButton setTitle:@"Suggest A Business" forState:UIControlStateNormal];
    [suggestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    suggestButton.titleLabel.font = textFont;
    [suggestButton addTarget:self action:@selector(didPressSuggestBusinessButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainView addSubview:suggestButton];
    
    _lowestYPos = finalRect.origin.y + finalRect.size.height;
}

- (void)displayProposeBusinessesList
{
    CGRect tableViewRect = CGRectMake(0, _lowestYPos + 10, stdiPhoneWidth, stdiPhoneHeight - _lowestYPos);
    _tableView = [[ProposedBusinessesView alloc] initWithFrame:tableViewRect];
    
    [_mainView addSubview:_tableView];
}

#pragma mark - event actions

- (void)didPressDoneButton:(id)sender
{
}

- (void)didPressSuggestBusinessButton:(id)sender
{
}

#pragma mark - HttpCallbackDelegate
- (void) didCompleteHttpCallback:(NSString*)type, BOOL success, NSString* message
{
    if(success)
    {
        [self displayProposeBusinessesList];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
}

@end

//
//  VoteBusinessesViewController.m
//  paidPunch
//
//  Created by Aaron Khoo on 1/25/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "VoteBusinessesViewController.h"

@interface VoteBusinessesViewController ()

@end

@implementation VoteBusinessesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create nav bar on top
    [self createNavBar:@"Back" rightString:@"Done" middle:@"Give Free Credit" isMiddleImage:FALSE leftAction:nil rightAction:nil];
    
    // Create green notification bar
    [self createGreenNotificationBar:@"Vote for the businesses you want to be on PaidPunch. When they join, you get $2 each!"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

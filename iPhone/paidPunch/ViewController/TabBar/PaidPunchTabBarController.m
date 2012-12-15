//
//  PaidPunchTabBarController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "PaidPunchTabBarController.h"
#import "AppDelegate.h"

@implementation PaidPunchTabBarController

@synthesize tabBarController;
@synthesize myPunchesNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationController.view setNeedsLayout];
        [self setWantsFullScreenLayout:YES];
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
        [self.view addSubview:tabBarController.view];
        networkManager=[[NetworkManager alloc] initWithView:tabBarController.view];
        networkManager.delegate=self;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {	
    NSLog(@"In dealloc of PaidPunchTabBarController");
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods Implementation

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [viewController viewWillAppear:YES];
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishLoadingAppURL:(NSString *)url
{   
}

#pragma mark Facebook delegates

- (void)fbDidLogin
{
    // TODO: Still needs to be implemented
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    // TODO: Still needs to be implemented
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    // TODO: Still needs to be implemented
}

- (void)fbDidLogout
{
    // TODO: Still needs to be implemented
}

- (void)fbSessionInvalidated
{
    // TODO: Still needs to be implemented
}

#pragma mark -

-(void) requestAppIp
{
    [networkManager appIpRequest];
}
@end

//
//  SearchPageViewController.h
//  paidPunch
//
//  Created by Alexander on 7/27/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "DatabaseManager.h"
#import "SearchListViewController.h"
#import "DatabaseManager.h"
#import "InfoExpert.h"
#import "JSON.h"

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, NetworkManagerDelegate, CLLocationManagerDelegate>
{
    UITableView         *searchTable;
    NSMutableArray      *listOfRanges;
    
    NetworkManager      *networkManager;
    CLLocationManager   *locationMgr;
    CLLocation          *currentLocation;
    NSArray             *businessList;
    NSString            *userZipCode; // How do store?
}

- (IBAction)showLocationSelector:(id)sender;
- (IBAction)showMap:(id)sender;

- (CLLocationCoordinate2D)geoCodeUsingAddress:(NSString *)address;
- (void)refreshBusinessList;

@property (nonatomic, retain) IBOutlet UITableView *searchTable;

@end

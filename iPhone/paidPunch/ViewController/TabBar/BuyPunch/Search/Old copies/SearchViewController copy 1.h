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
#import "PunchUsedViewController.h"
#import "MarqueeLabel.h"

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, NetworkManagerDelegate, CLLocationManagerDelegate>
{
    UITableView         *searchTable;
    UIImageView         *noBusinessesErrorImage;
    NSMutableArray      *listOfRanges;
    
    NetworkManager      *networkManager;
    CLLocationManager   *locationMgr;
    CLLocation          *currentLocation;
    NSArray             *businessList;
    NSMutableDictionary *businessOfferDetails;
    NSString            *userZipCode; // How do store?
}

- (IBAction)showLocationSelector:(id)sender;
- (IBAction)showMap:(id)sender;

- (CLLocationCoordinate2D)geoCodeUsingAddress:(NSString *)address;
- (void)refreshBusinessList;
- (void)goToPunchCardOfferView:(NSString *)offerQrCode punchCardDetails:(PunchCard *)punchCard selectedIndex:(NSIndexPath *)index;

@property (nonatomic, retain) IBOutlet UITableView *searchTable;
@property (nonatomic, retain) IBOutlet  UIImageView *noBusinessesErrorImage;

@end

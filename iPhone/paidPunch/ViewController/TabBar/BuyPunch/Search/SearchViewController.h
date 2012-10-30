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
#import "SearchByCategoryViewController.h"
#import "EGORefreshTableHeaderView.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, NetworkManagerDelegate, CLLocationManagerDelegate, EGORefreshTableHeaderDelegate>
{
    UITableView         *searchTable;
    UIImageView         *noBusinessesErrorImage;
    NSMutableArray      *listOfRanges;
    
    NetworkManager      *networkManagerBusinessList;
//    NetworkManager      *networkManagerBusinessOffer;
    NSMutableDictionary *networkManagerBusinessOfferDict;
    CLLocationManager   *locationMgr;
    CLLocation          *currentLocation;
    NSArray             *businessList;
    NSMutableDictionary *businessOfferDetails;
    NSMutableString            *userZipCode;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
}

- (IBAction)showLocationSelector:(id)sender;
- (IBAction)showMap:(id)sender;

- (CLLocationCoordinate2D)geoCodeUsingAddress:(NSString *)address;
- (void)refreshBusinessList;
- (void)goToPunchCardOfferView:(NSString *)offerQrCode punchCardDetails:(PunchCard *)punchCard selectedIndex:(NSIndexPath *)index;

@property (nonatomic, retain) IBOutlet UITableView *searchTable;
@property (nonatomic, retain) IBOutlet  UIImageView *noBusinessesErrorImage;

@property(nonatomic, retain) MKReverseGeocoder *geoCoder;

@end
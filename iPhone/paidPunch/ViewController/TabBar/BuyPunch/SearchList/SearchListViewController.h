//
//  SearchListViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 27/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerXmlResponseConstants.h"
#import "Business.h"
#import "DatabaseManager.h"
#import "PunchCardOfferViewController.h"
#import "PunchCard.h"
#import "OverlayViewController.h"
#import "SearchListViewCell.h"
#import "Zipcodes_Cache.h"

@interface SearchListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate,NetworkManagerDelegate,CLLocationManagerDelegate>
{
    int selectedIndex;
    NetworkManager *networkManager;
    
    int locateViewFlag;
    int settingsViewFlag;
    
    UIImage *numberPadDoneImageNormal;
    UIImage *numberPadDoneImageHighlighted;
    UIButton *numberPadDoneButton;
    CLLocationManager *locationMgr;
    CLLocation *currentLocation;
    
    BOOL currentBtnClicked;
    BOOL shouldGoToPunchCardOfferPage;
    
    UIActivityIndicatorView *activityIndicator;
    
    MBProgressHUD *popupHUD;
}
@property (retain, nonatomic) IBOutlet UIView *locateView;
@property (retain, nonatomic) IBOutlet UIView *settingsView;
@property (retain, nonatomic) IBOutlet UILabel *categoryLbl;
@property (retain, nonatomic) IBOutlet UIImageView *backImageView;
@property (retain, nonatomic) IBOutlet UIView *backView;
@property (retain, nonatomic) IBOutlet UITextField *totalMilesTxtField;
@property (retain, nonatomic) IBOutlet UITextField *cityTxtField;
@property (retain, nonatomic) IBOutlet UILabel *noBusinessFoundLbl;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *businessListTableView;
@property (retain, nonatomic) NSString *searchType;
@property (retain, nonatomic) NSString *category;
@property (retain, nonatomic) NSString *businessName;
@property (retain, nonatomic) NSString *cityOrZipCode;
@property (retain, nonatomic) NSArray *businessList;
@property (retain, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (retain, nonatomic) CLLocation *userLocation;

@property (nonatomic, retain) UIImage *numberPadDoneImageNormal;
@property (nonatomic, retain) UIImage *numberPadDoneImageHighlighted;
@property (nonatomic, retain) UIButton *numberPadDoneButton;

@property (nonatomic,retain) CLLocationManager *locationMgr;
@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic,retain) CLLocation *reverseGeoLocation;
@property (retain, nonatomic) NSString *searchFilterType;
@property(retain,nonatomic) UIView *activity;

- (IBAction)currentLocationBtnTouchUpInsideHandler:(id)sender;

- (void)goToPunchCardOfferView:(NSString *)offerQrCode punchCardDetails:(PunchCard *)punchCard;
- (void)getBusinessOffer;
- (id)init:(NSString *)sType withCategory:(NSString *)sCategory withTotalMiles:(NSNumber *)sMiles withCurrentlocation:(CLLocation *)uLocation withBusinessName:(NSString *)bName withCityOrZipCode:(NSString *)cityZipcode;

- (CLLocationCoordinate2D) geoCodeUsingAddress: (NSString *) address;

- (IBAction)showMap:(id)sender;

- (Business *)getBizWithName:(NSString *)name;
-(void) showPopup;
-(void) removePopup;

@end

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
@property (strong, nonatomic) IBOutlet UIView *locateView;
@property (strong, nonatomic) IBOutlet UIView *settingsView;
@property (strong, nonatomic) IBOutlet UILabel *categoryLbl;
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UITextField *totalMilesTxtField;
@property (strong, nonatomic) IBOutlet UITextField *cityTxtField;
@property (strong, nonatomic) IBOutlet UILabel *noBusinessFoundLbl;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *businessListTableView;
@property (strong, nonatomic) NSString *searchType;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *businessName;
@property (strong, nonatomic) NSString *cityOrZipCode;
@property (strong, nonatomic) NSArray *businessList;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (strong, nonatomic) CLLocation *userLocation;

@property (nonatomic, strong) UIImage *numberPadDoneImageNormal;
@property (nonatomic, strong) UIImage *numberPadDoneImageHighlighted;
@property (nonatomic, strong) UIButton *numberPadDoneButton;

@property (nonatomic,strong) CLLocationManager *locationMgr;
@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocation *reverseGeoLocation;
@property (strong, nonatomic) NSString *searchFilterType;
@property(strong,nonatomic) UIView *activity;

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

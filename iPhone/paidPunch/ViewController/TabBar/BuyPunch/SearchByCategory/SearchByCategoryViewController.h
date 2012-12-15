//
//  SearchViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 27/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "SearchListViewController.h"
#import "DatabaseManager.h"
#import "JSON.h"
#import "EGORefreshTableHeaderView.h"
#import "SearchViewController.h"

@interface SearchByCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NetworkManagerDelegate,CLLocationManagerDelegate, EGORefreshTableHeaderDelegate>
{
    NetworkManager *networkManager;
    int miles;
    CLLocationManager *locationMgr;
    CLLocation *currentLocation;
    
    int locateViewFlag;
    int settingsViewFlag;
    
    UIImage *numberPadDoneImageNormal;
    UIImage *numberPadDoneImageHighlighted;
    UIButton *numberPadDoneButton;
    
    int selectedIndex;
    BOOL currentBtnClicked;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    MBProgressHUD *popupHUD;
    
    //int searchCriteria; //1. current location 2.city 3.zipcode 
}

@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UIView *locateView;
@property (strong, nonatomic) IBOutlet UIView *settingsView;
@property (strong, nonatomic) IBOutlet UITextField *totalMilesTxtField;
@property (strong, nonatomic) NSArray *businessList;
@property (strong, nonatomic) IBOutlet UITextField *cityTxtField;
@property (nonatomic,strong) CLLocationManager *locationMgr;
@property (nonatomic,strong) CLLocation *currentLocation;
//@property(retain,nonatomic) UIView *activity;

@property (nonatomic, strong) UIImage *numberPadDoneImageNormal;
@property (nonatomic, strong) UIImage *numberPadDoneImageHighlighted;
@property (nonatomic, strong) UIButton *numberPadDoneButton;

@property (strong, nonatomic) NSDate *lastRefreshTime;

- (IBAction)goBack:(id)sender;

- (IBAction)currentLocationBtnTouchUpInsideHandler:(id)sender;
- (IBAction)numberPadDoneButton:(id)sender;

- (void)updateKeyboardButtonFor:(UITextField *)textField;
- (void)loadBusinessList;
- (void)goToSearchListView:(NSString *)searchType withCategory:(NSString *)category withTotalMiles:(NSNumber *)sMiles;

-(void)showPopup;
-(void)removePopup;

@end

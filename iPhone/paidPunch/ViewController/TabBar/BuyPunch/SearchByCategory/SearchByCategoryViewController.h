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
#import "InfoExpert.h"
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

@property (retain, nonatomic) IBOutlet UITableView *searchTableView;
@property (retain, nonatomic) IBOutlet UIView *locateView;
@property (retain, nonatomic) IBOutlet UIView *settingsView;
@property (retain, nonatomic) IBOutlet UITextField *totalMilesTxtField;
@property (retain, nonatomic) NSArray *businessList;
@property (retain, nonatomic) IBOutlet UITextField *cityTxtField;
@property (nonatomic,retain) CLLocationManager *locationMgr;
@property (nonatomic,retain) CLLocation *currentLocation;
//@property(retain,nonatomic) UIView *activity;

@property (nonatomic, retain) UIImage *numberPadDoneImageNormal;
@property (nonatomic, retain) UIImage *numberPadDoneImageHighlighted;
@property (nonatomic, retain) UIButton *numberPadDoneButton;

@property (retain, nonatomic) NSDate *lastRefreshTime;

- (IBAction)goBack:(id)sender;

- (IBAction)currentLocationBtnTouchUpInsideHandler:(id)sender;
- (IBAction)numberPadDoneButton:(id)sender;

- (void)updateKeyboardButtonFor:(UITextField *)textField;
- (void)loadBusinessList;
- (void)goToSearchListView:(NSString *)searchType withCategory:(NSString *)category withTotalMiles:(NSNumber *)sMiles;

-(void)showPopup;
-(void)removePopup;

@end

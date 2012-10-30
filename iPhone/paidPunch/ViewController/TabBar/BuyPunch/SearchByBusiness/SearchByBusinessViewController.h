//
//  SearchByBusinessViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "InfoExpert.h"
#import "Business.h"
#import "PunchCardOfferViewController.h"
#import "OverlayViewController.h"
#import "PunchCard.h"
#import "Reachability.h"

@interface SearchByBusinessViewController : UIViewController<NetworkManagerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray *businessList;
    OverlayViewController *ovController;
    BOOL searching;
	BOOL letUserSelectRow;
    NSMutableArray *filteredListOfItems;
    NetworkManager *networkManager;
    NSString *qrCode;
    int flag;
}
@property (retain, nonatomic) IBOutlet UITableView *businessListTableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain,nonatomic) NSArray *businessList;
@property(nonatomic,retain) NSMutableArray *filteredListOfItems;

-(void) searchTableView;
-(void) doneSearching_Clicked:(id)sender;
-(void) loadBusinessList;
-(void) goToPunchCardOfferView:(NSString *)offerQrCode punchCardDetails:(PunchCard *)punchCard;
-(void) getBusinessOffer;
@end

//
//  FeedsTableViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 04/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "NetworkManager.h"
#import "Feed.h"
#import "FeedsViewCell.h"
#import "NSAttributedString+Attributes.h"

typedef enum{
    kFeedSearchSetting_Everyone = 0,
	kFeedSearchSetting_Friends,
} FeedSearchSetting;

@interface FeedsTableViewController : UIViewController <EGORefreshTableHeaderDelegate,UITableViewDelegate,
UITableViewDataSource,NetworkManagerDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;

    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes 
    BOOL _reloading;
    
    NetworkManager *networkManager;
    
    int selectedIndex;
    int cnt;
    
    FeedSearchSetting selectedSearchSetting;
}

@property(nonatomic,strong) UISegmentedControl *filterSegementedControl;
@property (strong, nonatomic) NSArray *feedsList;
@property (nonatomic, strong) UIImageView *topBar;
@property (nonatomic, strong) IBOutlet UITableView *feedsTableView;
@property (nonatomic, strong) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong) IBOutlet UIImageView *segmentedControl;

- (IBAction)setSearchByFriend:(id)sender;
- (IBAction)setSearchByEveryone:(id)sender;

- (void)loggedIn;
- (void)getFeeds:(NSDictionary *)result;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

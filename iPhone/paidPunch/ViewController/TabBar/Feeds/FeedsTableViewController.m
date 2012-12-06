//
//  FeedsTableViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 04/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "FeedsTableViewController.h"

@implementation FeedsTableViewController
@synthesize feedsList;
@synthesize feedsTableView;
@synthesize refreshButton;
@synthesize segmentedControl;

#define kCellHeight		70.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    cnt=0;
    
    self.feedsTableView.backgroundColor = [UIColor clearColor];
	self.feedsTableView.sectionFooterHeight = 0;
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;

	if (_refreshHeaderView == nil) {
		
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.feedsTableView.bounds.size.height, self.view.frame.size.width, self.feedsTableView.bounds.size.height) isForSearchView:kEGOType_Regular];
		view.delegate = self;
		[self.feedsTableView addSubview:view];
		_refreshHeaderView = view;
		
	}

    selectedIndex = kFeedSearchSetting_Everyone;
    selectedSearchSetting = kFeedSearchSetting_Everyone;
    
    self.navigationController.navigationBarHidden = YES;
	
    //  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *s=[defaults objectForKey:@"LoggedInFromFacebook"];
    
    if([s isEqualToString:@"YES"])
    {
        [[FacebookFacade sharedInstance]setFeedsViewController:self];
        [[FacebookFacade sharedInstance] apiLogin];
    }
    else
    {
        [networkManager loadFeeds:nil withFriendsList:nil];
    }
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	_refreshHeaderView = nil;
}


#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *feedsViewCellIdentifier = @"FeedsViewCellIdentifier";
    
    FeedsViewCell *cell = (FeedsViewCell *)[tableView dequeueReusableCellWithIdentifier:feedsViewCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedsViewCell" owner:self options:nil];
        cell  = (FeedsViewCell *)[nib objectAtIndex:0];
    }
    
	cell.selectionStyle=UITableViewCellSelectionStyleNone;    
    //cell.contentsWebView.scrollView.scrollEnabled=NO;
    cell.contentsWebView.userInteractionEnabled=FALSE;
	// Configure the cell.
    Feed *feedDetails=[feedsList objectAtIndex:indexPath.row];
    NSString* txt=@"";
    
    NSTimeZone *tz1 = [NSTimeZone systemTimeZone];
    NSInteger sec1 = [tz1 secondsFromGMTForDate: [NSDate date]];
    NSDate *date=[NSDate dateWithTimeInterval: sec1 sinceDate: feedDetails.time_stamp];
    
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger sec = [tz secondsFromGMTForDate: [NSDate date]];
    NSDate *dt=[NSDate dateWithTimeInterval: sec sinceDate: [NSDate date]];
    
    NSTimeInterval time=[dt timeIntervalSinceDate:date];
    /* NSDate* sourceDate = [NSDate date];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
    */

    int days=time/60/60/24;
    
    int hours=time/60/60;
    int minutes=time/60;
    int seconds=time;
    NSString *timeStr=@"";
    if(days > 0)
    {
        if(days==1)
            timeStr=[NSString stringWithFormat:@"%d day ago",days];
        else
            timeStr=[NSString stringWithFormat:@"%d days ago",days];
    }
    else
        if(hours > 0)
        {
            if(hours==1)
                timeStr=[NSString stringWithFormat:@"%d hour ago",hours];
            else
                timeStr=[NSString stringWithFormat:@"%d hours ago",hours];
        }
        else
            if(minutes > 0)
            {
                if(minutes==1)
                    timeStr=[NSString stringWithFormat:@"%d minute ago",minutes];
                else
                    timeStr=[NSString stringWithFormat:@"%d minutes ago",minutes];
            }
            else
                if(seconds >0)
                {
                    if(seconds==1)
                        timeStr=[NSString stringWithFormat:@"%d second ago",seconds];
                    else
                        timeStr=[NSString stringWithFormat:@"%d seconds ago",seconds];
                }
    
    if([feedDetails.action.lowercaseString isEqualToString:@"punched"])
    {
        txt=[NSString stringWithFormat:@"<html><head></head><body><p><font face='helvetica' size=3><b><font color=#f47b27>%@</font></b> %@ <b><font color=#f47b27>$%.2f</font></b> at <b><font color=#f47b27>%@</font></b> saving <b>$%.2f.</b> <font color=#727272 size=2>%@</font></font></p></body></html>",feedDetails.name,feedDetails.action,[feedDetails.each_punch_value doubleValue],feedDetails.business_name,[feedDetails.discount_value_of_each_punch doubleValue],timeStr];
    }
    if([feedDetails.action.lowercaseString isEqualToString:@"mystery"])
    {
        /*txt=[NSString stringWithFormat:@"<html><head></head><body><p><font face='helvetica' size=3><b><font color=#f47b27>%@</font></b> %@ Punched<b><font color=#0072b4> %@ with purchase of $%.2f or more</font></b> at <b><font color=#f47b27>%@.</font></b> <font color=#727272 size=2>%@</font></font></p></body></html>",feedDetails.name,feedDetails.action,feedDetails.offer,[feedDetails.selling_price doubleValue],feedDetails.business_name,timeStr];*/
        
        txt=[NSString stringWithFormat:@"<html><head></head><body><p><font face='helvetica' size=3><b><font color=#f47b27>%@</font></b> unlocked a <b><font color=#f47b27>%@</font></b> %@ Punch and got <b><font color=#0072b4>%@</font></b>. <font color=#727272 size=2>%@</font></font></p></body></html>",feedDetails.name,feedDetails.business_name,feedDetails.action,feedDetails.offer,timeStr];
    }
    if([feedDetails.action.lowercaseString isEqualToString:@"bought"])
    {
        txt=[NSString stringWithFormat:@"<html><head></head><body><p><font face='helvetica' size=3><b><font color=#f47b27>%@</font></b> %@ %@ <b><font color=#f47b27>$%.2f</font></b> <b><font color=#f47b27>%@</font></b> Punches for <b>$%.2f</b> each. <font color=#727272 size=2>%@</font></font></p></body></html>",feedDetails.name,feedDetails.action,[feedDetails.no_of_punches stringValue],[feedDetails.each_punch_value doubleValue],feedDetails.business_name,[feedDetails.actual_value_of_each_punch doubleValue],timeStr];
    }
    if([feedDetails.action.lowercaseString isEqualToString:@"free"])
    {
        txt=[NSString stringWithFormat:@"<html><head></head><body><p><font face='helvetica' size=3><b><font color=#f47b27>%@</font></b> unlocked a %@ <b><font color=#f47b27>%@</font></b> Punch. <font color=#727272 size=2>%@</font></font></p></body></html>",feedDetails.name,feedDetails.action,feedDetails.business_name,timeStr];
    }
    
    [cell.contentsWebView loadHTMLString:txt baseURL:nil];
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate methods Implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	return [NSString stringWithFormat:@"Section %i", section];
	
}*/


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.feedsTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods Implementation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate methods Implementation

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *s=[defaults objectForKey:@"LoggedInFromFacebook"];
    
    if([s isEqualToString:@"YES"])
    {
        [[FacebookFacade sharedInstance]setFeedsViewController:self];
        [[FacebookFacade sharedInstance] apiLogin];
    }
    else
    {
        [networkManager loadFeeds:nil withFriendsList:nil];
    }
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishLoadingFeeds:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode rangeOfString:@"00"].location == NSNotFound)
    {
        
    }
    else
    {
        NSLog(@"%d",selectedIndex);
        if(selectedIndex==1)
        {
            self.feedsList=[[DatabaseManager sharedInstance] getFriendsFeeds];
        }
        if(selectedIndex==0)
        {
            self.feedsList=[[DatabaseManager sharedInstance] getAllFeeds];
        }
    }
    [self.feedsTableView reloadData];
    //  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.feedsTableView];
    
}

-(void) didConnectionFailed :(NSString *)responseStatus
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.feedsTableView];
}



#pragma mark -

- (IBAction)refreshBtnTouchUpInsideHandler:(id)sender 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *s=[defaults objectForKey:@"LoggedInFromFacebook"];
    
    if([s isEqualToString:@"YES"])
    {
        [[FacebookFacade sharedInstance]setFeedsViewController:self];
        [[FacebookFacade sharedInstance] apiLogin];
    }
    else
    {
        [networkManager loadFeeds:nil withFriendsList:nil];
    }

}

- (IBAction)filterSegmentedControlValueChangeEventHandler:(id)sender {
    
    selectedIndex = selectedSearchSetting;
    
    NSArray *arr=[[DatabaseManager sharedInstance] getAllFeeds];
    if(cnt<1)
    {
        cnt++;
    }
    else
    {
    }
    if(selectedIndex==0)
    {
        if([arr count]>0)
        {
            self.feedsList=[[DatabaseManager sharedInstance] getAllFeeds];
        }
        [self.feedsTableView reloadData];
    }
    if(selectedIndex==1)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *s=[defaults objectForKey:@"LoggedInFromFacebook"];
        
        if([s isEqualToString:@"YES"])
        {
            if([arr count]>0)
            {
                self.feedsList=[[DatabaseManager sharedInstance] getFriendsFeeds];
            }
            else
            {
                [[FacebookFacade sharedInstance]setFeedsViewController:self];
                [[FacebookFacade sharedInstance] apiLogin];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"To View what your friends are doing sign in with facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            self.feedsList=[[DatabaseManager sharedInstance] getFriendsFeeds];
            
        }
        [self.feedsTableView reloadData];
    }
}

#pragma mark - 

- (IBAction)setSearchByFriend:(id)sender {
    NSLog(@"Doing things friends sel: %d friends:%d", selectedSearchSetting, kFeedSearchSetting_Friends);
    [segmentedControl setImage:[UIImage imageNamed:@"FeedSegmentedControlOne.png"]];
    selectedSearchSetting = kFeedSearchSetting_Friends;
    selectedIndex = selectedSearchSetting;
    [self filterSegmentedControlValueChangeEventHandler:nil];
}

- (IBAction)setSearchByEveryone:(id)sender {
    NSLog(@"Doing things every sel: %d every:%d", selectedSearchSetting, kFeedSearchSetting_Everyone);
    [segmentedControl setImage:[UIImage imageNamed:@"FeedSegmentedControlTwo.png"]];
    selectedSearchSetting = kFeedSearchSetting_Everyone;
    selectedIndex = selectedSearchSetting;
    [self filterSegmentedControlValueChangeEventHandler:nil];
}

#pragma mark -

-(void)loggedIn
{
    [[FacebookFacade sharedInstance] getUserFriends];
}

-(void)getFeeds:(NSDictionary *)result
{
    [[FacebookFacade sharedInstance]setFeedsViewController:nil];
    [networkManager loadFeeds:nil withFriendsList:result];
}


/*-(NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

-(NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}
*/
@end

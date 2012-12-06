//
//  SearchByBusinessViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "SearchByBusinessViewController.h"

@implementation SearchByBusinessViewController
@synthesize businessListTableView;
@synthesize searchBar;
@synthesize businessList;
@synthesize filteredListOfItems;

#define kCellHeight		44.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.title = [NSString stringWithFormat:@"%@",@"Search"];
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    flag=0;
    [self loadBusinessList];
    flag=1;
    
    self.businessListTableView.backgroundColor = [UIColor clearColor];
	self.businessListTableView.sectionFooterHeight = 0;
    self.businessListTableView.tableHeaderView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    filteredListOfItems = [[NSMutableArray alloc] init];
    searching = NO;
	letUserSelectRow = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if([self.businessList count]==0 && flag==0)
    {
        Reachability *hostReach = [Reachability reachabilityForInternetConnection];
        if ([hostReach currentReachabilityStatus] != NotReachable) 
        {		
            [self loadBusinessList];
        }
    }
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setBusinessListTableView:nil];
    [self setSearchBar:nil];
    [self setBusinessListTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"In dealloc of SearchByBusinessViewController");
}

#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(searching)
    {
        return [self.filteredListOfItems count];
    }
    return [self.businessList count];
    //return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}	
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    Business *business;
    if(searching)
    {
        business=[self.filteredListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        business=[self.businessList objectAtIndex:indexPath.row];
    }
    cell.textLabel.text=business.business_name;
   	return cell;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark -
#pragma mark UITableViewDelegate methods Implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Business *business;
    if(searching)
    {
        business=[filteredListOfItems objectAtIndex:indexPath.row];
    }
    else
    {
        business=[businessList objectAtIndex:indexPath.row];
    }
    qrCode=business.qrcode;
    [self getBusinessOffer];
}

#pragma mark -
#pragma mark UISearchBarDelegate methods Implementation

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	//ovController.rvController = self;
	
	[self.businessListTableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	self.businessListTableView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
											   target:self action:@selector(doneSearching_Clicked:)];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[filteredListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.businessListTableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		[self.businessListTableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		searching = NO;
		letUserSelectRow = NO;
		self.businessListTableView.scrollEnabled = NO;
	}
	
	[self.businessListTableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
    [self doneSearching_Clicked:nil];
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishLoadingBusinessOffer:(NSString *)statusCode statusMessage:(NSString *)message punchCardDetails:(PunchCard*)punchCard;
{
    if([statusCode isEqualToString:@"00"])
    {
        [self goToPunchCardOfferView:qrCode punchCardDetails:punchCard];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) didFinishSearchByName:(NSString*)statusCode businessList:(NSArray *)blist
{ 
    flag=0;
    if([statusCode rangeOfString:@"00"].location == NSNotFound)
    {
        
    }
    else
    {
        NSArray *dateSortDescriptors=[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"business_name" ascending:YES]];
        self.businessList=[blist sortedArrayUsingDescriptors:dateSortDescriptors];
        [businessListTableView reloadData];
        
    }
}

-(void) didConnectionFailed :(NSString *)responseStatus
{
    flag=0;
}

#pragma mark -

-(void) getBusinessOffer
{
    [networkManager getBusinessOffer:qrCode loggedInUserId:[[InfoExpert sharedInstance]userId]];
}

-(void) loadBusinessList
{
    [networkManager searchByName:@"" loggedInUserId:[[InfoExpert sharedInstance]userId]];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
    int i=0;
    for(i=0;i<[businessList count];i++)
	{
        if([[businessList objectAtIndex:i] isKindOfClass:[Business class]])
        {
            Business *b=[businessList objectAtIndex:i];
            NSString *sTemp=b.business_name;
            NSComparisonResult result=[sTemp compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if(result == NSOrderedSame)
            {
                [self.filteredListOfItems addObject:b];
            }
        }
	}
}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.businessListTableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	ovController = nil;
	
	[self.businessListTableView reloadData];
}

#pragma mark -

-(void) gotoRootView
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)goToPunchCardOfferView:(NSString *)offerQrCode punchCardDetails:(PunchCard *)punchCard
{
    PunchCardOfferViewController *punchCardOfferView = [[PunchCardOfferViewController alloc] init:offerQrCode punchCardDetails:punchCard];
    [self.navigationController pushViewController:punchCardOfferView animated:YES];
}


@end

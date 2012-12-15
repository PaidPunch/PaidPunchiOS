//
//  MyPunchesViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "MyPunchesViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation MyPunchesViewController

@synthesize context = _context;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize punchesListTableView;
@synthesize lastRefreshTime;
@synthesize noCardsAvailableImage;

#define kCellHeight		60.0

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    NSArray *arr=[[DatabaseManager sharedInstance] fetchPunchCards];
    if(arr.count==0)
    {
        //[[InfoExpert sharedInstance] setBuyFlag:NO];
        [self getMyPunches];
    }
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    _context=[delegate managedObjectContext];
    
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.title = [NSString stringWithFormat:@"%@",@"My Punches"];
    self.punchesListTableView.backgroundColor = [UIColor clearColor];
	self.punchesListTableView.sectionFooterHeight = 0;
    
    self.lastRefreshTime=[NSDate date];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userViewedMyPunchesPage" object:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    //if([[InfoExpert sharedInstance] buyFlag]==YES)
    {
        [[DatabaseManager sharedInstance] deleteMyPunches];
        //[[InfoExpert sharedInstance] setBuyFlag:NO];
        self.lastRefreshTime=[NSDate date];
        [self getMyPunches];
    }
    
    NSTimeInterval interval=[[NSDate date] timeIntervalSinceDate:self.lastRefreshTime];
    int hours=(int)interval/3600;
    int minutes=(interval -(hours * 3600))/60;
    if(minutes>=5)
    {
        self.lastRefreshTime=[NSDate date];
        [[DatabaseManager sharedInstance] deleteMyPunches];
        [self getMyPunches];
    }
    NSLog(@"HH = %d MM = %d" ,hours,minutes);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
	self.fetchedResultsController = nil;
}

#pragma mark -
#pragma mark Cleanup


#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    if([sectionInfo numberOfObjects]>0)
        self.noCardsAvailableImage.hidden=YES;
    else
        self.noCardsAvailableImage.hidden=NO;
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myPunchViewCellIdentifier = @"MyPunchViewCellIdentifier";
    
    MyPunchViewCell *cell = (MyPunchViewCell *)[tableView dequeueReusableCellWithIdentifier:myPunchViewCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyPunchViewCell" owner:self options:nil];
        cell  = (MyPunchViewCell *)[nib objectAtIndex:0];
    }
	cell.selectionStyle=UITableViewCellSelectionStyleNone;    
    cell.punchCardDetails=[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.punchId=cell.punchCardDetails.punch_card_download_id;
    [cell setData];
   	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods Implementation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self goToPunchView:[_fetchedResultsController objectAtIndexPath:indexPath]];
}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishGetUsersPunch:(NSString*)statusCode
{
    [[DatabaseManager sharedInstance] saveEntity:nil];
    
    /*//clear the cache for images
    SDImageCache *imageCache=[SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];*/
    
}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate methods Implementation

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.punchesListTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.punchesListTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.punchesListTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.punchesListTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.punchesListTableView endUpdates];
}

#pragma mark -

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PunchCard" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    //a hack to fetch only users punch cards
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"flag=1 and total_punches-total_punches_used>0"];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"business_name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_context sectionNameKeyPath:nil cacheName:@"Root"];
    [theFetchedResultsController.fetchRequest setPredicate:predicate];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    
    return _fetchedResultsController;    
    
}

-(void)getMyPunches
{
    [networkManager getUserPunches:[[User getInstance] userId]];
}

#pragma mark -

-(void) goToPunchView:(PunchCard *)punchCard
{
    PunchViewController *punchView = [[PunchViewController alloc] initWithNibName:nil bundle:nil];
    punchView.punchCardDetails=punchCard;
    punchView.punchId=punchCard.punch_card_download_id;
    [self.navigationController pushViewController:punchView animated:YES];
    [punchView setUpUI];
}

#pragma mark -

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    MyPunchViewCell *cell1=(MyPunchViewCell *)cell;
    cell1.punchCardDetails=[_fetchedResultsController objectAtIndexPath:indexPath];
    cell1.punchId=cell1.punchCardDetails.punch_card_download_id;
    [cell1 setData];
    
}

@end

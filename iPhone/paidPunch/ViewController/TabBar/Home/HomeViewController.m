//
//  HomeViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 25/11/11.
//  Copyright (c) 2011 mobimedia. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController
@synthesize homeOptionsTableView;
@synthesize watchVideoImageView;
@synthesize playVideoOptionsView;
@synthesize homeView;

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
    self.title = [NSString stringWithFormat:@"%@",@"Home"];
    
    self.navigationController.navigationBarHidden=YES;
    
    networkManager=[[NetworkManager alloc] initWithView:self.view];
    networkManager.delegate=self;
    
    [self.view insertSubview:self.playVideoOptionsView belowSubview:self.homeView];
}

- (void)viewDidUnload
{
    [self setHomeOptionsTableView:nil];
    [self setWatchVideoImageView:nil];
    [self setPlayVideoOptionsView:nil];
    [self setHomeView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
     NSLog(@"In dealloc of HomeViewController");
}


#pragma mark -
#pragma mark UITableViewDataSource methods Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if(section==0)
    {
        return 2;
    }
    if(section==1)
    {
        return 2;
    }
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier=@"Cell";
	
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell==nil)
	{
		cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	cell.selectionStyle=UITableViewCellSelectionStyleNone;   
    cell.textLabel.textAlignment=UITextAlignmentCenter;
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0];
    if(indexPath.section==0)
    {
        if (indexPath.row==0) 
        {
            cell.textLabel.text=@"How to use PaidPunch";
            cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeLinkUpbox.png"]];
        }
        if(indexPath.row==1)
        {
            cell.textLabel.text=@"FAQ";
            cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeLinkDownbox.png"]];
        }
    }
    if(indexPath.section==1)
    {
        if (indexPath.row==0) 
        {
            cell.textLabel.text=@"My Account";
            cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeLinkUpbox.png"]];
        }
        if(indexPath.row==1)
        {
            cell.textLabel.text=@"Sign Out";
            cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeLinkDownbox.png"]];
        }
    }
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
    if(indexPath.section==0)
    {
        if (indexPath.row==0) 
        {
            [self goToUsingPaidPunchView];
        }
        if(indexPath.row==1)
        {
            [self goToFAQView];
        }
    }
    if(indexPath.section==1)
    {
        if (indexPath.row==0) 
        {
            [self goToMyAccountView];   
        }
        if(indexPath.row==1)
        {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [[delegate facebook] logout];
            [self signout];
        }
        
    }

}

#pragma mark -
#pragma mark NetworkManagerDelegate methods Implementation

-(void) didFinishLoggingOut:(NSString *)statusCode statusMessage:(NSString *)message
{
    if([statusCode isEqualToString:@"00"])
    {
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        [ud setObject:@"NO" forKey:@"loggedIn"];
        [ud synchronize];
        
        [[DatabaseManager sharedInstance] deleteAllPunchCards];
        [[DatabaseManager sharedInstance] deleteBusinesses];
        [[DatabaseManager sharedInstance] deleteAllFeeds];
        [[DatabaseManager sharedInstance] saveEntity:nil];
        
        [[FacebookFacade sharedInstance] setFeedsViewController:nil];
        [[FacebookFacade sharedInstance] setPunchUsedViewController:nil];
        [[FacebookFacade sharedInstance] setPunchCardOfferViewController:nil];
        [[FacebookFacade sharedInstance] setDualSignInViewController:nil];
        
        /*//clear the cache for images
         SDImageCache *imageCache=[SDImageCache sharedImageCache];
         [imageCache clearMemory];
         [imageCache clearDisk];
         [imageCache cleanDisk];*/
        
        [self goToDualSignInView];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) didFinishLoadingAppURL:(NSString *)url
{
    [[InfoExpert sharedInstance] setAppUrl:url];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:url forKey:@"appUrl"];
    [ud synchronize];
    
}

-(void) didConnectionFailed :(NSString *)responseStatus
{
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	if ([hostReach currentReachabilityStatus] != NotReachable) 
	{		
        [self requestAppIp];
    }
}
#pragma mark -
#pragma mark MPMoviePlayerPlaybackDidFinishNotification handler

- (void) movieFinishedCallback:(NSNotification*) aNotification {
    NSNumber *reason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]; 
	switch ([reason integerValue]) 
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:
			break;
		default:
			break;
	}
    
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    [player stop];
    [self dismissMoviePlayerViewControllerAnimated];
}

#pragma mark -

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch event");
    UITouch *touch=[touches anyObject];
    if(touch.view==watchVideoImageView)
    {
        [self playVideo];
    }
}

#pragma mark -

-(void) signout
{
    [networkManager logout:[[InfoExpert sharedInstance]userId]];
}

-(void) requestAppIp
{
    [networkManager appIpRequest];
}

- (void)playVideo {
    NSString *url = [[NSBundle mainBundle] 
                     pathForResource:@"paidpunch_iphone" 
                     ofType:@"mp4"];
    
    CustomMoviePlayer *playerViewController = 
    [[CustomMoviePlayer alloc] 
     initWithContentURL:[NSURL fileURLWithPath:url]];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self
     selector:@selector(movieFinishedCallback:)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:[playerViewController moviePlayer]];
    
    //---play movie---
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    
    [player setControlStyle:MPMovieControlStyleFullscreen];
    player.shouldAutoplay=YES;
    [player setFullscreen:YES];
    player.movieSourceType=MPMovieSourceTypeFile;
    
    [[player view]setFrame:[self.view bounds]];
    [UIView transitionWithView:self.view.window duration:1.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{[self presentMoviePlayerViewControllerAnimated:playerViewController];} completion:nil];
    //[self presentMoviePlayerViewControllerAnimated:playerViewController];
    [player play];
    
}

#pragma mark -

-(void) goToDualSignInView
{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initView];
}


-(void)goToMyAccountView
{
    SettingsViewController *settingsViewController= [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

-(void)goToFAQView
{
    FAQViewController *faqViewController= [[FAQViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:faqViewController animated:YES];

}

-(void)goToUsingPaidPunchView
{
    UsingPaidPunchViewController *usingPaidPunchViewController= [[UsingPaidPunchViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:usingPaidPunchViewController animated:YES];

}

@end

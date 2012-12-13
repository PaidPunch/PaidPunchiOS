//
//  StartPageViewcontroller.m
//  paidPunch
//
//  Created by Alexander Nabavi-Noori on 7/26/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "StartPageViewController.h"
#import "User.h"

@implementation StartPageViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize viewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        loginView = NULL;
        signupView = NULL;
        containerView = NULL;
        totalContentCount = 0;
        userHasInteracted = NO;
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

- (CGRect) getPlacardFrame:(int)placardIndex
{
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * placardIndex;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    return frame;
}

- (int) initializeInfoPlacards:(int)currentIndex
{
    NSArray *placardFiles = [NSArray arrayWithObjects:@"InformationPlacardThree.png", @"InformationPlacardTwo.png", @"InformationPlacardOne.png", nil];
    int count;
    for (count = currentIndex; count < placardFiles.count; count++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self getPlacardFrame:count]];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [placardFiles objectAtIndex:count]]]];
        [self.scrollView addSubview:imageView];
    }
    return count;
}

- (int) initializeUserPlacards:(int)currentIndex
{
    containerView = [[UIView alloc] initWithFrame:[self getPlacardFrame:currentIndex]];
    loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    loginView.navigationController = [self navigationController];
    signupView = [[SignupView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    signupView.navigationController = [self navigationController];
    
    [containerView addSubview:loginView];
    [self.scrollView addSubview:containerView];
    
    onLoginView = TRUE;
    
    return (currentIndex+1);
}

- (void) initializeAllPlacards
{    
    // Initialize informational placards
    totalContentCount = [self initializeInfoPlacards:totalContentCount];

    // Add login page
    totalContentCount = [self initializeUserPlacards:totalContentCount];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * totalContentCount, self.scrollView.frame.size.height);
	
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = totalContentCount;
    
    pagingTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoChangePage) userInfo:nil repeats:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	pageControlBeingUsed = NO;
	
    [self initializeAllPlacards];
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.scrollView = nil;
	self.pageControl = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    
    // Reset the scrolling when the user id is set (i.e. user has registered)
    NSString* userId = [[User getInstance] userId];
    if ([userId length] > 0)
    {
        pageControl.currentPage = 0;
        [self switchPage:self.pageControl.currentPage];
        userHasInteracted = NO;
        
        if (!onLoginView)
        {
            [signupView removeFromSuperview];
            [containerView addSubview:loginView];
            onLoginView = TRUE;
        }
    }
}

- (void)awakeFromNib
{    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadScrollViewWithPage:(int)page
{
    
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
    
    // Turn off auto-scroll since user has started interacting with the pages
    userHasInteracted = YES;
    
    // If the scroll begins moving, go ahead and dismiss any keyboards that might be up
    [loginView dismissKeyboard];
    [signupView dismissKeyboard];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
}

#pragma mark -
#pragma mark MPMoviePlayerPlaybackDidFinishNotification handler

- (void) movieFinishedCallback:(NSNotification*) aNotification
{
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

- (void) switchPage:(NSInteger)page
{
    // Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * page;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

#pragma mark - Interface Actions

- (IBAction)changePage:(id)sender
{
    [self switchPage:self.pageControl.currentPage];
}

- (IBAction)pressPlay:(id)sender
{
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
    [UIView transitionWithView:self.view.window duration:1.0f options:0 animations:^{[self presentMoviePlayerViewControllerAnimated:playerViewController];} completion:nil];
    //[self presentMoviePlayerViewControllerAnimated:playerViewController];
    [player play];
}

- (IBAction)showFAQ:(id)sender
{
    FAQViewController *faqViewController= [[FAQViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:faqViewController animated:YES];
}

- (IBAction)signIn:(id)sender
{
    pageControl.currentPage = 3;
    [self switchPage:self.pageControl.currentPage];
    
    if (!onLoginView)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
        [signupView removeFromSuperview];
        [containerView addSubview:loginView];
        [UIView commitAnimations];
    }
    
    onLoginView = TRUE;
    userHasInteracted = YES;
}

- (IBAction)signUp:(id)sender
{
    // Change to signin/up page. Assumed to be the last page.
    pageControl.currentPage = totalContentCount - 1;
    [self switchPage:self.pageControl.currentPage];
    
    if (onLoginView)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
        [loginView removeFromSuperview];
        [containerView addSubview:signupView];
        [UIView commitAnimations];
    }
    
    onLoginView = FALSE;
    userHasInteracted = YES;
}

- (void)autoChangePage
{
    if(userHasInteracted == NO)
    {
        if(pageControl.currentPage < (totalContentCount - 1))
        {
            pageControl.currentPage += 1;
        }
        else
        {
            pageControl.currentPage = 0;
        }
        
        [self switchPage:self.pageControl.currentPage];
    }
}

@end

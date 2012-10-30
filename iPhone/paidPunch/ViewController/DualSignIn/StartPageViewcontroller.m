//
//  StartPageViewcontroller.m
//  paidPunch
//
//  Created by Alexander Nabavi-Noori on 7/26/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "StartPageViewController.h"

@implementation StartPageViewController

@synthesize scrollView, pageControl, viewControllers;

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
	
	pageControlBeingUsed = NO;
	
    NSArray *placardFiles = [NSArray arrayWithObjects:[NSString stringWithString:@"InformationPlacardThree.png"], [NSString stringWithString:@"InformationPlacardTwo.png"], [NSString stringWithString:@"InformationPlacardOne.png"], nil];
    for (int i = 0; i < placardFiles.count; i++) {
		CGRect frame;
		frame.origin.x = self.scrollView.frame.size.width * i;
		frame.origin.y = 0;
		frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [placardFiles objectAtIndex:i]]]];
        [self.scrollView addSubview:imageView];
        [imageView release];
    }
    	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * placardFiles.count, self.scrollView.frame.size.height);
	
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = placardFiles.count;
    
    pagingTimer = [[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(autoChangePage) userInfo:nil repeats:YES] retain];
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
}

- (void)awakeFromNib {
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadScrollViewWithPage:(int)page {
    
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
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

#pragma mark - Interface Actions

- (IBAction)changePage:(id)sender {
    // Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

- (IBAction)pressPlay:(id)sender {
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
    [playerViewController release];
}

- (IBAction)showFAQ:(id)sender {
    FAQViewController *faqViewController= [[FAQViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:faqViewController animated:YES];
    [faqViewController release];
}

- (IBAction)signIn:(id)sender {
    DualSignInViewController *dualSignInViewController = [[DualSignInViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:dualSignInViewController animated:YES];
    [dualSignInViewController release];
}

- (void)autoChangePage {
    if(userHasIntereacted == NO){
        if(pageControl.currentPage == 0 || pageControl.currentPage == 1){
            pageControl.currentPage += 1;
            
            //Scroll to page
            CGRect frame;
            frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
            frame.origin.y = 0;
            frame.size = self.scrollView.frame.size;
            [self.scrollView scrollRectToVisible:frame animated:YES];
        }
        else if(pageControl.currentPage == 2){
            pageControl.currentPage = 0;
            
            //Scoll all the way back
            CGRect frame;
            frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
            frame.origin.y = 0;
            frame.size = self.scrollView.frame.size;
            [self.scrollView scrollRectToVisible:frame animated:YES];
        }
    }
}

@end

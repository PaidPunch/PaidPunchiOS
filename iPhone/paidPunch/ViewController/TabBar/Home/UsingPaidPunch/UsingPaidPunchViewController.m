//
//  UsingPaidPunchViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 14/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "UsingPaidPunchViewController.h"

@implementation UsingPaidPunchViewController
@synthesize usingPaidPunchWebView;

#define degreesToRadian(x)(M_PI *(x)/180.0)

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
    self.title = [NSString stringWithFormat:@"%@",@"Using PaidPunch"];
    
    self.usingPaidPunchWebView.delegate=self;

    NSString *url=[NSString stringWithFormat:@"%@%@",[[InfoExpert sharedInstance] appUrl], NSLocalizedString(@"HowToUseTxtUrl", @"")];
    NSURL *targetURL=[NSURL URLWithString:url];
    NSURLRequest *request=[NSURLRequest requestWithURL:targetURL];
    [self.usingPaidPunchWebView loadRequest:request];
    
    popupHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:popupHUD];
}

- (void)viewDidUnload
{
    [self setUsingPaidPunchWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    [usingPaidPunchWebView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIWebViewDelegate methods Implementation

- (void)webViewDidStartLoad:(UIWebView *)wView
{
	//((UITextView *)[self.activity viewWithTag:1]).text=msg;
}

- (void)webViewDidFinishLoad:(UIWebView *)wView
{
}

- (void)webView:(UIWebView *)wView didFailLoadWithError:(NSError *)error
{
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=2 color='black'>Whoops! An error occurred:<br>%@</font></center></html>",
							 error.localizedDescription];
	[wView loadHTMLString:errorString baseURL:nil];
	
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Whoops!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
    
}

#pragma mark -

-(void) showPopup
{
    /*NSArray *xibUIObjects =[[NSBundle mainBundle] loadNibNamed:@"NetworkActivity" owner:self options:nil];
    activityView= [xibUIObjects objectAtIndex:0];
    activityView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:activityView];
    
    [((UIActivityIndicatorView *)[activityView viewWithTag:2]) setHidden:YES];
    ((UITextView *)[activityView viewWithTag:1]).hidden=YES;*/
    [popupHUD show:YES];
}

-(void) removePopup
{
    // finished loading, hide the activity indicator in the status bar
    /*if([activityView respondsToSelector:@selector(viewWithTag:)])
	{
        [activityView removeFromSuperview];
    }*/
    [popupHUD hide:YES];
}

@end

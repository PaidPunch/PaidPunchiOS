//
//  FAQViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 14/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "FAQViewController.h"

@implementation FAQViewController
@synthesize faqWebView;

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
    self.title = [NSString stringWithFormat:@"%@",@"FAQ"];
    
    self.faqWebView.delegate=self;
    [faqWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"FAQ" ofType:@"html"] isDirectory:NO]]];
    
    popupHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:popupHUD];
}

- (void)viewDidUnload
{
    [self setFaqWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden=NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
    [faqWebView release];
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
							 @"<html><center><font size=2 color='black'>An error occurred:<br>%@</font></center></html>",
							 error.localizedDescription];
	[wView loadHTMLString:errorString baseURL:nil];
	
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
    
}

- (IBAction)goBack:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
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

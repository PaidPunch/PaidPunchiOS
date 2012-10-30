//
//  TermsAndConditionsViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 14/03/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "TermsAndConditionsViewController.h"

@implementation TermsAndConditionsViewController
@synthesize termsAndConditionsWebView;

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
    self.title=@"Terms and Conditions";
    self.view.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    NSString *bundle = [[NSBundle mainBundle] bundlePath];
	NSString *webPath = [bundle stringByAppendingPathComponent:@"Terms.html"];	
	[self.termsAndConditionsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:webPath]]];	
}

- (void)viewDidUnload
{
    [self setTermsAndConditionsWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [termsAndConditionsWebView release];
    [super dealloc];
}
@end

//
//  OverlayViewController.m
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import "OverlayViewController.h"
#import "SearchByBusinessViewController.h"

@implementation OverlayViewController

@synthesize rvController;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[rvController doneSearching_Clicked:nil];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	[rvController release];
    [super dealloc];
    NSLog(@"In dealloc of OverlayViewController");
}


@end

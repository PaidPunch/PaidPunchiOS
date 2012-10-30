//
//  BusinessLocatorViewController.m
//  paidPunch
//
//  Created by mobimedia technologies on 26/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import "BusinessLocatorViewController.h"

@implementation BusinessLocatorViewController
@synthesize businessLocatorMapView;
@synthesize businessNameLabel;
@synthesize punchCardDetails;
@synthesize selectedAnnotationView;
@synthesize calloutAnnotation;
@synthesize customAnnotation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init:(PunchCard *)punchCard
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.punchCardDetails=punchCard;
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
    businessLocatorMapView.mapType =MKMapTypeStandard;
    businessLocatorMapView.showsUserLocation=YES;
    businessLocatorMapView.zoomEnabled = YES;
	businessLocatorMapView.scrollEnabled = YES;
    businessNameLabel.text = self.punchCardDetails.business_name;
    [self addAnnotations];

    customAnnotation = [[BusinessLocationAnnotation alloc] initWithLatitude:[self.punchCardDetails.business.latitude doubleValue] andLongitude:[self.punchCardDetails.business.longitude doubleValue]];
    [self.businessLocatorMapView addAnnotation:self.customAnnotation];
    
    
    UIBarButtonItem *mapButton=[[UIBarButtonItem alloc] initWithTitle:@"Directions" style:UIBarButtonItemStylePlain target:self action:@selector(directionsBtnTouchUpInsideHandler:)];
    mapButton.title=@"Directions";
    self.navigationItem.rightBarButtonItem=mapButton;
    [mapButton release];

}

- (void)viewDidUnload
{
    [self setBusinessLocatorMapView:nil];
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
    [businessLocatorMapView release];
    [punchCardDetails release];
    [selectedAnnotationView release];
    [customAnnotation release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark MKMapViewDelegate methods Implementation

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{	
    
    if (annotation == self.calloutAnnotation)
    {
        CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.businessLocatorMapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
		if (!calloutMapAnnotationView) {
			calloutMapAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation 
																			 reuseIdentifier:@"CalloutAnnotation"] autorelease];
			calloutMapAnnotationView.contentHeight = self.punchCardDetails.business.address.length * 1.4;//100.0f;
            
            UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
            titleLbl.text = self.punchCardDetails.business_name;
            titleLbl.textAlignment=UITextAlignmentCenter;
            titleLbl.lineBreakMode=UILineBreakModeTailTruncation;
            titleLbl.backgroundColor=[UIColor clearColor];
            titleLbl.textColor=[UIColor whiteColor];
            titleLbl.font=[UIFont boldSystemFontOfSize:16];
            
            UILabel *addressLbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 35, 300, calloutMapAnnotationView.contentHeight-30)];
            addressLbl.text = self.punchCardDetails.business.address;
            addressLbl.textAlignment=UITextAlignmentCenter;
            addressLbl.lineBreakMode=UILineBreakModeTailTruncation;
            addressLbl.numberOfLines=0;
            addressLbl.backgroundColor=[UIColor clearColor];
            addressLbl.textColor=[UIColor whiteColor];
            addressLbl.font=[UIFont fontWithName:@"Helvetica" size:13];
            
            [calloutMapAnnotationView addSubview:titleLbl];
            [calloutMapAnnotationView addSubview:addressLbl];
            
            calloutMapAnnotationView.annotation=annotation;
            [addressLbl release];
            [titleLbl release];
		}
		calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
		calloutMapAnnotationView.mapView = self.businessLocatorMapView;
		return calloutMapAnnotationView;
    }
    else
    {
        NSString* identifier = @"locationAnnotation";
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(annotationView == nil){
            annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        }
        if([annotation isKindOfClass:[BusinessLocationAnnotation class]])
        {
            annotationView.pinColor=MKPinAnnotationColorRed;
            annotationView.canShowCallout=NO;
        }
        else
        {
            annotationView.pinColor=MKPinAnnotationColorGreen;
            annotationView.canShowCallout=YES;
        }
        annotationView.calloutOffset=CGPointMake(5.0, -5.0);
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if (view.annotation == self.customAnnotation) {
		if (self.calloutAnnotation == nil) {
			calloutAnnotation = [[BusinessLocationAnnotation alloc] initWithLatitude:[self.punchCardDetails.business.latitude doubleValue] andLongitude:[self.punchCardDetails.business.longitude doubleValue]];
		} else {

		}
		[self.businessLocatorMapView addAnnotation:self.calloutAnnotation];
		self.selectedAnnotationView = view;
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (self.calloutAnnotation && view.annotation == self.customAnnotation) {
		[self.businessLocatorMapView removeAnnotation: self.calloutAnnotation];
	}
}

#pragma mark -

-(void)addAnnotations
{
    /*BusinessLocationAnnotation *locationAnnotation = [[BusinessLocationAnnotation alloc] initWithBusiness:self.punchCardDetails.business];
    [self.businessLocatorMapView addAnnotation:locationAnnotation];
    [locationAnnotation release];*/
    
    MKCoordinateRegion newRegion;
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    
    CLLocationCoordinate2D location={[self.punchCardDetails.business.latitude doubleValue],[self.punchCardDetails.business.longitude doubleValue]};
    newRegion.center=location;
    newRegion.span=span;
    [businessLocatorMapView setRegion:newRegion animated:YES];
    [businessLocatorMapView regionThatFits:newRegion];
    
}

#pragma mark -

- (IBAction)directionsBtnTouchUpInsideHandler:(id)sender {
    //NSString *urlToLaunch = @"http://maps.google.com/maps?saddr=20807+Stevens+Creek+Blvd,+Cupertino,+CA&daddr=22350+Homestead+Rd,+Cupertino,+CA";
    MKUserLocation *userLocation=self.businessLocatorMapView.userLocation;
    //NSString *address=[self.punchCardDetails.business.address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlToLaunch =[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude,[self.punchCardDetails.business.latitude doubleValue],[self.punchCardDetails.business.longitude doubleValue]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToLaunch]];

}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end

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
@synthesize businessNameMarqueeLabel;
@synthesize paidPunchLogo;
@synthesize getDirectionsButton;
//@synthesize punchCardDetails;
@synthesize punchCardDetailsArray;
@synthesize selectedAnnotationView;
@synthesize calloutAnnotation;
//@synthesize customAnnotation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*- (id)init:(PunchCard *)punchCard
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.punchCardDetails=punchCard;
    }
    return self;

}*/

- (id)init:(NSArray *)punchCardArray {
    self = [super init];
    if(self) {
        if([punchCardArray count] == 0){
            NSLog(@"BusinessLocator: Error, array consists of zero objects. Expect Crash");
        }
        else {
            punchCardDetailsArray = punchCardArray;
        }
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
    //[businessLocatorMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    businessLocatorMapView.zoomEnabled = YES;
	businessLocatorMapView.scrollEnabled = YES;
    
    businessNameMarqueeLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(70.0, 0.0, 170.0, 45.0) rate:20.0f andFadeLength:10.0f];
    [businessNameMarqueeLabel setFont:[UIFont systemFontOfSize:21.0]];
    [businessNameMarqueeLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:136.0/255.0 blue:55.0/255.0 alpha:1.0]];

    if([punchCardDetailsArray count] == 1){
        businessNameMarqueeLabel.text = [[punchCardDetailsArray objectAtIndex:0] business_name];
        [businessNameMarqueeLabel setHidden:NO];
        [paidPunchLogo setHidden:YES];
    }
    else {
        [businessNameMarqueeLabel setHidden:YES];
        [paidPunchLogo setHidden:NO];
    }
    [self.view addSubview:businessNameMarqueeLabel];
        
    [self addAnnotations];
    
    annotationArray = [[NSMutableArray alloc] init];
//    for(PunchCard *card in punchCardDetailsArray){
    for(int i = 0; i < [punchCardDetailsArray count]; i++){
        PunchCard *card = [punchCardDetailsArray objectAtIndex:i];
        
        CLLocationCoordinate2D tempCoord;
        tempCoord.latitude = [card.business.latitude doubleValue];
        tempCoord.longitude = [card.business.longitude doubleValue];
        
        BusinessLocationAnnotation *tempAnn = [[BusinessLocationAnnotation alloc] initWithCoord:tempCoord];
        tempAnn.title = card.business_name;
        tempAnn.subtitle = card.business.address;
        tempAnn.punchCard = card;
        
        [annotationArray addObject:tempAnn];
    }
//    customAnnotation = [[BusinessLocationAnnotation alloc] initWithLatitude:[self.punchCardDetails.business.latitude doubleValue] andLongitude:[self.punchCardDetails.business.longitude doubleValue]];
    [self.businessLocatorMapView addAnnotations:annotationArray];
//    [self.businessLocatorMapView addAnnotation:self.customAnnotation];
    
    
    UIBarButtonItem *mapButton=[[UIBarButtonItem alloc] initWithTitle:@"Directions" style:UIBarButtonItemStylePlain target:self action:@selector(directionsBtnTouchUpInsideHandler:)];
    mapButton.title=@"Directions";
    self.navigationItem.rightBarButtonItem=mapButton;
    
    if ([punchCardDetailsArray count] == 1) {
        getDirectionsButton.hidden = NO;
    }
    else {
        getDirectionsButton.hidden = YES;
    }

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



#pragma mark -
#pragma mark MKMapViewDelegate methods Implementation

/*- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    NSLog(@"VIEW FOR ANNOTATION");
    if (annotation == self.calloutAnnotation)
    {
        NSLog(@"CALLOUT ANNOTATION");
        
        CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.businessLocatorMapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
		if (!calloutMapAnnotationView) {
			calloutMapAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation 
																			 reuseIdentifier:@"CalloutAnnotation"] autorelease];
//            PunchCard *tempPunchCard = [self requestPunchCardFromArray:[annotation title]];
            PunchCard *tempPunchCard = [punchCardDetailsArray objectAtIndex:[(BusinessLocationAnnotation *)annotation tag]];
			calloutMapAnnotationView.contentHeight = tempPunchCard.business.address.length * 1.4;//100.0f;
            
            UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
            titleLbl.text = tempPunchCard.business_name;
            titleLbl.textAlignment=UITextAlignmentCenter;
            titleLbl.lineBreakMode=UILineBreakModeTailTruncation;
            titleLbl.backgroundColor=[UIColor clearColor];
            titleLbl.textColor=[UIColor whiteColor];
            titleLbl.font=[UIFont boldSystemFontOfSize:16];
            
            UILabel *addressLbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 35, 300, calloutMapAnnotationView.contentHeight-30)];
            addressLbl.text = tempPunchCard.business.address;
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
        NSLog(@"ELSE CALLOUT ANNOTATION");
        
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
}*/

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pinView;
    if(annotation == [businessLocatorMapView userLocation]){
        //Do nothing, this is a user location bleu circle thingy
        return nil;
    }
    else if([annotation isKindOfClass:[BusinessLocationAnnotation class]]){
        //Pin stuff
        static NSString *defaultPinID = @"PaidPunch Pin";
        pinView = (MKPinAnnotationView *)[businessLocatorMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if(pinView == nil){
            //the view for the annotation has not been created, set up here
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];

            [pinView setPinColor:MKPinAnnotationColorRed];
            [pinView setCanShowCallout:YES];
            [pinView setAnimatesDrop:YES];
                
            //The button
            if([punchCardDetailsArray count] > 1){
                UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                pinView.rightCalloutAccessoryView = detailButton;
            }
        }
        else {
            //View created, no need to alter it
        }
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{    
    PunchCard *card = [(BusinessLocationAnnotation *)[view annotation] punchCard];
    NSLog(@"Card Details: %@", card);
    PunchCardOfferViewController *punchCardOfferViewController = [[PunchCardOfferViewController alloc] init:card.business_name punchCardDetails:card];
    [self.navigationController pushViewController:punchCardOfferViewController animated:YES];
}

/*- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([view.annotation isKindOfClass:[BusinessLocationAnnotation class]]){
        if (self.calloutAnnotation == nil) {
            NSLog(@"didSelect, view: %@\nannotation: %@", view, view.annotation);
//            PunchCard *tempPunchCard = [self requestPunchCardFromArray:[view.annotation title]];
            PunchCard *tempPunchCard = [punchCardDetailsArray objectAtIndex:[(BusinessLocationAnnotation *)[view annotation] tag]];
            calloutAnnotation = [[BusinessLocationAnnotation alloc] initWithLatitude:[tempPunchCard.business.latitude doubleValue] andLongitude:[tempPunchCard.business.longitude doubleValue]];
        } else {
            
        }
        [self.businessLocatorMapView addAnnotation:self.calloutAnnotation];
        self.selectedAnnotationView = view;
    }
}*/

/*- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//    if (self.calloutAnnotation && view.annotation == self.customAnnotation) {
    if(self.calloutAnnotation){
        [self.businessLocatorMapView removeAnnotation: self.calloutAnnotation];
	}
}*/

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
    CLLocationCoordinate2D location={[[[[punchCardDetailsArray objectAtIndex:0] business] latitude] doubleValue],[[[[punchCardDetailsArray objectAtIndex:0] business] longitude] doubleValue]};
    newRegion.center=location;
    newRegion.span=span;
    [businessLocatorMapView setRegion:newRegion animated:YES];
    [businessLocatorMapView regionThatFits:newRegion];
    
}

- (PunchCard *)requestPunchCardFromArray:(NSString *)cardName {
    NSLog(@"cardName: %@", cardName);
    for(PunchCard *card in punchCardDetailsArray){
        if([card.business_name isEqualToString:cardName]){
            NSLog(@"Found Match: %@", card.business_name);
            return card;
        }
    }
    return nil;
}

#pragma mark -

- (IBAction)goBack:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)getDirections:(id)sender {
    MKUserLocation *userLocation=self.businessLocatorMapView.userLocation;
    NSString *urlToLaunch =[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude,[[[[punchCardDetailsArray objectAtIndex:0] business] latitude] doubleValue],[[[[punchCardDetailsArray objectAtIndex:0] business] longitude] doubleValue]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToLaunch]];
}


@end

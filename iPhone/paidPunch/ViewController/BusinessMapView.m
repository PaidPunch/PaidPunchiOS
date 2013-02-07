//
//  BusinessMapView.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "BusinessMapView.h"

@implementation BusinessMapView

- (id)initWithFrameAndPunches:(CGRect)frame punchcard:(PunchCard*)punchcard business:(Business*)business
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _punchcard = punchcard;
        _business = business;
        [self createMap:frame];
    }
    return self;
}

#pragma mark - private functions

- (void)createMap:(CGRect)frame
{
    _businessMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    _businessMap.mapType = MKMapTypeStandard;
    _businessMap.showsUserLocation = YES;
    _businessMap.zoomEnabled = YES;
	_businessMap.scrollEnabled = YES;
    _businessMap.delegate = self;
    
    [self addAnnotations];
    
    CLLocationCoordinate2D tempCoord;
    tempCoord.latitude = [_business.latitude doubleValue];
    tempCoord.longitude = [_business.longitude doubleValue];
    
    _annotation = [[BusinessLocationAnnotation alloc] initWithCoord:tempCoord];
    _annotation.title = _business.business_name;
    _annotation.subtitle = _business.address;
    _annotation.punchCard = _punchcard;
    
    NSMutableArray* annotationArray = [[NSMutableArray alloc] init];
    [annotationArray addObject:_annotation];
    [_businessMap addAnnotations:annotationArray];
    
    [self addSubview:_businessMap];
}

#pragma mark - MKMapView delegates

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView;
    if (annotation == [_businessMap userLocation])
    {
        //Do nothing, this is a user location blue circle thingy
        return nil;
    }
    else if ([annotation isKindOfClass:[BusinessLocationAnnotation class]])
    {
        //Pin stuff
        static NSString *defaultPinID = @"PaidPunch Pin";
        pinView = (MKPinAnnotationView *)[_businessMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)
        {
            //the view for the annotation has not been created, set up here
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
            
            [pinView setPinColor:MKPinAnnotationColorRed];
            [pinView setCanShowCallout:YES];
            [pinView setAnimatesDrop:YES];
            
            // Directions button
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = detailButton;
        }
        else
        {
            //View created, no need to alter it
        }
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MKUserLocation *userLocation = _businessMap.userLocation;
    NSString *urlToLaunch =[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude,[[_business latitude] doubleValue],[[_business longitude] doubleValue]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToLaunch]];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (id<MKAnnotation> currentAnnotation in mapView.annotations)
    {
        if ([currentAnnotation isEqual:_annotation])
        {
            [mapView selectAnnotation:currentAnnotation animated:TRUE];
            break;
        }
    }
}

#pragma mark -

-(void)addAnnotations
{
    MKCoordinateRegion newRegion;
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    CLLocationCoordinate2D location = {[[_business latitude] doubleValue],[[_business longitude] doubleValue]};
    newRegion.center=location;
    newRegion.span=span;
    [_businessMap setRegion:newRegion animated:YES];
    [_businessMap regionThatFits:newRegion];
    
}

@end

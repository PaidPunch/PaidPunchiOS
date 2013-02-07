//
//  BusinessMapView.m
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import "Business.h"
#import "BusinessLocationAnnotation.h"
#import "BusinessMapView.h"
#import "PunchCard.h"

@implementation BusinessMapView

- (id)initWithFrameAndPunches:(CGRect)frame punchcardArray:(NSArray *)punchcardArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _punchcardArray = punchcardArray;
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
    
    [self addAnnotations];
    
    _annotationArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [_punchcardArray count]; i++)
    {
        PunchCard *card = [_punchcardArray objectAtIndex:i];
        
        CLLocationCoordinate2D tempCoord;
        tempCoord.latitude = [card.business.latitude doubleValue];
        tempCoord.longitude = [card.business.longitude doubleValue];
        
        BusinessLocationAnnotation *tempAnn = [[BusinessLocationAnnotation alloc] initWithCoord:tempCoord];
        tempAnn.title = card.business_name;
        tempAnn.subtitle = card.business.address;
        tempAnn.punchCard = card;
        
        [_annotationArray addObject:tempAnn];
    }

    [_businessMap addAnnotations:_annotationArray];
    
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
            
            //The button
            if ([_punchcardArray count] > 1)
            {
                UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                pinView.rightCalloutAccessoryView = detailButton;
            }
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
    /*
    PunchCard *card = [(BusinessLocationAnnotation *)[view annotation] punchCard];
    NSLog(@"Card Details: %@", card);
    PunchCardOfferViewController *punchCardOfferViewController = [[PunchCardOfferViewController alloc] init:card.business_name punchCardDetails:card];
    [self.navigationController pushViewController:punchCardOfferViewController animated:YES];
     */
}

#pragma mark -

-(void)addAnnotations
{    
    MKCoordinateRegion newRegion;
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    CLLocationCoordinate2D location = {[[[[_punchcardArray objectAtIndex:0] business] latitude] doubleValue],[[[[_punchcardArray objectAtIndex:0] business] longitude] doubleValue]};
    newRegion.center=location;
    newRegion.span=span;
    [_businessMap setRegion:newRegion animated:YES];
    [_businessMap regionThatFits:newRegion];
    
}

- (PunchCard *)requestPunchCardFromArray:(NSString *)cardName
{
    NSLog(@"cardName: %@", cardName);
    for(PunchCard *card in _punchcardArray)
    {
        if([card.business_name isEqualToString:cardName])
        {
            NSLog(@"Found Match: %@", card.business_name);
            return card;
        }
    }
    return nil;
}

@end

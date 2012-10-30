//
//  BusinessLocatorViewController.h
//  paidPunch
//
//  Created by mobimedia technologies on 26/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusinessLocationAnnotation.h"
#import "PunchCard.h"
#import "CalloutMapAnnotationView.h"


@interface BusinessLocatorViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{

}
@property (retain, nonatomic) IBOutlet MKMapView *businessLocatorMapView;
@property (retain, nonatomic) IBOutlet UILabel  *businessNameLabel;
@property(nonatomic,retain) PunchCard *punchCardDetails;

@property (nonatomic, retain) BusinessLocationAnnotation *calloutAnnotation;
@property (nonatomic, retain) BusinessLocationAnnotation *customAnnotation;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;

- (id)init:(PunchCard *)punchCard;
- (void)addAnnotations;

- (IBAction)goBack:(id)sender;

@end

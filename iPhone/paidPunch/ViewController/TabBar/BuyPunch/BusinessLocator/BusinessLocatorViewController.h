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
#import "PunchCardOfferViewController.h"
#import "MarqueeLabel.h"

@interface BusinessLocatorViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    NSArray                 *punchCardDetailsArray;
    IBOutlet UIImageView    *paidPunchLogo;
    NSMutableArray          *annotationArray;
}
@property (strong, nonatomic) IBOutlet MKMapView *businessLocatorMapView;
//@property(nonatomic,retain) PunchCard *punchCardDetails;
@property (strong, nonatomic) NSArray *punchCardDetailsArray;
@property (strong, nonatomic) IBOutlet UIImageView *paidPunchLogo;
@property (nonatomic, strong) IBOutlet UIButton *getDirectionsButton;
@property (nonatomic, strong) MarqueeLabel *businessNameMarqueeLabel;

@property (nonatomic, strong) BusinessLocationAnnotation *calloutAnnotation;
//@property (nonatomic, retain) BusinessLocationAnnotation *customAnnotation;
@property (nonatomic, strong) MKAnnotationView *selectedAnnotationView;

//- (id)init:(PunchCard *)punchCard;
- (id)init:(NSArray *)punchCardArray;
- (void)addAnnotations;
- (PunchCard *)requestPunchCardFromArray:(NSString *)cardName;

- (IBAction)goBack:(id)sender;
- (IBAction)getDirections:(id)sender;

@end

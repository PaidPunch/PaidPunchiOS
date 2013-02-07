//
//  BusinessMapView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusinessLocationAnnotation.h"
#import "PunchCard.h"
#import "CalloutMapAnnotationView.h"

@interface BusinessMapView : UIView<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView* _businessMap;
    NSArray* _punchcardArray;
    NSMutableArray* _annotationArray;
}
@property (strong, nonatomic) NSArray *punchcardArray;

@property (nonatomic, strong) BusinessLocationAnnotation *calloutAnnotation;
@property (nonatomic, strong) MKAnnotationView *selectedAnnotationView;

- (id)initWithFrameAndPunches:(CGRect)frame punchcardArray:(NSArray *)punchcardArray;
- (void)addAnnotations;
- (PunchCard *)requestPunchCardFromArray:(NSString *)cardName;

@end

//
//  BusinessMapView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Business.h"
#import "BusinessLocationAnnotation.h"
#import "PunchCard.h"

@interface BusinessMapView : UIView<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView* _businessMap;
    PunchCard* _punchcard;
    Business* _business;
    BusinessLocationAnnotation* _annotation;
}

- (id)initWithFrameAndPunches:(CGRect)frame punchcard:(PunchCard*)punchcard business:(Business*)business;


@end

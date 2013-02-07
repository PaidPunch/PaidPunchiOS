//
//  BusinessMapView.h
//  paidPunch
//
//  Created by Aaron Khoo on 2/6/13.
//  Copyright (c) 2013 PaidPunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BusinessMapView : UIView<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView* _businessMap;
    NSArray* _punchcardArray;
    NSMutableArray* _annotationArray;
}
@property (strong, nonatomic) NSArray *punchcardArray;

- (id)initWithFrameAndPunches:(CGRect)frame punchcardArray:(NSArray *)punchcardArray;
- (void)addAnnotations;
- (PunchCard *)requestPunchCardFromArray:(NSString *)cardName;

@end

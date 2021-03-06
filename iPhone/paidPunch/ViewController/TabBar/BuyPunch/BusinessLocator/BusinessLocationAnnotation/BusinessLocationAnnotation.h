//
//  BusinessLocationAnnotation.h
//  paidPunch
//
//  Created by mobimedia technologies on 26/04/12.
//  Copyright (c) 2012 mobimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Business.h"

@interface BusinessLocationAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString            *title;
    NSString            *subtitle;
    PunchCard           *punchCard;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *subtitle;
@property (nonatomic, strong) PunchCard         *punchCard;

- (id)initWithCoord:(CLLocationCoordinate2D)coord;

@end
